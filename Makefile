
VERSION = 1.2.1
LUA_VERSION = 5.4
prefix ?= /usr
sharedir ?= $(prefix)/share
luasharedir ?= $(sharedir)/lua/$(LUA_VERSION)
bindir ?= $(prefix)/bin

aportsfiles = \
	abuild.lua \
	apkrepo.lua \
	db.lua \
	dump.lua \
	pkg.lua

binfiles = buildrepo.lua ap.lua

all: doc

doc: buildrepo.1.scd
	scdoc < buildrepo.1.scd > buildrepo.1

install: $(addprefix bin/,$(binfiles)) $(addprefix aports/,$(aportsfiles))
	install -d $(DESTDIR)$(luasharedir)/aports \
		$(DESTDIR)$(bindir)
	install -m644 $(addprefix aports/,$(aportsfiles)) \
		$(DESTDIR)$(luasharedir)/aports/
	for file in $(binfiles); do \
		install -m755 bin/$$file $(DESTDIR)$(bindir)/$${file%.lua} || exit 1; \
	done
	install -Dm644 buildrepo.1	${DESTDIR}${PREFIX}/share/man/man1/buildrepo.1

check: lint
	env -i busted-$(LUA_VERSION) --verbose

lint:
	luacheck aports bin


