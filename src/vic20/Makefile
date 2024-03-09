PROGRAMS=monsternest.p00
OBJECTS=joystick.o65 monsternest.bas
OUTDIR=out
BASIC_VERSION=2
PLATFORM_ARGS=-l 1001

include ../make.inc

out/monsternest.bas: monsternest.in.bas out/joystick.o65
	endatafy monsternest.in.bas out/joystick.o65 > out/monsternest.bas

realclean: clean
	$(RM) out/monsternest.bas out/joystick.o65
