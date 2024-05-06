; monsternest.p8
; Part of Monsternest by Ben Cox <cox@djehuti.com>.
; Released under CC-BY-SA-NC license. See LICENSE for details.

%zeropage basicsafe
%launcher basic

; Standard library imports
%import syslib
%import textio

; Local library imports
%import framer

; Local imports
%import displays
%import music
%import player
%import startmenu

main {
    sub start() {
        displays.initscreen()

        ; Kick off the game loop
        framer.go(monsternest.start, 0)

        displays.restorescreen()
    }

    sub panic(str message) {
        ; Set your breakpoint here.
        %breakpoint
        displays.restorescreen()
        txt.print(message)
        txt.chrout('\n')
    }
}

monsternest {
    sub start() {
        setup()
        goto startMenu.enter
    }

    sub setup() {
        addFrameTasks()
        installHandlers()
        reset()
    }

    sub reset() {
        player.reset()
    }

    sub addFrameTasks() {
        void framer.addFrameTask(keyboard.frame)     ; keyboard poller
        void framer.addFrameTask(controller.frame)   ; game controller poller

        void framer.addFrameTask(displays.frame)     ; "static" displays

        void framer.addFrameTask(music.frame)        ; handle ongoing music
        void framer.addFrameTask(player.frame)       ; handle player actions
    }

    sub installHandlers() {
        framer.keyHandler = &keystroke
        framer.buttonHandler = &controllerButton
        framer.startSelectHandler = &startSelect
        framer.dpadHandler = &dpad
    }

    sub gameOver() {
        ; TODO: Display a game-over message
        ; TODO: Delay some time.
        ; 
        void framer.addOneShot(startMenu.enter, 0)
    }

    ; Quit the game.
    sub quit() {
        framer.stop()
    }

    ; Handle a keystroke.
    sub keystroke() {
        when keyboard.ch {
            keys.Escape -> {
                void framer.addOneShot(startMenu.enter, 0)
            }
        }
    }

    ; Handle A/B/X/Y
    sub controllerButton() {
        return
    }

    ; Handle Start/Select
    sub startSelect() {
        if controller.joy & control.Start == 0 {
            void framer.addOneShot(startMenu.enter, 0)
        }
    }

    ; Handle the D-Pad
    sub dpad() {
        uword myJoy
        myJoy = controller.joy | ~control.DPAD_MASK
        when myJoy {
            control.Left -> {
                player.move(-1, 0)
            }
            control.Right -> {
                player.move(1, 0)
            }
            control.Up -> {
                player.move(0, -1)
            }
            control.Down -> {
                player.move(0, 1)
            }
        }
        return
    }
}
