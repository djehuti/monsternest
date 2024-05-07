; startmenu.p8
; Part of Monsternest by Ben Cox <cox@djehuti.com>.
; Released under CC-BY-SA-NC license. See LICENSE for details.

; Standard library imports
%import syslib
%import textio

; Local library imports
%import framer

startMenu {
    ; Enter the start menu.
    sub enter() {
        player.erase()

        ; install our own keyboard and joystick handlers
        installHandlers()

        ; Save the portion of the screen that we'll overdraw
        saveScreen()

        ; Draw the "window" and the text
        txt.color(color.Red)
        txt.plot(7, 10)
        txt.print("q=quit, esc=resume")
        ; TODO
    }

    ; Go back to the game.
    sub exit() {
        restoreScreen()
        restoreHandlers()
    }

    ; Put our handlers in place of the game handlers.
    sub installHandlers() {
        oldKeyHandler = framer.keyHandler
        oldButtonHandler = framer.buttonHandler
        oldStartHandler = framer.startSelectHandler
        oldDpadHandler = framer.dpadHandler
        oldInhibit = player.inhibit

        framer.keyHandler = &keystroke
        framer.buttonHandler = 0
        framer.startSelectHandler = &startSelect
        framer.dpadHandler = 0
        player.inhibit = true
    }

    sub restoreHandlers() {
        framer.keyHandler = oldKeyHandler
        framer.buttonHandler = oldButtonHandler
        framer.startSelectHandler = oldStartHandler
        framer.dpadHandler = oldDpadHandler
        player.inhibit = oldInhibit
    }

    sub keystroke() {
        if keyboard.ch == keys.Escape {
            exit()
        }
        if keyboard.ch == 'q' {
            monsternest.quit()
        }
    }

    sub startSelect() {
        if controller.joy & control.Start == 0 {
            exit()
        }
    }

    sub saveScreen() {
        ; TODO
        return
    }

    sub restoreScreen() {
        ; TODO
        txt.color(color.Black)
        txt.plot(7, 10)
        txt.print("                  ")
        return
    }

    bool oldInhibit
    uword oldKeyHandler
    uword oldButtonHandler
    uword oldStartHandler
    uword oldDpadHandler
}
