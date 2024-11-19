//
//  ContentView.swift
//  Clicker
//
//  Created by Jason Chen on 11/18/24.
//

import SwiftUI

struct ContentView: View {
    // Clicker
    @State private var isRunning = false
    @State private var clickCount = AppConstants.defaultClickCount
    
    // Mouse
    @State private var selectedMouseButton = AppConstants.defaultMouseButton
    @State private var selectedTimeUnit = AppConstants.defaultTimeUnit
    
    // Settings
    @State private var showSettings = true
    @State private var lauchAtLogin = false
    @State private var showOnDock = false
    @State private var showInMenuBar = true
    @State private var hotkey = AppConstants.defaultHotkey
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
                        launchAtLogin: $lauchAtLogin,
                        showOnDock: $showOnDock,
                        showInMenuBar: $showInMenuBar,
                        hotkey: $hotkey,
                        isHotkeyEditing: $isHotkeyEditing
                    )
                    
                    Divider()
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
            
            
            // Start/Stop Control
            HStack(alignment: .center, spacing: 10) {
                Text(isRunning ? "Clicking..." : "Stopped.")
                
                Button(action: { isRunning.toggle() }) {
                    Text(isRunning ? "Stop" : "Start")
                        .cornerRadius(5)
                }
            }
        }
        .padding()
        .frame(width: 320)
        .animation(.easeInOut, value: showSettings)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        showSettings.toggle()
                        rotationAngle += 100
                    }
                })
                {
                    Label("Settings", systemImage: showSettings ? "gearshape.fill" : "gearshape")
                        .rotationEffect(.degrees(rotationAngle))
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: rotationAngle)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
