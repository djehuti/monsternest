# Makefile

.PHONY: all clean

all: out/monsternest

out/monsternest: monsternest.bas
	petcat -w70 -l 1c01 -f -o out/monsternest -- monsternest.bas

clean:
	/bin/rm out/monsternest
