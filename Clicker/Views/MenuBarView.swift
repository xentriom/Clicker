//
//  MenuBarView.swift
//  Clicker
//
//  Created by Jason Chen on 11/19/24.
//

import SwiftUI

struct MenuBarView: View {
    @Binding var isRunning: Bool
    @Binding var lauchAtLogin: Bool
    @Binding var showInDock: Bool
    @Binding var showMenuBarExtra: Bool
    
    var body: some View {
        VStack {
            Button(action: openPreferences) {
                Text("Clicker Enabled")
            }
            
            Divider()
            
            Button(action: openPreferences) {
                Text("Launch at Login")
            }
            Button(action: openPreferences) {
                Text("Hide Dock Icon")
            }

            Divider()
            
            Button(action: openAbout) {
                Text("About Clicker")
            }
            Button(action: openPreferences) {
                Text("Customize")
            }
            
            Divider()
            
            Button(action: quitApp) {
                Text("Quit Clicker")
            }
        }
        .padding()
    }
    
    private func openAbout() {
        print("About clicked.")
    }
    
    private func openPreferences() {
        print("Preferences clicked.")
    }
    
    private func quitApp() {
        NSApp.terminate(nil)
    }
}
