//
//  ClickerApp.swift
//  Clicker
//
//  Created by Jason Chen on 11/18/24.
//

import SwiftUI

@main
struct ClickerApp: App {
    @State private var isRunning = false
    @State private var lauchAtLogin = false
    @State private var showInDock = true
    @State private var showMenuBarExtra = true
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                isRunning: $isRunning,
                lauchAtLogin: $lauchAtLogin,
                showInDock: $showInDock,
                showMenuBarExtra: $showMenuBarExtra
            )
        }
        .windowResizability(.contentSize)

        MenuBarExtra("Clicker", systemImage: isRunning ? "bolt.circle.fill" : "bolt.circle", isInserted: $showMenuBarExtra) {
            MenuBarView(
                isRunning: $isRunning,
                lauchAtLogin: $lauchAtLogin,
                showInDock: $showInDock,
                showMenuBarExtra: $showMenuBarExtra
            )
        }
        .menuBarExtraStyle(.menu)
    }
}
