//
//  MenuBarView.swift
//  Clicker
//
//  Created by Xentriom on 4/29/25.
//

import SwiftUI
import KeyboardShortcuts
import AppKit

extension EventModifiers {
    init(nseventFlags: NSEvent.ModifierFlags) {
        var mods = EventModifiers()
        if nseventFlags.contains(.command) { mods.insert(.command) }
        if nseventFlags.contains(.shift)   { mods.insert(.shift)   }
        if nseventFlags.contains(.option)  { mods.insert(.option)  }
        if nseventFlags.contains(.control) { mods.insert(.control) }
        self = mods
    }
}

struct MenuBarView: View {
    @EnvironmentObject var clickerState: ClickerState
    
    private func decodeShortcut(from description: String) -> (key: String, modifiers: NSEvent.ModifierFlags)? {
            var flags: NSEvent.ModifierFlags = []
            var keyChar: String?
            for ch in description {
                switch ch {
                case "⌘": flags.insert(.command)
                case "⇧": flags.insert(.shift)
                case "⌥": flags.insert(.option)
                case "⌃": flags.insert(.control)
                default:  keyChar = String(ch)
                }
            }
            guard let key = keyChar else { return nil }
            return (key, flags)
        }
    
    var body: some View {
        VStack() {
            if let desc = KeyboardShortcuts.Name.toggleClicking.shortcut?.description,
               let (key, flags) = decodeShortcut(from: desc),
               let char = key.lowercased().first
            {
                Button(clickerState.isClicking ? "Stop" : "Start") {
                    clickerState.toggleClicking()
                }.keyboardShortcut(
                    KeyEquivalent(char),
                    modifiers: EventModifiers(nseventFlags: flags)
                )
            }
            
            Divider()
            
            List {
                Picker(selection: $clickerState.selectedMouseButton) {
                    Text("Left Click").tag("Left")
                    Text("Middle Click").tag("Middle")
                    Text("Right Click").tag("Right")
                } label: {
                    Text("Mouse Click")
                    Text("Mouse button to click")
                }
            }
            
            Divider()
            
            Toggle(isOn: $clickerState.toLaunchAtLogin) {
                Text("Launch at login")
            }
            
            Toggle(isOn: $clickerState.showMenuBarExtra) {
                Text("Show menu bar icon")
            }
            
            Toggle(isOn: $clickerState.showDockIcon) {
                Text("Show dock icon")
            }
            
            Divider()
            
            Button("Open Clicker") {
                
            }
            
            Button("About Clicker") {
                if let url = URL(string: "https://github.com/xentriom/Clicker") {
                    NSWorkspace.shared.open(url)
                }
            }
            
            Divider()
            
            Button("Quit App") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        }.padding()
    }
}
