.PHONY: build app run install test icon release clean

build:
	swift build

test:
	swift test

icon:
	swift scripts/make-icon.swift "$(CURDIR)"

app:
	scripts/build-app.sh

# Fast single-arch build, then launch.
run:
	ARCHS=arm64 scripts/build-app.sh
	open build/airPointer.app

# Installing to /Applications keeps the Accessibility grant stable and enables Launch at Login.
install:
	ARCHS=arm64 scripts/build-app.sh
	rm -rf /Applications/airPointer.app
	cp -R build/airPointer.app /Applications/
	open /Applications/airPointer.app

release:
	scripts/release.sh

clean:
	rm -rf .build build
