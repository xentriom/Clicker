//
//  ClickerApp.swift
//  Clicker
//
//  Created by Jason Chen on 11/18/24.
//

import SwiftUI

@main
struct ClickerApp: App {
    @AppStorage("isRunning") private var isRunning = false
    @AppStorage("launchAtLogin") private var launchAtLogin = false
    @AppStorage("showInDock") private var showInDock = true
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = true
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                isRunning: $isRunning,
                launchAtLogin: $launchAtLogin,
                showInDock: $showInDock,
                showMenuBarExtra: $showMenuBarExtra
            )
        }
        .windowResizability(.contentSize)

        MenuBarExtra("Clicker", systemImage: isRunning ? "bolt.circle.fill" : "bolt.circle", isInserted: $showMenuBarExtra) {
            MenuBarView(
                isRunning: $isRunning,
                launchAtLogin: $launchAtLogin,
                showInDock: $showInDock,
                showMenuBarExtra: $showMenuBarExtra
            )
        }
        .menuBarExtraStyle(.menu)
    }
}
