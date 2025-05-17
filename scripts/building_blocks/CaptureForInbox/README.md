# CaptureForInbox

A bare-bones macOS application that implements the Services functionality to capture text selections and send them to your inbox.

## Features

- Registers as a macOS Service
- Captures selected text from any application
- Sends the captured text to your inbox

## Project Structure

- `CaptureForInbox/` - Main application directory
  - `CaptureForInbox.xcodeproj/` - Xcode project files
  - `CaptureForInbox/` - Source code
    - `AppDelegate.swift` - Main application delegate
    - `ServiceProvider.swift` - Service implementation
    - `Info.plist` - Application info and service registration
  - `README.md` - This file

## Building and Installation

1. Open the project in Xcode
2. Build the application
3. Move the application to your Applications folder
4. Enable the service in System Preferences > Keyboard > Shortcuts > Services

## Usage

1. Select text in any application
2. Right-click and select Services > Capture for Inbox
3. The selected text will be sent to your inbox
