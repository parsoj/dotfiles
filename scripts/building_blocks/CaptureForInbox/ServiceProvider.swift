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
        } catch {
            NSLog("Error saving to inbox: \(error.localizedDescription)")
        }
    }
}
