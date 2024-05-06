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
        oldInhibit = player.inhibit
        player.inhibit = true
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
        void framer.addOneShot(monsternest.installHandlers, 0)
        txt.color(color.Black)
        txt.plot(7, 10)
        txt.print("                  ")
        player.inhibit = oldInhibit
    }

    ; Put our handlers in place of the game handlers.
    sub installHandlers() {
        framer.keyHandler = &keystroke
        framer.buttonHandler = 0
        framer.startSelectHandler = &startSelect
        framer.dpadHandler = 0
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
        return
    }

    bool oldInhibit
}
