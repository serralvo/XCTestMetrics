SHELL = /bin/bash

prefix ?= /usr/local
bindir ?= $(prefix)/bin
libdir ?= $(prefix)/lib
srcdir = Sources

REPODIR = $(shell pwd)
BUILDDIR = $(REPODIR)/.build
SOURCES = $(wildcard $(srcdir)/**/*.swift)

.DEFAULT_GOAL = all

.PHONY: all
all: xctestmetrics

xctestmetrics: $(SOURCES)
	@swift build \
		-c release \
		--disable-sandbox

.PHONY: install
install: xctestmetrics
	@install -d "$(bindir)" "$(libdir)"
	@install "$(BUILDDIR)/release/XCTestMetrics" "$(bindir)"

.PHONY: uninstall
uninstall:
	@rm -rf "$(bindir)/xctestmetrics"

.PHONY: clean
distclean:
	@rm -f $(BUILDDIR)/release

.PHONY: clean
clean: distclean
	@rm -rf $(BUILDDIR)
