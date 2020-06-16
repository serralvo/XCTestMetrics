bindir = /usr/local/bin

build:
	swift build -c release --disable-sandbox

install: build
	install ".build/release/xctestmetrics" "$(bindir)"
	
uninstall:
	rm -rf "$(bindir)/xctestmetrics"

clean:
	rm -rf .build
