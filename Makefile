prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release --disable-sandbox

install: build
	install ".build/release/XCTestMetrics" "$(bindir)"
	
uninstall:
	rm -rf "$(bindir)/xctestmetrics"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
