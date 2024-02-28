; ////////////////////////////////////////////////////////////////////////////////
; //
; // DISASSEMBLED
; //
; ////////////////////////////////////////////////////////////////////////////////

*=$1c00 ; load address (7168)


    lda #$80              ; $1C00 A9 80           load/store A
    sta $9113             ; $1C02 8D 1391 
    lda #$00              ; $1C05 A9 00           load/store A
    sta $01               ; $1C07 85 01   
    sta $02               ; $1C09 85 02   
    lda #$7f              ; $1C0B A9 7F           load/store A
    sta $9122             ; $1C0D 8D 2291 
    ldx #$77              ; $1C10 A2 77   
    cpx $9120             ; $1C12 EC 2091 
    bne label0            ; $1C15 D0 04   
    lda #$01              ; $1C17 A9 01           load/store A
    sta $01               ; $1C19 85 01   

label0
    lda #$ff              ; $1C1B A9 FF           load/store A
    sta $9122             ; $1C1D 8D 2291 
    ldx #$76              ; $1C20 A2 76   
    cpx $9111             ; $1C22 EC 1191 
    bne label1            ; $1C25 D0 04   
    lda #$16              ; $1C27 A9 16           load/store A
    sta $01               ; $1C29 85 01   

label1
    ldx #$6e              ; $1C2B A2 6E   
    cpx $9111             ; $1C2D EC 1191 
    bne label2            ; $1C30 D0 04   
    lda #$01              ; $1C32 A9 01           load/store A
    sta $02               ; $1C34 85 02   

label2
    ldx #$7a              ; $1C36 A2 7A   
    cpx $9111             ; $1C38 EC 1191 
    bne label3            ; $1C3B D0 04   
    lda #$16              ; $1C3D A9 16           load/store A
    sta $02               ; $1C3F 85 02   

label3
    rts                   ; $1C41 60              return
