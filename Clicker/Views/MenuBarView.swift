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
            Button(action: toggleAutoClicking) {
                HStack {
                    Image(systemName: isRunning ? "stop.circle.fill" : "play.circle.fill")
                    Text(isRunning ? "Stop Clicker" : "Start Clicker [\(shortcut)]")
                }
            }
            
            Divider()
            
            Button(action: toggleLaunchAtLogin) {
                HStack {
                    Image(systemName: launchAtLogin ? "checkmark.circle.fill" : "xmark.circle.fill")
                    Text("Launch at Login")
                }
            }
            
            Button(action: toggleMenuBarExtra) {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Menu Bar Icon")
                }
            }
            
            Button(action: toggleDockIcon) {
                HStack {
                    Image(systemName: showInDock ? "checkmark.circle.fill" : "xmark.circle.fill")
                    Text("Clicker Dock Icon")
                }
            }

            Divider()
            
            Button(action: openAbout) {
                Image(systemName: "info.circle.fill")
                Text("About Clicker")
            }
            Button(action: openPreferences) {
                Image(systemName: "gearshape.circle.fill")
                Text("Customize")
            }
            
            Divider()
            
            Button(action: quitApp) {
                Image(systemName: "power.circle.fill")
                Text("Quit Clicker")
            }
        }
        .padding()
    }
    
    private func toggleAutoClicking() {
        isRunning.toggle()
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
