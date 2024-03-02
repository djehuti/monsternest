; ////////////////////////////////////////////////////////////////////////////////
; //
; // VIC-20 Joystick routine for Monsternest, by Ben Cox (1983).
; //
; // This file is licensed under a CC BY-SA 4.0 license. See ../LICENSE for details.
; //
; // I originally ported this from a few lines of BASIC code that I had written,
; // that executed painfully slowly in BASIC.
; //
; // WHAT THIS ROUTINE DOES
; //
; // Polls the joystick port of the VIC-20, once, and places the following
; // values in memory locations 1 and 2:
; //
; //   $0001: 1, if the joystick is pressed right; 22 if down. else #0.
; //   $0002: 1 if left, 22 if up, else #0.
; //
; // Why 22? Because the VIC-20 has a 22-column display, and has a
; // memory mapped display of row-major character cells.
; //
; // So if you have the address M of a character cell, then after calling this
; // function, the cell at M+[$01]-[$02] is the adjacent cell in the joystick's
; // direction.
; //
; // TO RUN THIS FROM BASIC:
; //
; //     sys7168:n=o+peek(1)-peek(2)
; //
; // where `o` is the "o"riginal cell address and `n` is the "n"ew address.
; //
; // It's intentional that this routine doesn't support diagonal joystick
; // presses, as that would overcomplicate gameplay, making it harder for the
; // player to quickly visually predict potential outcomes from a shot.
; // Right angles are tricky enough already.
; //
; ////////////////////////////////////////////////////////////////////////////////

*=$1c00       ; load address (7168)

; Constants

; Our output addresses
diradd = $0001
dirsub = $0002

; I/O addresses
via1 = $9110  ; The base address of 6522 VIA #1
via2 = $9120  ; The base address of 6522 VIA #2

; I/O register offsets from via1/via2
portb = 0     ; Offset of input port B
porta = 1     ; Offset of input port A
dirb  = 2     ; Offset of direction register B
dira  = 3     ; Offset of direction register A

; These are all on VIA #1, port A
; These bits are 0 when the switches are closed, 1 when open
joyup    = %00000100  ; switch 0 - up
joydown  = %00001000  ; switch 1 - down
joyleft  = %00010000  ; switch 2 - left
joyfire  = %00100000  ; switch 4 - fire
; This one is on VIA #2, port B
joyright = %10000000  ; switch 3 - right

; Values we will put in those
column = 1
row    = 22

; ////////////////////////////////////////////////////////////////////////////
; Program Starts Here
start
    ; Clear our outputs.
    lda #0
    sta diradd
    sta dirsub

    ; Set the joystick bit of the VIA #2 port B to input.
    lda via2+dirb
    tay                        ; Save this value in Y for later
    and #(%11111111 ^ joyright)
    sta via2+dirb

    ; Set the joystick bits of the VIA #1 Port A to input.
    lda via1+dira
    and #(%11111111 ^ (joyup | joydown | joyleft | joyfire))
    sta via1+dira

checkright
    lda via2+portb
    and #joyright
    bne checkdown

    ; Put 1 column in the "add" output (move right)
    lda #column
    sta diradd
    jmp finished

checkdown
    lda via1+porta
    tax                        ; Save this value in X for reuse
    and #joydown
    bne checkleft

    ; Put 1 row in the "add" output (move down)
    lda #row
    sta diradd
    jmp finished

checkleft
    txa                        ; reuse the X value
    and #joyleft
    bne checkup

    ; Put 1 column in the "subtract" output (move left)
    lda #column
    sta dirsub
    jmp finished

checkup
    txa                        ; reuse the X value
    and #joyup
    bne finished

    ; Put 1 row in the "subtract" output (move up)
    lda #row
    sta dirsub

finished
    ; Restore the state of VIA #1, which we saved in the Y register.
    tya
    sta via2+dirb
    rts
