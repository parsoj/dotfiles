# CaptureForInbox - Obsidian Integration Plan

## Overview

Create a hybrid solution that combines the macOS Services capabilities of our Swift/Cocoa app with the fuzzy-matching power of fzf via shell scripting for integrating with Obsidian.

## Components

### 1. Cocoa App (Existing)

- Captures selected text from any application via macOS Services menu
- Saves text to `~/Documents/Inbox/latest-capture.txt`
- Shows a notification when text is captured
- New: Triggers shell script for Obsidian integration

### 2. Shell Script (New)

- Reads captured text from `~/Documents/Inbox/latest-capture.txt`
- Uses fzf to let user select an Obsidian markdown file
- Uses fzf again to let user select a heading within that file
- Inserts the captured text under the selected heading
- Returns success/failure status to the app

## Implementation Steps

### Phase 1: Create the Shell Script

1. Create a new shell script (e.g., `obsidian-insert.sh`)
2. Implement file discovery for Obsidian vault
3. Implement heading extraction from markdown files
4. Set up fzf interfaces for selection
5. Create text insertion logic
6. Add error handling and status reporting

### Phase 2: Modify Cocoa App

1. Add option to trigger Obsidian integration after text is saved
2. Implement process launching capability to call the shell script
3. Handle script output/status
4. Update notification system to report success/failure of Obsidian insertion

### Phase 3: Integration and Testing

1. Test the complete workflow
2. Refine error handling
3. Optimize the user experience

## User Experience Flow

1. User selects text in any application
2. User activates CaptureForInbox via Services menu or hotkey
3. Text is saved to inbox file
4. User is prompted with fzf interface to select Obsidian file
5. User is prompted with fzf interface to select heading
6. Text is inserted into Obsidian file under selected heading
7. Notification confirms successful insertion

## Technical Considerations

### File Paths

- Obsidian vault location needs to be configurable or detected
- Shell script location needs to be reliable relative to app

### Error Cases

- No text captured
- Obsidian vault not found
- User cancels file or heading selection
- File cannot be written (permissions)
- File format issues

### Configuration Options

- Allow configuring Obsidian vault location
- Option for default file/heading
- Option for format of inserted text (plain, quote, task, etc.)

## Future Enhancements

- Create a full Cocoa UI for file/heading selection
- Add metadata to captures (source, date, tags)
- Support multiple capture destinations
- Support rich text capture
