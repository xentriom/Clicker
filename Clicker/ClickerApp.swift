//
//  ClickerApp.swift
//  Clicker
//
//  Created by Jason Chen on 11/18/24.
//

import SwiftUI

@main
struct ClickerApp: App {
    @AppStorage("hotkey") private var shortcut = AppConstants.defaultShortcut
    @AppStorage("launchAtLogin") private var launchAtLogin = AppConstants.defaultLaunchAtLogin
    @AppStorage("showInDock") private var showInDock = AppConstants.defaultShowInDock
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = AppConstants.defaultShowMenuBarExtra
    
    @StateObject private var autoClickerManager = AutoClickerManager()
    @State private var shortcutListener: ShortcutListener?
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                isRunning: $autoClickerManager.isRunning,
                shortcut: $shortcut,
                launchAtLogin: $launchAtLogin,
                showInDock: $showInDock,
                showMenuBarExtra: $showMenuBarExtra
            )
            .onAppear {
                setupListener()
            }
        }
        .windowResizability(.contentSize)

        MenuBarExtra("Clicker", systemImage: autoClickerManager.isRunning ? "magicmouse.fill" : "magicmouse", isInserted: $showMenuBarExtra) {
            MenuBarView(
                isRunning: $autoClickerManager.isRunning,
                shortcut: $shortcut,
                launchAtLogin: $launchAtLogin,
                showInDock: $showInDock,
                showMenuBarExtra: $showMenuBarExtra
            )
        }
        .menuBarExtraStyle(.menu)
    }
    
    private func setupListener() {
        shortcutListener = ShortcutListener {
            autoClickerManager.isRunning.toggle()
        }
        shortcutListener?.setupListener(for: shortcut)
    }
}
