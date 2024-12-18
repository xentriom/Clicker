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
    @Binding var shortcut: String
    @Binding var launchAtLogin: Bool
    @Binding var showInDock: Bool
    @Binding var showMenuBarExtra: Bool
    
    // Mouse
    @AppStorage("selectedMouseButton") private var selectedMouseButton = AppConstants.defaultMouseButton
    @AppStorage("selectedTimeUnit") private var selectedTimeUnit = AppConstants.defaultTimeUnit
    @AppStorage("clicksPerUnit") private var clicksPerUnit = AppConstants.defaultClickCount
    
    // Settings
    @AppStorage("isSettingsOpen") private var showSettings = true
    @State private var isHotkeyEditing = false
    @State private var rotationAngle = 0.0

    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    DispatchQueue.main.async {
                        NSApp.keyWindow?.makeFirstResponder(nil)
                    }
                }
            
            VStack(spacing: 15) {
                // Interval Control
                IntervalView(
                    clicksPerUnit: $clicksPerUnit,
                    selectedMouseButton: $selectedMouseButton,
                    selectedTimeUnit: $selectedTimeUnit
                )
                .onChange(of: clicksPerUnit) { oldValue, newValue in
                    clicksPerUnit = min(max(AppConstants.clickCountRange.lowerBound, newValue), AppConstants.clickCountRange.upperBound)
                }
                
                Divider()
                
                // Settings Section
                if showSettings {
                    Group {
                        SettingsView(
                            launchAtLogin: $launchAtLogin,
                            showOnDock: $showInDock,
                            showMenuBarExtra: $showMenuBarExtra,
                            shortcut: $shortcut,
                            isHotkeyEditing: $isHotkeyEditing
                        )
                        
                        Divider()
                    }
                    .transition(Animations.cascadingFadeAndSlide)
                }
                
                
                // Start/Stop Control
                HStack(alignment: .center, spacing: 10) {
                    Text(isRunning ? "Clicking..." : "Stopped.")
                    
                    Spacer()
                    
                    Button(action: {
                        isRunning.toggle()
                    }) {
                        Text(isRunning ? "Stop" : "Start")
                            .cornerRadius(5)
                            .animation(.easeInOut(duration: 0.3), value: isRunning)
                    }
                }
            }
            .padding()
        }
        .frame(width: 320)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: toggleSettings) {
                    Label("Settings", systemImage: showSettings ? "gearshape.fill" : "gearshape")
                        .rotationEffect(.degrees(rotationAngle))
                }
                .accessibilityLabel("Toggle Settings")
                .accessibilityHint("Show or hide the settings panel.")
            }
        }
    }
    
    private func toggleSettings() {
        withAnimation(Animations.elasticOvershoot(duration: 0.5)) {
            showSettings.toggle()
            rotationAngle += 100
        }
    }
}
