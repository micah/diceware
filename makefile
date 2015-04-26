# This makefile contains rules for building the debian package.

PYTHON      := /usr/bin/python

PROJECT     := diceware

VERSION     := $(shell $(PYTHON) setup.py --version)

DISTDIR     := dist
PKGNAME     := $(PROJECT)-$(VERSION)
PKGDIR      := $(DISTDIR)/$(PKGNAME)
DEBIANDIR   := $(PKGDIR)/debian
DISTFILE    := $(DISTDIR)/$(PKGNAME).tar.gz
ORIGFILE    := $(DISTDIR)/$(PROJECT)_$(VERSION).orig.tar.gz

all: deb-src

deb: createenv
	(cd $(PKGDIR) && debuild -uc -us)

deb-src: createenv
	(cd $(PKGDIR) && debuild -uc -us -S)

createenv: origfile debiandir

origfile: $(ORIGFILE)

debiandir: $(DEBIANDIR)

$(PKGDIR):
	tar --directory $(DISTDIR) -xf $(ORIGFILE)

$(ORIGFILE):
	$(PYTHON) setup.py sdist -v
	mv $(DISTFILE) $(ORIGFILE)

$(DEBIANDIR): $(PKGDIR)
	cp -r ./debian/ $(PKGDIR)

clean:
	rm -rf dist/ *.egg-info

.PHONY: all deb deb-src createenv origfile clean
