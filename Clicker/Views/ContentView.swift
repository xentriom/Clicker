//
//  ContentView.swift
//  Clicker
//
//  Created by Jason Chen on 11/18/24.
//

import SwiftUI

struct ContentView: View {
    // Clicker
    @Binding var isRunning: Bool
    @Binding var launchAtLogin: Bool
    @Binding var showInDock: Bool
    @Binding var showMenuBarExtra: Bool
    
    // Mouse
    @State private var selectedMouseButton = AppConstants.defaultMouseButton
    @State private var selectedTimeUnit = AppConstants.defaultTimeUnit
    @State private var clickCount = AppConstants.defaultClickCount
    
    // Settings
    @AppStorage("isSettingsOpen") private var showSettings = true
    @AppStorage("hotkey") private var hotkey = AppConstants.defaultHotkey
    
    @State private var isHotkeyEditing = false
    @State private var rotationAngle = 0.0

    var body: some View {
        VStack(spacing: 15) {
            // Interval Control
            IntervalControl(clickCount: $clickCount, selectedMouseButton: $selectedMouseButton, selectedTimeUnit: $selectedTimeUnit)
            
            Divider()
            
            // Settings Section
            if showSettings {
                Group {
                    SettingsView(
                        launchAtLogin: $launchAtLogin,
                        showOnDock: $showInDock,
                        showMenuBarExtra: $showMenuBarExtra,
                        hotkey: $hotkey,
                        isHotkeyEditing: $isHotkeyEditing
                    )
                    
                    Divider()
                }
                .transition(Animations.cascadingFadeAndSlide)
            }
            
            
            // Start/Stop Control
            HStack(alignment: .center, spacing: 10) {
                Text(isRunning ? "Clicking..." : "Stopped.")
                
                Button(action: {
                    withAnimation(Animations.bounce) {
                        isRunning.toggle()
                    }
                }) {
                    Text(isRunning ? "Stop" : "Start")
                        .cornerRadius(5)
                        .animation(.easeInOut(duration: 0.3), value: isRunning)
                }
            }
        }
        .padding()
        .frame(width: 320)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    withAnimation(Animations.elasticOvershoot(duration: 0.5)) {
                        showSettings.toggle()
                        rotationAngle += 100
                    }
                })
                {
                    Label("Settings", systemImage: showSettings ? "gearshape.fill" : "gearshape")
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(Animations.smoothEase, value: rotationAngle)
                }
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
