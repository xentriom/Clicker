//
//  ShortcutListener.swift
//  Clicker
//
//  Created by Jason Chen on 11/20/24.
//

import Cocoa

class ShortcutListener {
    private let onShortcutTriggered: () -> Void
    
    init(onShortcutTriggered: @escaping () -> Void) {
        self.onShortcutTriggered = onShortcutTriggered
    }
    
    func setupListener(for shortcutString: String) {
        guard let decodedShortcut = decodeShortcut(from: shortcutString) else {
            return
        }
        
        // Global listener
        NSEvent.addGlobalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
            _ = self?.handleKeyEvent(event, shortcut: decodedShortcut)
        }
        
        // Local listener
        NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
            if self?.handleKeyEvent(event, shortcut: decodedShortcut) == true {
                return nil
            }
            return event
        }
    }
    
    /// Compare key event to saved shortcut
    private func handleKeyEvent(_ event: NSEvent, shortcut: (modifiers: NSEvent.ModifierFlags, key: String)) -> Bool {
        let eventModifiers = event.modifierFlags.intersection(.deviceIndependentFlagsMask)
        let eventKey = event.charactersIgnoringModifiers ?? ""
        
        if eventModifiers == shortcut.modifiers && eventKey == shortcut.key {
            onShortcutTriggered()
            return true
        }
        return false
    }
    
    /// Decode the string shortcut
    private func decodeShortcut(from shortcutString: String) -> (modifiers: NSEvent.ModifierFlags, key: String)? {
        var modifiers: NSEvent.ModifierFlags = []
        var key: String?
        
        for character in shortcutString {
            switch character {
            case "⌘": modifiers.insert(.command)
            case "⇧": modifiers.insert(.shift)
            case "⌥": modifiers.insert(.option)
            case "⌃": modifiers.insert(.control)
            default:
                key = String(character)
            }
        }
        
        guard let key = key else { return nil }
        return (modifiers, key)
    }
}
