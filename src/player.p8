; player.p8
; Part of Monsternest by Ben Cox <cox@djehuti.com>.
; Released under CC-BY-SA-NC license. See LICENSE for details.

%import textio

%import constants
%import soundfx

player {
    ; Maintain the player image.
    sub frame() {
        if inhibit {
            return
        }
        draw()
        animate()
        moveTicks++
    }

    ; Draw the player in the current location and animation step.
    sub draw() {
        if x != lastx or y != lasty or color != lastColor {
            erase()
            if x < displays.screen_width and y < displays.screen_height {
                txt.setcc2(x, y, PLAYER_TILE, color)
            }
            lastx = x
            lasty = y
            lastColor = color
        }
    }

    ; Erase the player from the lastx/lasty position.
    ; Bounds checked, since we use lastx/lasty=$FF to force a redraw.
    sub erase() {
        if lastx < displays.screen_width and lasty < displays.screen_height {
            txt.setcc2(lastx, lasty, BLANK_TILE, $00)
        }
    }

    ; Animate the player image (for now, just cycle the colors).
    sub animate() {
        ticks--
        if ticks != 0 {
            return
        }
        color = (color + 1) & $0F
        if color == color.Black {
            color++ ; skip it
        }
        ticks = COLOR_DURATION
    }

    ; Resets the player to 3 lives, 0 score, middle of the screen.
    sub reset() {
        score = 0
        lives = PLAYER_LIVES
        recenter()
    }

    ; Move the player to the middle of the screen and reset the animation.
    sub recenter() {
        color = 1
        ticks = COLOR_DURATION
        moveTo(displays.screen_width/2, displays.screen_height/2)
    }

    ; Move the player in the given directon in x and y. Clamps to min/max area.
    sub move(byte horiz, byte vert) {
        if moveTicks < MOVE_SPEED {
            return
        }
        byte newx = (x as byte) + horiz
        byte newy = (y as byte) + vert
        if newx < displays.min_player_x {
            newx = displays.min_player_x as byte
        }
        if newx > displays.max_player_x {
            newx = displays.max_player_x as byte
        }
        if newy < displays.min_player_y {
            newy = displays.min_player_y as byte
        }
        if newy > displays.max_player_y {
            newy = displays.max_player_y as byte
        }
        moveTo(newx as ubyte, newy as ubyte)
    }

    ; Move the player to the given position (which is not bounds-checked)
    sub moveTo(ubyte newCol, ubyte newRow) {
        moveTicks = 0
        x = newCol
        y = newRow
        draw() ; if we didn't call this, it would happen next frame anyway
    }

    ; The player has died. Make that happen.
    sub die() {
        if lives == 1 {
            soundEffects.gameOver()
            monsternest.gameOver()
            return
        }
        soundEffects.die()
        lives--
        recenter()
    }

    bool inhibit = false ; when true, our frame func does nothing.

    ubyte x, y, color               ; player location & color
    ubyte lastx, lasty, lastColor   ; last color we drew the player
    ubyte ticks                     ; how long until next color
    ubyte moveTicks                 ; how long since last move

    uword score = 0
    uword lives = PLAYER_LIVES

    const ubyte COLOR_DURATION = 5 ; in frames: 5 => 12 colors/sec
    const ubyte MOVE_SPEED = 6     ; how many frames between moves

    const ubyte PLAYER_LIVES = 3
    const ubyte PLAYER_TILE = tiles.Asterisk
    const ubyte BLANK_TILE = tiles.Space
}
