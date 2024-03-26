# Monsternest

**Monsternest** is a game that I wrote some time in 1983.
There are both VIC-20 and C-64 versions here.
I wrote the VIC-20 version first (since I got a VIC-20
on December 18, 1982).

The code is ... not great. It occurs to me that I should
point out that I was 13 when I wrote this.

Why am I sharing this? Because in spite of the sheer junkiness
of the programming of the game (again: I was 13), it's actually
a pretty challenging and fun little game, and if it had a
decent implementation it might be fun for more people than just me.

And because I think it has some vintage retro goodness to it,
with that warm authentic vinyl sound, and that it's fun to look
at how this sort of tiny game can evolve from "garbage basic"
into something better. (See CX16, below.)

## Commodore VIC-20

There's one printout of the VIC-20 version of the game.
It has a scrawled copyright change on it from when my friend
and I tried to sell it.
As a cassette in a baggie in the local computer shop.

We sold one copy; it didn't work on the customer's machine,
though, and I suspected at the time that it was because he had
a RAM expansion cartridge which changed some I/O mappings.
I never could reproduce the issue, though, so I couldn't fix it,
so we had to refund the customer's money.

But now that VICE is a thing, I have reproduced the problem and,
41 years later, fixed it.

The issue was that I was testing some I/O bits that I should have
masked out, in my assembler joystick-read routine.
(To read the joystick on the VIC-20, you have to fiddle with I/O
ports, which in this case is done in assembler.)

This version is frozen and won't receive further development.

## Commodore 64

There's a C64 version here as well. This one is completely in BASIC.
It seems to work, and is as I remember it. Ironically I think the sound
is a little better on the VIC-20 version, although I do love the
volume-flapping effect.

This version is frozen and won't receive further development.
I never was super-fund of the chunky font on the C64, either.

This version is frozen and won't receive further development.

## Commodore 128

There was also a C128 printout in the folder.
I've entered it in, but I haven't gotten it working and haven't
confirmed the accuracy of my transcription.

I probably won't bother to fix this version because I don't really
care that much about the C128. (My C128 nostalgia is for CP/M.)

## Commander X16

I've done an initial BASLOAD port of the game to Commander X16, with
"the obvious" changes only. I used BASLOAD because it's easier to make
the porting changes in X16EDIT and not worry about line numbers and such.
(I did the port in X16EDIT and used the BASLOAD tool command.)

A prog8 port is coming, and I'll base further improvements on that version.

## Copyright

[Monsternest](https://github.com/djehuti/monsternest) &#127341; 1983
by [Ben Cox](https://github.com/djehuti)
is licensed under
[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)

See the file LICENSE for further information.
