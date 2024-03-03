# Makefile

.PHONY: all clean

all: out/monsternest

out/monsternest: out/monsternest.bas
	petcat -w2 -l 1001 -f -o out/monsternest -- out/monsternest.bas

out/a.o65: joystick.asm
	xa -o out/a.o65 joystick.asm

out/monsternest.bas: monsternest.in.bas out/a.o65
	endatafy monsternest.in.bas out/a.o65 > out/monsternest.bas

clean:
	/bin/rm out/a.o65 out/monsternest out/monsternest.bas
