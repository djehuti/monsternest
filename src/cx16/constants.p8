; constants.p8
; Part of Monsternest
; Ben Cox, 2024, released under CC license.

color {
    const ubyte Transparent = $0
    const ubyte Black       = $0
    const ubyte White       = $1
    const ubyte Red         = $2
    const ubyte Cyan        = $3
    const ubyte Purple      = $4
    const ubyte Green       = $5
    const ubyte Blue        = $6
    const ubyte Yellow      = $7
    const ubyte Orange      = $8
    const ubyte Brown       = $9
    const ubyte LightRed    = $A
    const ubyte Grey1       = $B
    const ubyte Grey2       = $C
    const ubyte LightGreen  = $D
    const ubyte LightBlue   = $E
    const ubyte Grey3       = $F
}

control {
    const uword Right  = %1111111111111110
    const uword Left   = %1111111111111101
    const uword Down   = %1111111111111011
    const uword Up     = %1111111111110111
    const uword Start  = %1111111111101111
    const uword Select = %1111111111011111
    const uword Y      = %1111111110111111
    const uword B      = %1111111101111111
    const uword R      = %1110111111111111
    const uword L      = %1101111111111111
    const uword X      = %1011111111111111
    const uword A      = %0111111111111111
}

screenmode {
    const ubyte Tile80x60 = $00
    const ubyte Tile80x30 = $01
    const ubyte Tile40x60 = $02
    const ubyte Tile40x30 = $03
    const ubyte Tile40x15 = $04
    const ubyte Tile20x30 = $05
    const ubyte Tile20x15 = $06
    const ubyte Tile22x23 = $07
    const ubyte Tile64x50 = $08
    const ubyte Tile64x25 = $09
    const ubyte Tile32x50 = $0A
    const ubyte Tile32x25 = $0B
    const ubyte Mixed320c = $80
}
