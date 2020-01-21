#
#	@(#) Makefile V1.20.1 (C) 2019-2020 by Roman Oreshnikov
#
BINDIR	= /usr/sbin
MANDIR	= /usr/share/man/man8

#
# DON'T EDIT BELOW!!!
#
NAME	= Shell scripts for CRUX-3.5 packages administration

CP	= /bin/cp
DATE	= /bin/date
INSTALL	= /usr/bin/install
MKDIR	= /bin/mkdir
SED	= /bin/sed
TAR	= /bin/tar
XZ	= /usr/bin/xz

BIN	= pkgnew pkguse
MAN	= pkgnew.8 pkguse.8

SRC	= $(BIN) $(MAN) PKG.grp

.PHONY:	all dist install

all:
	@D=$(DESTDIR); \
	echo "$(NAME) make(1) scenario"; \
	echo "Settings:"; \
	echo "  Directory for scripts:      BINDIR = $(BINDIR)"; \
	echo "  Directory for manual docs:  MANDIR = $(MANDIR)"; \
	echo "Make targets:"; \
	echo "  install   - install software relative $${D:-/}"; \
	echo "  dist      - create tarball for distribute"

install: $(BIN) $(MAN)
	@echo "Install software"; set -e; \
	for F in $(BIN); do \
		$(INSTALL) -Dm 555 $$F "$(DESTDIR)$(BINDIR)/$$F"; \
	done; \
	for F in $(MAN); do \
		$(INSTALL) -Dm 644 $$F "$(DESTDIR)$(MANDIR)/$$F"; \
	done

dist: Makefile $(SRC)
	@set -e; \
	D=`$(SED) '/@(#)/!d;s/^.*V\([^ ]*\).*/Pkgnew-\1/;q' Makefile`; \
	echo "Create $$D.tar.xz"; \
	[ ! -d "$$D" ] || $(RM) -rf "$$D"; $(MKDIR) "$$D"; \
	$(CP) Makefile "$$D"; \
	V=`$(SED) '/@(#)/!d;s/^.*\(V.*\)$$/\1/;q' Makefile`; \
	for F in $(SRC); do \
		$(SED) "s/\(@(#)\).*/\1 $$F $$V/" $$F >"$$D/$$F"; \
	done; \
	C=$${V#* * } V=$${V#*V} V=$${V%% *}; Y=`$(DATE) +%Y`; \
	$(SED) -i "1s/\(.TH [^ ]* 8\) .*/\1 $$Y $$V/;\$$s/.*/Copyright $$C/" \
		$$D/*.8; \
	$(TAR) cf - --remove-files "$$D" | $(XZ) -9c >"$$D.tar.xz"
