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
via1 = $9110  ; The base address of 6522 VIA #1
via2 = $9120  ; The base address of 6522 VIA #2

portb = 0     ; Offset of input port B
porta = 1     ; Offset of input port A
dirb  = 2     ; Offset of direction register B
dira  = 3     ; Offset of direction register A

; These are all on VIA #1, port A
; These bits are 0 when the switches are closed, 1 when open
joy1a0 = %00000100  ; switch 0 - up
joy1a1 = %00001000  ; switch 1 - down
joy1a2 = %00010000  ; switch 2 - left
fire1a = %00100000  ; fire button

; This on is on VIA #2, port B
joy2b3 = %10000000  ; switch 3 - right

; Bit masks (single-byte)
allbits    = %11111111
initial1a  = %10000000                          ; Serial ATN out, all alse in.
initial2b  = allbits                            ; all out
relevant1a = joy1a0 | joy1a1 | joy1a2 | fire1a  ; %00111100 ($3c)
relevant2b = joy2b3                             ; %10000000 ($80)
mask1a     = allbits ^ relevant1a               ; %11000011 ($c3)
mask2b     = allbits ^ relevant2b               ; %01111111 ($7f)

; Our outputs
diradd = $0001
dirsub = $0002

; Values we will put in those
column = 1
row    = 22

; ////////////////////////////////////////////////////////////////////////////
; Program Starts Here
start
    ; Set the VIA #1 port A direction bits to their initial state.
    lda #initial1a
    sta via1+dira

    ; Clear our outputs.
    lda #0
    sta diradd
    sta dirsub

    ; Set the direction of the relevant VIA#2 port B bits to input
    lda #mask2b
    sta via2+dirb

    ; This is the bug. We're checking all 8 bits, but we only care about bit 7 (joy2b3).
checkright
    ;     10000000 relevant2b (=joy2b3)
    ;     0        pattern we're checking equality to
    ;      1110111 bits we are checking and expecting but don't actually care about (BUG)
    ldx #%01110111
    cpx via2+portb
    bne restorevia2

    ; Put 1 column in the "add" output (move right)
    lda #column
    sta diradd

    ; Set all of the VIA 2B port pins back to output.
restorevia2
    lda #initial2b
    sta via2+dirb

checkdown
    ;     00111100 relevant1a
    ;       1101   pattern we want - bits 2/4/5 on (open), bit 3 off (closed) - down ONLY
    ;     01    10 bits we are checking and expecting but don't actually care about (BUG)
    ldx #%01110110
    cpx via1+porta
    bne checkleft

    ; Put 1 row in the "add" output (move down)
    lda #row
    sta diradd

checkleft
    ;     00111100 relevant1a
    ;       1011   pattern we want - bits 2/3/5 on (open), bit 4 off (closed) - left ONLY
    ;     01    10 bits we are checking and expecting but don't actually care about (BUG)
    ldx #%01101110
    cpx via1+porta
    bne checkup

    ; Put 1 column in the "subtract" output (move left)
    lda #column
    sta dirsub

checkup
    ;     00111100 relevant1a
    ;       1110   pattern we want - bits 3/4/5 on (open), bit 2 off (closed) - up ONLY
    ;     01    10 bits we are checking and expecting but don't actually care about (BUG)
    ldx #%01111010
    cpx via1+porta
    bne finished

    ; Put 1 row in the "subtract" output (move up)
    lda #row
    sta dirsub

finished
    rts
