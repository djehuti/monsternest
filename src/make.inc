# make.inc

.PHONY: all clean
.SUFFIXES: .p00 .bas .o65 .asm

TARGETS=$(addprefix $(OUTDIR)/,$(PROGRAMS))

all: $(TARGETS)

.bas.p00:
	petcat -w$(BASIC_VERSION) $(PLATFORM_ARGS) -f -o $@ -- $<

.asm.o65:
	xa -o $@ $<

$(OUTDIR)/%.p00: %.bas
	petcat -w$(BASIC_VERSION) $(PLATFORM_ARGS) -f -o $@ -- $<

$(OUTDIR)/%.o65: %.asm
	xa -o $@ $<

$(TARGETS): | $(OBJDIR)

$(OBJDIR):
	mkdir $(OBJDIR)

clean:
	$(RM) $(TARGETS)
