//
//  MenuBarView.swift
//  Clicker
//
//  Created by Jason Chen on 11/19/24.
//

import SwiftUI

struct MenuBarView: View {
    @Binding var isRunning: Bool
    @Binding var shortcut: String
    @Binding var launchAtLogin: Bool
    @Binding var showInDock: Bool
    @Binding var showMenuBarExtra: Bool
    
    var body: some View {
        VStack {
            Button(isRunning ? "Stop Clicker" : "Start Clicker") {
                isRunning.toggle()
            }
            .keyboardShortcut(decodeShortcut(shortcut))
            
            Divider()
            
            Toggle(isOn: $launchAtLogin) {
                Text("Launch at Login")
            }
            
            Toggle(isOn: $showMenuBarExtra) {
                Text("Show in Menu Bar")
            }
            
            Toggle(isOn: $showInDock) {
                Text("Show in Dock")
            }

            Divider()
            
            Button("About Clicker") {
                
            }
            Button("Open Clicker") {
                
            }
            
            Divider()
            
            Button(action: quitApp) {
                Text("Quit Clicker")
            }
            .keyboardShortcut("q", modifiers: [.command])
        }
        .padding()
    }
    
    /// Decode string shortcut into keyboardShortcut
    func decodeShortcut(_ shortcut: String) -> KeyboardShortcut? {
        var modifiers: EventModifiers = []
        var key: Character?
        
        for char in shortcut {
            switch char {
            case "⌘": modifiers.insert(.command)
            case "⌥": modifiers.insert(.option)
            case "⇧": modifiers.insert(.shift)
            case "⌃": modifiers.insert(.control)
            default:
                key = char
            }
        }
        
        guard let key = key else { return nil }
        return KeyboardShortcut(KeyEquivalent(key), modifiers: modifiers)
    }
    
    private func toggleLaunchAtLogin() {
        launchAtLogin.toggle()
        AppUtilities.setLaunchAtLogin(enabled: launchAtLogin)
    }
    
    private func toggleMenuBarExtra() {
        showMenuBarExtra.toggle()
    }
    
    private func toggleDockIcon() {
        showInDock.toggle()
        AppUtilities.setDockIconVisibility(hidden: !showInDock)
    }
    
    private func quitApp() {
        NSApp.terminate(nil)
    }
}
