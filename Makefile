#
#	@(#) Makefile V2.1 (C) 2019-2021 by Roman Oreshnikov
#
CRUX	= 3.6
BINDIR	= /usr/sbin
MANDIR	= /usr/share/man/man8
TAREXT	= .tar.xz

#
# DON'T EDIT BELOW!!!
#
NAME	= Shell scripts for CRUX packages administration

CP	= /bin/cp
INSTALL	= /usr/bin/install
MKDIR	= /bin/mkdir
RM	= /bin/rm
SED	= /bin/sed
TAR	= /bin/tar

BIN	= pkgnew pkguse
MAN	= pkgnew.8 pkguse.8
SRC	= Makefile README.md $(BIN) $(MAN) PKG.cfg

.PHONY:	all clean dist install

all:
	@D=$(DESTDIR); \
	echo "$(NAME) make(1) scenario"; \
	echo "Settings:"; \
	echo "  Linux CRUX release:         CRUX   = $(CRUX)"; \
	echo "  Directory for scripts:      BINDIR = $(BINDIR)"; \
	echo "  Directory for manual docs:  MANDIR = $(MANDIR)"; \
	echo "Make targets:"; \
	echo "  install   - install software relative $${D:-/}"; \
	echo "  clean     - delete temporary files"; \
	echo "  dist      - create tarball for distribution"

install: $(BIN) $(MAN)
	@echo "Install software"; set -e; \
	W=$$($(SED) '/@(#)/!d;s/^.*V\(.*\)/\1/;q' Makefile); \
	C=$${W#*) } V=$${W%% *} Y=$${C%% *}; \
	for F in $(BIN); do \
		$(SED) "s/\(@(#)\).*/\1 $$F V$$W/; \
			s/\(CRUX-\)[0-9.]*/\1$(CRUX)/" $$F >$$F.i; \
		$(INSTALL) -D $$F.i "$(DESTDIR)$(BINDIR)/$$F"; \
	done; \
	for F in $(MAN); do \
		$(SED) "1s/\(.TH [^ ]* 8\) .*/\1 $$Y $$V/; \
			\$$s/.*/Copyright $$C/; \
			s/\(CRUX-\)[0-9.]*/\1$(CRUX)/" $$F >$$F.i; \
		$(INSTALL) -Dm644 $$F.i "$(DESTDIR)$(MANDIR)/$$F"; \
	done

clean:
	@echo "Remove temporary files"; $(RM) *.i

dist: $(SRC)
	@set -e; \
	D=$$($(SED) '/@(#)/!d;s/^.*V\([^ ]*\).*/Pkgnew-\1/;q' Makefile); \
	[ ! -d "$$D" ] || $(RM) -rf "$$D"; $(MKDIR) "$$D"; \
	$(CP) $(SRC) "$$D"; echo "Create $$D$(TAREXT)"; \
	$(TAR) -caf "$$D$(TAREXT)" --remove-files "$$D"
