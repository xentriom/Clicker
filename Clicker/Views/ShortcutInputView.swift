//
//  ShortcutInputView.swift
//  Clicker
//
//  Created by Jason Chen on 11/20/24.
//

import SwiftUI

struct ShortcutInputView: View {
    @Binding var shortcut: String
    @Binding var isEditing: Bool
    
    @State private var capturedKeys: String = ""
    @State private var eventMonitor: Any?
    
    var body: some View {
        Text(capturedKeys)
            .foregroundColor(.blue)
            .onAppear {
                capturedKeys = shortcut
                startListeningForKeyEvents()
            }
            .onDisappear {
                stopListeningForKeyEvents()
            }
            .frame(height: 20)
    }
    
    private func startListeningForKeyEvents() {
        eventMonitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { event in
            self.handleKeyEvent(event)
            return nil
        }
    }
    
    private func stopListeningForKeyEvents() {
        if let monitor = eventMonitor {
            NSEvent.removeMonitor(monitor)
            eventMonitor = nil
        }
    }
    
    private func handleKeyEvent(_ event: NSEvent) {
        var keys = [String]()
        
        if event.modifierFlags.contains(.command) { keys.append("⌘") }
        if event.modifierFlags.contains(.shift) { keys.append("⇧") }
        if event.modifierFlags.contains(.option) { keys.append("⌥") }
        if event.modifierFlags.contains(.control) { keys.append("⌃") }
        
        if let characters = event.charactersIgnoringModifiers {
            keys.append(characters.uppercased())
        }
        
        // Automatically add "⌘" if no modifiers are present
        if !keys.contains("⌘") && !keys.contains("⇧") && !keys.contains("⌥") && !keys.contains("⌃") {
            keys.insert("⌘", at: 0)
        }
        
        // Validate the shortcut
        let newShortcut = keys.joined(separator: "")
        if isValidShortcut(keys: keys) {
            capturedKeys = newShortcut
            shortcut = capturedKeys
            isEditing = false
        }
    }
    
    private func isValidShortcut(keys: [String]) -> Bool {
        if keys == ["⌘", "Q"] {
            return false
        }
        
        let mainKey = keys.first(where: { !["⌘", "⇧", "⌥", "⌃"].contains($0) })
        return mainKey != nil
    }
}

