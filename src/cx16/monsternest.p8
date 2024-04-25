; Monsternest
; Ben Cox, 1983.
; Ported to Commander X16 (and prog8) by Ben Cox, 2024.

%zeropage basicsafe
%launcher basic

%import floats
%import syslib
%import textio

%import constants

main {
    ; Program entry point.
    sub start() {
        initscreen()    ; set up the screen
        intro()         ; introduce the game and offer instructions
        playGame()      ; play it
        restorescreen() ; what it says
        return
    }

    ; Set up the screen. We are going to use mode $80, with a 320x240
    ; bitmap layer behind a 40x30 tile layer.
    sub initscreen() {
        origMode = 0 ; cx16.get_screen_mode()
        void cx16.set_screen_mode(screenmode.Mixed320c)
        txt.iso_off()
        txt.uppercase()
        cx16.screen_set_charset(2, 0) ; fat c64 font
        txt.color2(color.Blue, color.White)
        txt.clear_screen()
        return
    }

    ; Restore the screen for BASIC.
    sub restorescreen() {
        void cx16.set_screen_mode(origMode)
        txt.iso_off()
        txt.uppercase()
        cx16.screen_set_charset(2, 0) ; the fat c64 font is also the default
        txt.color2(color.White, color.Blue)
        txt.clear_screen()
        return
    }

    ; Show a splash screen and offer instructions (and show them if desired).
    sub intro() {
        txt.plot(14, 9)
        txt.color(color.Red)
        txt.print("monsternest")

        txt.plot(14, 11)
        txt.color(color.Purple)
        txt.print("1983 ** cox")

        txt.plot(13, 13)
        txt.color(color.Cyan)
        txt.print("instructions?")
        txt.plot(13, 14)
        repeat 13 { txt.chrout($A3) } ; this underlines "instructions"

        txt.plot(15, 15)
        txt.color(color.Yellow) ; yellow
        txt.print("(y or n)")

        do {
            void, ch = cbm.GETIN()
        } until ch == $59 or ch == $4E ; Y/N
        if ch == $59 { ; Y
            instructions()
        }

        return
    }

    ; Show the instructions screen.
    sub instructions() {
        txt.clear_screen()
        txt.plot(0, 0)
        txt.color(color.Purple)
        txt.print("you are the * in the middle of the")
        txt.plot(0, 2)
        txt.color(color.Yellow)
        txt.print("screen. you move around the screen by")
        txt.plot(0, 4)
        txt.color(color.Green)
        txt.print("pushing the joystick in the direction")
        txt.plot(0, 6)
        txt.color(color.Blue)
        txt.print("you want to go. you must destroy \x12100\x92\x91\x9D\x9D\x9D___")
        txt.plot(0, 8)
        txt.color(color.Orange)
        txt.print("of the eggs (W) of the dragon by pushing")
        txt.plot(0, 10)
        txt.color(color.Red)
        txt.print("the a, b, x or y buttons to fire in one")
        txt.plot(0, 12)
        txt.color(color.LightBlue)
        txt.print("of the four directions at an egg.")
        txt.plot(0, 14)
        txt.color(color.LightRed)
        txt.print("it will either die or hatch (!)")
        txt.plot(0, 16)
        txt.color(color.Purple)
        txt.print("if it hatches, it will shoot a stream of")
        txt.plot(0, 17)
        txt.color(color.Red)
        txt.print("_______________")
        txt.plot(0, 18)
        txt.print("\x12poisonous blood\x92 in a random direction.")
        txt.plot(8, 28)
        txt.color(color.Cyan)
        txt.print("\x12 hit 'space' to continue \x92")
        do {
            void, ch = cbm.GETIN()
        } until ch == $20
        txt.clear_screen()
        txt.plot(0, 0)
        txt.color(color.Red)
        txt.print("if you touch this \x12poisonous blood\x92, or")
        txt.plot(0, 2)
        txt.color(color.Purple)
        txt.print("a hatched baby dragon, the game will")
        txt.plot(0, 4)
        txt.color(color.Blue)
        txt.print("end. if you touch an egg, you will lose")
        txt.plot(0, 6)
        txt.color(color.Green)
        txt.print("one life (you get three).")
        txt.plot(0, 8)
        txt.color(color.Yellow)
        txt.print("if you shoot \x12100\x92\x91\x9D\x9D\x9D___\x11 of the eggs,")
        txt.plot(0, 10)
        txt.color(color.Orange)
        txt.print("a new screenfull will appear.")
        txt.plot(0, 12)
        txt.color(color.Red)
        txt.print("good luck.")
        txt.plot(8, 27)
        txt.print("\x12 press 'start' to start \x92")
        findjoy()
        return
    }

    ; Wait for "Start" to be pressed on one of the joysticks. When one is,
    ; return and set variable `joynr` to its index.
    sub findjoy() {
        repeat {
            for i in 0 to 4 {
                joy, void = cx16.joystick_get(i)
                if (joy & ~control.Start) == 0 {
                    joynr = i
                    return
                }
            }
        }
    }

    ; Actually play the game. If this function returns, play again.
    sub playGame() {
    top:
        askSkill()
        sys.wait(20) ; 1/3 second

        score = 0
        lifeCount = 3
        gameOverMan = 0
        tick = 0

        cx16.screen_set_charset(4, 0)

        newScreen()

        repeat {
            maint()
            doPlayerAction()
            doOpponentAction()

            if lifeCount < 1  or gameOverMan != 0 {
                break
            }
            if eggsShot >= eggsShotThreshold {
                newScreen()
            }
        }

        if gameOver() {
            goto top
        }

        return
    }

    sub maint() {
        sys.waitvsync()
        tick += 1
        drawScoreboard()
        drawOpponents()
        drawPlayer()
        return
    }

    ; Start a new screenful of eggs.
    sub newScreen() {
        center()
        spawnEggs()
        return
    }

    ; Ask the player for a skill level (1-3) and recompute the player's shot
    ; range from it. (27-7*skill)
    sub askSkill() {
        txt.color(color.Red)
        txt.clear_screen()
        txt.print("skill level (1-3)? ")
        txt.chrout($A4) ; <underscore>

        ; TODO: Use the Select button to radio-button between levels,
        ; and Start to confirm one
        do {
            void, ch = cbm.GETIN()
        } until ch >= $31 and ch <= $33 ; between '1' and '3'

        skill = ch - $30 ; subtract '0'
        shotRange = 27 - 7*skill
        txt.chrout($9D) ; <left>
        txt.chrout(ch)  ; skill char
        txt.chrout($A4) ; <underscore>

        return
    }

    ; Create a screen full of eggs.
    sub spawnEggs() {
        txt.clear_screen()
        eggsShot = 0
        repeat eggsPerScreen {
            do {
                xcoord = floats.floor(floats.rnd()*maxX) as ubyte
                ycoord = floats.floor(floats.rnd()*(maxY-2))+2 as ubyte
            } until xcoord != playerX or ycoord != playerY
            txt.setcc2(xcoord, ycoord, eggTile, color.Brown)
        }
        return
    }

    ; Draw the scoreboard at the top of the screen.
    sub drawScoreboard() {
        txt.color(color.Red)
        txt.plot(3, 0)
        txt.print("* * * m o n s t e r n e s t * * *")

        txt.plot(0, 1)
        repeat lifeCount {
            txt.chrout('*')
        }
        repeat 3-lifeCount {
            txt.chrout(' ')
        }

        txt.plot(19, 1)
        txt.print("score: ")
        txt.print_uw(score)
        txt.print("     ")

        return
    }

    ; Draw any moving opponents.
    sub drawOpponents() {
        ; Nothing to do; there are no moving opponents.
        return
    }

    ; Draw the player.
    sub drawPlayer() {
        if tick - lastColorTick >= 4 {
            ; We'll cycle through the colors for the character.
            curcolor = (curcolor + 1) & $0F
            ; 0 is transparent; don't use it.
            ; 1 is white; don't use that either.
            if curcolor < color.Red {
                curcolor = color.Red
            }
            lastColorTick = tick
        }
        txt.setcc2(playerX, playerY, playerTile, curcolor)
        return
    }

    ; Get the player's input and take the action the user wants.
    sub doPlayerAction() {
        if tick - lastMoveTick < 6 {
            return
        }
        newX = playerX
        newY = playerY
        joy, void = cx16.joystick_get(joynr)
        when joy {
            control.Left -> {
                newX = newX - 1
            }
            control.Right -> {
                newX = newX + 1
            }
            control.Down -> {
                newY = newY + 1
            }
            control.Up -> {
                newY = newY - 1
            }
            control.B -> { ; B (shoot down)
                shoot(0, 1)
                return
            }
            control.Y -> { ; Y (shoot left)
                shoot(-1, 0)
                return
            }
            control.X -> { ; X (shoot up)
                shoot(0, -1)
                return
            }
            control.A -> { ; A (shoot right)
                shoot(1, 0)
                return
            }
        }
        if newX == playerX and newY == playerY {
            return
        }
        ; Remove the player from the screen.
        txt.setcc2(playerX, playerY, blankTile, color.Transparent)
        ; See if the player moved off the edge of the screen.
        if newX >= maxX or newY < 2 or newY >= maxY {
            return
        }
        ubyte whatsthere = txt.getchr(newX, newY)
        when whatsthere {
            eggTile -> {
                dodie()
                return
            }
            dragonTile -> {
                doGameOver()
                return
            }
            ichorTile -> {
                doGameOver()
                return
            }
        }
        playerX = newX
        playerY = newY
        lastMoveTick = tick
        return
    }

    sub shoot(byte sx, byte sy) {
        bool hit = false
        for i in 1 to shotRange {
            xcoord = ((playerX as byte) + (i as byte)*sx) as ubyte
            ycoord = ((playerY as byte) + (i as byte)*sy) as ubyte
            if xcoord >= maxX or ycoord < 2 or ycoord >= maxY {
                return
            }
            ; Look to see what's there
            ubyte whatsthere = txt.getchr(xcoord, ycoord)
            ubyte clr = txt.getclr(xcoord, ycoord) ; save the color
            txt.setcc2(xcoord, ycoord, shotTile, color.Red)
            when whatsthere {
                eggTile -> {
                    hit = true
                    break
                }
            }
            repeat 4 { maint() } ; we're not cycling the main loop, so just do this part
            txt.setcc2(xcoord, ycoord, whatsthere, clr)
        }
        if hit {
            killegg(false)
        }
        return
    }

    sub killegg(bool autohatch) {
        score += 10
        eggsShot += 1
        txt.setcc2(xcoord, ycoord, blankTile, color.Transparent)
        if autohatch or floats.rnd() < 0.55 {
            hatch(xcoord, ycoord)
        }
        return
    }

    sub hatch(ubyte eggx, ubyte eggy) {
        txt.setcc2(eggx, eggy, dragonTile, color.Green)
        bool hit = false
        ; Choose a direction
        byte dir = 1
        byte sx
        byte sy
        if floats.rnd() < 0.5 {
            dir = -1
        }
        if floats.rnd() < 0.5 {
            sx = dir
            sy = 0
        } else {
            sx = 0
            sy = dir
        }
        for i in 1 to 5 {
            xcoord = ((eggx as byte) + (i as byte)*sx) as ubyte
            ycoord = ((eggy as byte) + (i as byte)*sy) as ubyte
            if xcoord >= maxX or ycoord <2 or ycoord >= maxY {
                return
            }
            ; Look to see what's there
            ubyte whatsthere = txt.getchr(xcoord, ycoord)
            txt.setcc2(xcoord, ycoord, ichorTile, color.Red)
            when whatsthere {
                eggTile -> {
                    hit = true
                    break
                }
                playerTile -> {
                    doGameOver()
                    return
                }
            }
            repeat 4 { maint() } ; we're not cycling the main loop, so just do this part
        }
        if hit {
            killegg(true)
        }
        return
    }

    ; Make moves for any opponents.
    sub doOpponentAction() {
        ; Nothing to do; there are no moving opponents.
        return
    }

    ; Show the "game over" screen and offer a replay.
    sub gameOver() -> bool {
        txt.clear_screen()
        cx16.screen_set_charset(2, 0)

        txt.color(2)
        txt.print("you got killed 3 times and had a score\nof ")
        txt.print_uw(score)
        txt.print(". to play again,\ntype the space bar. ")
        txt.print("to quit, type q.")

        do {
            void, ch = cbm.GETIN()
        } until ch == $20 or ch == $51 ; space/Q

        ; Return true if the user wants to play again.
        return (ch == $20)
    }

    sub dodie() {
        center()
        lifeCount -= 1
        playDieSound()
        sys.wait(5)
        return
    }

    sub doGameOver() {
        playDieSound()
        gameOverMan = $FF
        sys.wait(5)
        return
    }

    sub playDieSound() {
        return
    }

    sub center() {
        playerX = (maxX-1)/2
        playerY = (maxY-3)/2+2
        return
    }

    ; -------------------------------------------------------------------------

    uword @zp tick = 0

    ; Screen tilemap size
    const ubyte maxX = 40
    const ubyte maxY = 30

    ; Saved screen mode before game starts
    ubyte origMode

    ; Player position
    uword lastMoveTick = 0
    uword lastColorTick = 0
    ubyte @zp playerX = maxX/2
    ubyte @zp playerY = maxY/2
    ubyte newX
    ubyte newY
    ubyte curcolor = 0

    ; Skill level and shot range
    ubyte skill
    ubyte shotRange
    const ubyte eggsPerScreen = 150
    const ubyte eggsShotThreshold = 100

    ; Score, lives-remaining, and eggs shot on this screen.
    uword score = 0
    ubyte lifeCount = 3
    ubyte eggsShot = 0
    ubyte gameOverMan = 0

    ; Keyboard input
    ubyte @zp ch

    ; Which joystick?
    ubyte @zp joynr
    uword @zp joy
 
    ; temp computations
    ubyte @zp i
    ubyte @zp xcoord
    ubyte @zp ycoord

    ; Tile IDs
    const ubyte blankTile = 32
    const ubyte playerTile = $2A
    const ubyte eggTile = $57
    const ubyte dragonTile = $5E
    const ubyte ichorTile = $56
    const ubyte shotTile = '.'
}
