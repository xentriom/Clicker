//
//  MenuBarView.swift
//  Clicker
//
//  Created by Jason Chen on 11/19/24.
//

import SwiftUI

struct MenuBarView: View {
    @Binding var isRunning: Bool
    @Binding var launchAtLogin: Bool
    @Binding var showInDock: Bool
    @Binding var showMenuBarExtra: Bool
    
    var body: some View {
        VStack {
            Button(action: openPreferences) {
                Text("Clicker Enabled")
            }
            
            Divider()
            
            Button(action: toggleLaunchAtLogin) {
                HStack {
                    if launchAtLogin {
                        Image(systemName: "checkmark")
                    }
                    Text("Launch at Login")
                }
            }
            
            Button(action: toggleMenuBarExtra) {
                HStack {
                    Image(systemName: "checkmark")
                    Text("Hide Menu Bar Icon")
                }
            }
            
            Button(action: toggleDockIcon) {
                HStack {
                    if showInDock {
                        Image(systemName: "checkmark")
                    }
                    Text("Clicker Dock Icon")
                }
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
