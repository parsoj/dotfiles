import Cocoa

class ServiceProvider: NSObject {
    static let shared = ServiceProvider()
    
    private override init() {
        super.init()
    }
    
    // This method will be called when the service is invoked
    @objc func captureText(_ pasteboard: NSPasteboard, userData: String, error: NSErrorPointer) {
        guard let items = pasteboard.pasteboardItems else { return }
        
        for item in items {
            if let string = item.string(forType: .string) {
                // Here you would implement the logic to send the text to your inbox
                // For now, we'll just print it to the console
                NSLog("Captured text: \(string)")
                
                // Example: Save to a file in the user's Documents directory
                saveToInbox(text: string)
            }
        }
    }
    
    private func saveToInbox(text: String) {
        let fileManager = FileManager.default
        
        // Get the path to the Documents directory
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            NSLog("Could not access Documents directory")
            return
        }
        
        // Create an "Inbox" directory if it doesn't exist
        let inboxDirectory = documentsDirectory.appendingPathComponent("Inbox")
        
        do {
            try fileManager.createDirectory(at: inboxDirectory, withIntermediateDirectories: true)
            
            // Use a fixed filename for all captures
            let filename = "latest-capture.txt"
            // Full path to the file
            let fileURL = inboxDirectory.appendingPathComponent(filename)
            
            // Write the text to the file
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
            
            NSLog("Successfully saved capture to \(fileURL.path)")
            
            // Show a notification dialog
            showNotification(message: "Text successfully captured to Inbox")
        } catch {
            NSLog("Error saving to inbox: \(error.localizedDescription)")
        }
    }
    
    private func showNotification(message: String) {
        // Ensure UI updates happen on the main thread
        DispatchQueue.main.async {
            // Create a temporary window for notification
            let notification = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 300, height: 80),
                styleMask: [.titled, .fullSizeContentView],
                backing: .buffered,
                defer: false)
            
            // Configure window appearance
            notification.isReleasedWhenClosed = true
            notification.backgroundColor = NSColor.white
            notification.titlebarAppearsTransparent = true
            notification.title = "CaptureForInbox"
            notification.hasShadow = true
            notification.level = .floating
            
            // Make the notification visible on all spaces/desktops
            notification.collectionBehavior = .canJoinAllSpaces
            
            // Create label for the notification text
            // Position it lower to avoid overlap with the window title
            let label = NSTextField(frame: NSRect(x: 10, y: 15, width: 280, height: 30))
            label.stringValue = message
            label.isEditable = false
            label.isBezeled = false
            label.drawsBackground = false
            label.textColor = NSColor.black
            label.font = NSFont.systemFont(ofSize: 14)
            label.alignment = .center
            
            // Add label to window
            notification.contentView?.addSubview(label)
            
            // Position window horizontally centered and 1/3 from the top of the screen
            if let screenFrame = NSScreen.main?.visibleFrame {
                let windowWidth = notification.frame.width
                // No need for window height for positioning
                
                // Calculate center position horizontally
                let xPos = (screenFrame.width - windowWidth) / 2
                
                // Calculate position 1/3 from the top
                let yPos = screenFrame.height * 2/3
                
                notification.setFrameOrigin(NSPoint(x: xPos, y: yPos))
            }
            
            // Show the window
            notification.makeKeyAndOrderFront(nil)
            
            // Automatically close after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                notification.close()
            }
        }
    }
}
