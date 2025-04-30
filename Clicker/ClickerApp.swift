//
//  ClickerApp.swift
//  Clicker
//
//  Created by Xentriom on 4/29/25.
//

import SwiftUI
import KeyboardShortcuts

@main
struct ClickerApp: App {
    @StateObject private var clickerState = ClickerState()
    @AppStorage("showMenuBarExtra") private var showMenuBarExtra: Bool = true
    
    private func initShortcuts() {
        KeyboardShortcuts.onKeyDown(for: .toggleClicking) { [self] in
            clickerState.toggleClicking()
        }
    }

    var body: some Scene {
        // App
        WindowGroup {
            ContentView().environmentObject(clickerState).onAppear(perform: initShortcuts)
        }.windowResizability(.contentSize)
        
        // Menu Bar
        MenuBarExtra(
            "Clicker",
            systemImage: clickerState.isClicking ? "magicmouse.fill" : "magicmouse",
            isInserted: $showMenuBarExtra
        ) {
            MenuBarView().environmentObject(clickerState)
        }.menuBarExtraStyle(.menu)
    }
}
