; displays.p8
; Part of Monsternest by Ben Cox <cox@djehuti.com>.
; Released under CC-BY-SA-NC license. See LICENSE for details.

%import syslib

%import constants

displays {
    sub initscreen() {
        void cx16.set_screen_mode(screenmode.Tile32x25)
        screen_width = txt.width()
        screen_height = txt.height()
        max_player_x = screen_width - 1
        max_player_y = screen_height - 1
        min_player_x = 0
        min_player_y = 2 ; 2 lines for score and banner

        ; Draw the banner at the top of the screen.
        txt.color(color.Orange)
        txt.plot(displays.screen_width/2 - 10, 0) ; half the string
        txt.print("*** monsternest ***") ; this is 19 character; 10=half
    }

    sub restorescreen() {
        cbm.CINT()
    }

    sub frame() {
        playerLives.frame()
        showScore.frame()
    }

    ubyte screen_width, screen_height
    ubyte max_player_x, max_player_y
    ubyte min_player_x, min_player_y
}

playerLives {
    sub frame() {
        if player.lives == last {
            return
        }
        last = player.lives

        ubyte i
        for i in 1 to 3 {
            if i <= last {
                txt.setcc2(LIVES_X+i-1, LIVES_Y, LIFE_TILE, ALIVE_COLOR)
            } else {
                txt.setcc2(LIVES_X+i-1, LIVES_Y, LIFE_TILE, DEAD_COLOR)
            }
        }
    }

    uword last = $FFFF
    ; Where does the playerLives display go?
    const ubyte LIVES_X = 0
    const ubyte LIVES_Y = 1
    const ubyte LIFE_TILE = player.PLAYER_TILE
    const ubyte ALIVE_COLOR = color.Cyan
    const ubyte DEAD_COLOR = color.Grey1
}

showScore {
    sub frame() {
        if player.score == last {
            return
        }
        last = player.score

        txt.color(color.Grey3)
        txt.plot(displays.screen_width - 5, SCORE_Y) ; score can be 5 digits

        ; Print leading spaces
        if last < 10000 {
            txt.chrout(' ')
            if last < 1000 {
                txt.chrout(' ')
                if last < 100 {
                    txt.chrout(' ')
                    if last < 10 {
                        txt.chrout(' ')
                    }
                }
            }
        }

        txt.print_uw(last)
    }

    uword last = $FFFF
    const ubyte SCORE_Y = 1
}
