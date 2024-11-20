//
//  ClickerApp.swift
//  Clicker
//
//  Created by Jason Chen on 11/18/24.
//

import SwiftUI

@main
struct ClickerApp: App {
    @AppStorage("launchAtLogin") private var launchAtLogin = AppConstants.defaultLaunchAtLogin
    @AppStorage("showInDock") private var showInDock = AppConstants.defaultShowInDock
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra = AppConstants.defaultShowMenuBarExtra
    @StateObject private var autoClickerManager = AutoClickerManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                isRunning: $autoClickerManager.isRunning,
                launchAtLogin: $launchAtLogin,
                showInDock: $showInDock,
                showMenuBarExtra: $showMenuBarExtra
            )
        }
        .windowResizability(.contentSize)

        MenuBarExtra("Clicker", systemImage: autoClickerManager.isRunning ? "magicmouse.fill" : "magicmouse", isInserted: $showMenuBarExtra) {
            MenuBarView(
                isRunning: $autoClickerManager.isRunning,
                launchAtLogin: $launchAtLogin,
                showInDock: $showInDock,
                showMenuBarExtra: $showMenuBarExtra
            )
        }
        .menuBarExtraStyle(.menu)
    }
}

#Preview {
    ContentView(
        isRunning: .constant(true),
        launchAtLogin: .constant(true),
        showInDock: .constant(true),
        showMenuBarExtra: .constant(true)
    )
}
