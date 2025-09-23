# Makefile

# -----------------------------
# Definitions

PROGS=monsternest.prg

P8COMPILE=prog8c
P8FLAGS=-target cx16 -quietasm -warnshadow -srcdirs lib

SRCS=\
	displays.p8 \
	monsternest.p8 \
	music.p8 \
	player.p8 \
	soundfx.p8 \
	startmenu.p8

# -----------------------------
# Targets

all: $(PROGS)

clean:
	$(RM) $(PROGS)  *.asm *.vice-mon-list


# -----------------------------
# Dependencies

monsternest.prg: $(SRCS)

# -----------------------------
# Administrivia

.p8.prg:
	$(P8COMPILE) $(P8FLAGS) $<

.PHONY: all clean
.SUFFIXES: .prg .p8
