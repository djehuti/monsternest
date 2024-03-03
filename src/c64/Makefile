# Makefile

.PHONY: all clean

all: out/monsternest

out/monsternest: monsternest.bas
	petcat -w2 -l 0801 -f -o out/monsternest -- monsternest.bas

clean:
	/bin/rm out/monsternest
