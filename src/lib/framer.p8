; framer.p8 - Miniature frame-based app/task framework.
; by Ben Cox <cox@djehuti.com>
; Released under Creative Commons; see LICENSE for details.
; See README.md for (minimal) documentation, and comments below.

%import syslib
%option ignore_unused

%import constants

framer {
    ; Call this to initialize the task runner and have it run the given
    ; function with the given arg, on the first iteration. That function
    ; can add other work (like frame tasks) from there.
    sub go(uword kickoff, uword arg) {
        reset()
        void addOneShot(kickoff, arg)
        goto resume
    }

    ; Call this to resume the runner (like calling go without resetting or
    ; adding a task).
    sub resume() {
        framerPrivate.done = false
        ; Check to see if there's anything to actually do first.
        framerPrivate.checkDone()
        while not framerPrivate.done {
            runTasks()
            sys.waitvsync()
            framerPrivate.checkDone()
        }
    }

    ; Call this function to stop the runner (and make go/resume return).
    sub stop() {
        framerPrivate.done = true
    }

    ; Initializes the task lists. You only need to call this if you want
    ; to run the loop yourself; it is called first by go().
    sub reset() {
        clearFrameTasks()
        clearOneShots()
    }

    ; Clears the frame task list. If you call this, the frame loop
    ; will run the already-scheduled frame tasks and then quit.
    sub clearFrameTasks() {
        framerPrivate.frameTaskCount = 0
    }

    ; Clear any pending one-shots.
    sub clearOneShots() {
        framerPrivate.oneShotHead = 0
        framerPrivate.oneShotTail = 0
    }

    ; Add a permanent frame task to the end of the list.
    ; Returns true on success, or false if there's no more room for
    ; frame tasks. These aren't dynamic, so if you need more than a few
    ; of these, you should think about combining some. (You only ever
    ; _really_ need one.)
    ; Also returns false if you pass null, because just why.
    sub addFrameTask(uword newTask) -> ubyte {
        if framerPrivate.frameTaskCount == framerPrivate.MAXFRAMETASKS {
            return $FF
        }
        ubyte frameTaskIndex = framerPrivate.frameTaskCount
        framerPrivate.frameTasks[frameTaskIndex] = newTask
        framerPrivate.frameTaskCount++
        return frameTaskIndex
    }

    ; Adds a new item to the tail of the list and advances it, to
    ; be run on the next frame (the next trip through runTasks).
    ; Returns false if the new task is null (don't do that), or
    ; if there isn't room for this in the task buffer.
    sub addOneShot(uword newTask, uword newTaskArg) -> bool {
        if newTask == 0 {
            return false
        }
        ubyte newWorkTail = (framerPrivate.oneShotTail + 1) & framerPrivate.ONESHOT_MASK ; can this be in a reg?
        if newWorkTail == framerPrivate.oneShotHead {
            ; This would fill the last slot in the ringbuffer which we
            ; can't tell from it being empty, so don't let it happen.
            return false
        }
        ; All good; pop it in.
        framerPrivate.oneShots[framerPrivate.oneShotTail] = newTask
        framerPrivate.oneShotArgs[framerPrivate.oneShotTail] = newTaskArg
        framerPrivate.oneShotTail = newWorkTail
        return true
    }

    ; Call this once per frame (go/resume does that). You only need to call
    ; this directly if you manage your own main loop; not if you use go/resume.
    sub runTasks() {
        framerPrivate.runFrameTasks()
        framerPrivate.runOneShots()
    }

    ; Task work functions can check this (global) value for their argument.
    ; The value that was passed to addOneShot is placed here before the
    ; work function is called. For frame tasks, this will be ==workIndex.
    uword @zp workArg = 0 ; todo: Can I just use r0 for this?

    uword keyHandler = 0
    uword buttonHandler = 0
    uword startSelectHandler = 0
    uword dpadHandler = 0
} ; framer

keyboard {
    sub frame() {
        if framer.keyHandler != 0 {
            void, ch = cbm.GETIN()
            if ch != 0 {
                ; At this point we have removed the first key in the buffer;
                ; it is in keyboard.ch when the handler starts. (And in the
                ; framer.workArg variable, as a uword.)
                ;
                ; If keyHandler wants to process more than one keystroke per
                ; frame (which I'm not 100% sure the kernal will ever actually
                ; generate), it should call cbm.GETIN until the buffer is empty.
                ; If it leaves the buffer non-empty, the next character will
                ; be sent to keyHandler() again on the next frame.
                ;
                ; Any frame task after this one (or before this one on the next
                ; frame) could read keyboard.ch and act on it; thus, more than one
                ; can use a single keystroke per frame. If you don't want that,
                ; your keyHandler function can set keyboard.ch to 0 and none of the
                ; subsequent frame tasks will see it.

                framer.workArg = ch as uword
                goto framer.keyHandler ; save a stack frame
            }
        }
    }

    ubyte ch
} ; keyboard

controller {
    sub frame() {
        ubyte joynr
        uword value

        ; Collect the joystick switch values
        if joymask == 0 or
            (framer.buttonHandler == 0) and
            (framer.startSelectHandler == 0) and
            (framer.dpadHandler == 0) {
            return
        }

        joy = $FFFF
        for joynr in 0 to 4 {
            if joymask & (1 << joynr) != 0 {
                value, void = cx16.joystick_get(joynr)
                ; Bits go to 0 when the switches close; AND them together
                joy &= value
            }
        }

        ; Dispatch to the handlers.
        framer.workArg = joy
        if framer.buttonHandler != 0 and joy & control.ABXY_MASK != control.ABXY_MASK {
            void call(framer.buttonHandler)
        }
        if framer.startSelectHandler != 0 and joy & control.SSEL_MASK != control.SSEL_MASK {
            void call(framer.startSelectHandler)
        }
        if framer.dpadHandler != 0 and joy & control.DPAD_MASK != control.DPAD_MASK {
            void call(framer.dpadHandler)
        }
    }

    uword joy
    ubyte joymask = $1F ; Which joysticks will be polled
} ; controller

; ---------------------------------------------------------------
; Everything below this point is private and shouldn't be relied on.

framerPrivate {
    ; Run through the whole list of frame tasks and call them all.
    sub runFrameTasks() {
        if frameTaskCount == 0 {
            return
        }
        for workIndex in 0 to frameTaskCount - 1 {
            if done {
                return
            }
            workFunc = frameTasks[workIndex]
            if workFunc != 0 {
                framer.workArg = workIndex
                void call(workFunc)
            }
        }
    }

    ; Runs through all the one-shot tasks that are currently added. Those that
    ; are added after this routine starts won't happen until the next frame.
    sub runOneShots() {
        if done {
            return
        }
        ubyte @zp startTail = oneShotTail
        workIndex = oneShotHead
        while workIndex != startTail {
            workFunc = oneShots[workIndex]
            framer.workArg = oneShotArgs[workIndex]
            ; Advance the head
            workIndex = (workIndex + 1) & ONESHOT_MASK
            oneShotHead = workIndex
            void call(workFunc)
            if done {
                return
            }
        }
    }

    ; Checks whether we have no more work to do (shortcut if already stopped).
    sub checkDone() {
        done = done or (frameTaskCount == 0 and oneShotHead == oneShotTail)
    }

    ; ---------------------------------------------------------------
    ; Storage

    ; Loop variables.

    bool @requirezp done = false   ; used by stop/go/resume
    ubyte @requirezp workIndex = 0 ; which task are we running? could be a reg
    uword @requirezp workFunc = 0  ; address of the work function

    ; Data for the frame tasks table.
    ubyte @zp frameTaskCount = 0
    const ubyte MAXFRAMETASKS = 32      ; should be way more than enough, can't
    uword[MAXFRAMETASKS] frameTasks = 0 ; be >128 due to prog8 array limit.

    ; Data for the one-shot work functions. This is a ringbuffer.
    ; Each spot in the ringbuffer occupies 2 words; one word is the
    ; address of the work function, and the other is the argument to
    ; be passed (in workArg) to the work function. (That is: we set
    ; the workArg variable, which is global, to the arg value before
    ; calling the work func.)

    const ubyte ONESHOTS = 128 ; must be a power of 2, limited to 128 by prog8.

    ; With ONESHOTS=128 (the max) these tables occupy 512 bytes.
    uword[ONESHOTS] oneShots = 0
    uword[ONESHOTS] oneShotArgs = 0

    ; If head==tail, the ringbuffer is empty. The indices wrap around when
    ; ANDed with the mask (why it has to be a power of 2).
    const ubyte ONESHOT_MASK = ONESHOTS-1
    ubyte @zp oneShotTail = 0  ; Tail is the next slot to be filled
    ubyte @zp oneShotHead = 0  ; Head is the next slot to be executed
} ; framerPrivate
