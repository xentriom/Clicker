//
//  ContentView.swift
//  Clicker
//
//  Created by Xentriom on 4/29/25.
//

import SwiftUI
import KeyboardShortcuts

struct ContentView: View {
    @EnvironmentObject var clickerState: ClickerState
    @State private var rotationAngle: Double = 0.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack(spacing: 5) {
                Picker("Click using the", selection: $clickerState.selectedMouseButton) {
                    ForEach(AppConstants.buttonOptions, id: \.self) { button in
                        Text(button)
                    }
                }.frame(width: 175)
                
                Text("mouse button")
            }
            
            HStack {
                Text("Click")
                
                HStack(spacing: 0) {
                    TextField("", value: Binding(
                        get: { clickerState.selectedClickRate },
                        set: { newValue in
                            clickerState.selectedClickRate = min(max(newValue, 1), 100)
                        }), formatter: NumberFormatter()
                    )
                    Stepper("", value: $clickerState.selectedClickRate, in: AppConstants.clickCountRange)
                        .labelsHidden()
                }
                
                Picker("times per", selection: $clickerState.selectedClickInterval) {
                    ForEach(AppConstants.intervalOptions, id: \.self) { interval in
                        Text(interval)
                    }
                }.frame(width: 175)
            }
            
            
            Divider()
            
            if clickerState.showExtraSettings {
                VStack(alignment: .leading, spacing: 10) {
                    Toggle("Launch Clicker at Login", isOn: $clickerState.toLaunchAtLogin)
                        .onChange(of: clickerState.toLaunchAtLogin) { _, _ in
                            DispatchQueue.main.async {
                                clickerState.toggleLaunchAtLogin()
                            }
                        }
                    
                    Toggle("Show Clicker in Menu Bar", isOn: $clickerState.showMenuBarExtra)
                        .onChange(of: clickerState.showMenuBarExtra) { _, _ in
                            DispatchQueue.main.async {
                                clickerState.toggleShowMenuBarExtra()
                            }
                        }
                    
                    Toggle("Show Clicker in Dock", isOn: $clickerState.showDockIcon)
                        .onChange(of: clickerState.showDockIcon) { _, _ in
                            DispatchQueue.main.async {
                                clickerState.toggleShowDockIcon()
                            }
                        }
                    
                    Form {
                        KeyboardShortcuts.Recorder("Start/Stop hotkey:", name: .toggleClicking)
                    }
                }
                
                Divider()
            }
            
            HStack {
                Text(clickerState.isClicking ? "Running..." : "Stopped.")
                    .bold()
                
                Spacer()
                
                Button(action: {
                    clickerState.toggleClicking()
                }) {
                    Label(
                        clickerState.isClicking ? "Stop" : "Start",
                        systemImage: clickerState.isClicking ? "pause.circle" : "play.circle"
                    )
                }
                .accessibilityLabel(clickerState.isClicking ? "Stop Clicking" : "Start Clicking")
                .accessibilityHint("Toggles auto-clicking on or off.")
            }
        }
        .frame(width: 300)
        .padding()
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: toggleView) {
                    Label("Settings", systemImage: clickerState.showExtraSettings ? "gearshape.fill" : "gearshape")
                        .rotationEffect(.degrees(rotationAngle))
                }
                .accessibilityLabel("Toggle Settings")
                .accessibilityHint("Show or hide the advanced settings view.")
            }
        }
    }
    
    private func toggleView() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.4)) {
            clickerState.toggleExtraSettings()
            rotationAngle += 180
        }
    }
}
