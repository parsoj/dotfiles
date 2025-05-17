# Makefile for CaptureForInbox macOS Service app

# Configuration
APP_NAME = CaptureForInbox
APP_BUNDLE = $(APP_NAME).app
BUNDLE_DIR = $(APP_BUNDLE)/Contents
MACOS_DIR = $(BUNDLE_DIR)/MacOS
RESOURCES_DIR = $(BUNDLE_DIR)/Resources
SWIFT_FILES = main.swift AppDelegate.swift ServiceProvider.swift
SWIFT_COMPILER = swiftc
SWIFT_FLAGS = -sdk $(shell xcrun --show-sdk-path) -target x86_64-apple-macosx10.15 -O -g

# Default target
all: build

# Build the application
build: clean setup compile copy_resources

# Setup the application bundle structure
setup:
	@echo "Creating app bundle structure..."
	mkdir -p $(MACOS_DIR)
	mkdir -p $(RESOURCES_DIR)

# Compile the Swift files
compile:
	@echo "Compiling Swift files..."
	$(SWIFT_COMPILER) $(SWIFT_FLAGS) $(SWIFT_FILES) -o $(MACOS_DIR)/$(APP_NAME)

# Copy resources into the bundle
copy_resources:
	@echo "Copying resources into bundle..."
	cp Info.plist $(BUNDLE_DIR)/Info.plist
	# Add any other resources (icons, etc.) here

# Clean the build
clean:
	@echo "Cleaning build..."
	rm -rf $(APP_BUNDLE)

# Install the app to the Applications folder
install: build
	@echo "Installing app to Applications folder..."
	cp -R $(APP_BUNDLE) /Applications/

# Kill any existing instances of the application
kill:
	@echo "Killing any existing instances..."
	-killall -9 $(APP_NAME) 2>/dev/null || true

# Run the application
run: build kill
	@echo "Running application..."
	open $(APP_BUNDLE)

# Help target
help:
	@echo "CaptureForInbox macOS Service App Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  all       - Default target, builds the application"
	@echo "  build     - Build the application"
	@echo "  clean     - Clean the build directory"
	@echo "  install   - Install the app to the Applications folder"
	@echo "  run       - Run the application"
	@echo "  help      - Show this help message"

.PHONY: all build setup compile copy_resources clean install run help
