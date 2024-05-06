# Makefile

.PHONY: all clean

all: out/monsternest.prg

out/monsternest.prg: monsternest.p8
	mkdir -p out
	p8compile -target cx16 -quietasm -out out monsternest.p8

clean:
	$(RM) -r out
