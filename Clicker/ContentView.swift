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
    @State private var clickCount = 10
    
    // Mouse
    @State private var selectedMouseButton = "Left"
    let mouseButtons = ["Left", "Middle", "Right"]
    @State private var selectedTimeUnit = "Second"
    let timeUnits = ["Second", "Minute"]
    
    // Settings
    @State private var showSettings = true
    @State private var lauchAtLogin = false
    @State private var showOnDock = false
    @State private var showInMenuBar = true
    @State private var hotkey = "⌘S"
    @State private var isHotkeyEditing = false

    var body: some View {
        VStack {
            // Mouse click type
            HStack {
                Text("Click using")
                Picker("", selection: $selectedMouseButton) {
                    ForEach(mouseButtons, id: \.self) { button in
                        Text(button)
                    }
                }
                Text("mouse button")
            }

            // Interval
            HStack {
                Text("Click")
                HStack(spacing: 0) {
                    TextField("Clicks", value: $clickCount, formatter: NumberFormatter())
                        .frame(width: 50)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: clickCount) { oldValue, newValue in
                            // Ensure range
                            if newValue < 1 {
                                clickCount = 1
                            } else if newValue > 900 {
                                clickCount = 900
                            }
                        }
                    Stepper("", value: $clickCount, in: 1...900)
                }
                Text("times per")
                Picker("", selection: $selectedTimeUnit) {
                    ForEach(timeUnits, id: \.self) { unit in
                        Text(unit)
                    }
                }
            }
            
            Divider()
            
            // Settings
            if showSettings {
                VStack(alignment: .leading) {
                    Toggle("Launch at Login", isOn: $lauchAtLogin)
                        .toggleStyle(CheckboxToggleStyle())
                                    
                    Toggle("Show on Dock", isOn: $showOnDock)
                        .toggleStyle(CheckboxToggleStyle())
                                    
                    Toggle("Show on Menu Bar", isOn: $showInMenuBar)
                        .toggleStyle(CheckboxToggleStyle())
                    
                    HStack {
                        Text("Start/Stop hotkey:")
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(isHotkeyEditing ? Color.blue : Color.gray, lineWidth: 1)
                                .frame(height: 20)
                            Text(hotkey)
                                .foregroundColor(isHotkeyEditing ? .blue : .primary)
                                .onTapGesture {
                                    isHotkeyEditing.toggle()
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
            }
            
            HStack(alignment: .center, spacing: 10) {
                Button(action: { isRunning.toggle() }) {
                    Text(isRunning ? "Stop" : "Start")
                        .foregroundColor(.white) .cornerRadius(5)
                }
                Text(isRunning ? "Running" : "Stopped")
                    .foregroundColor(isRunning ? .green : .red)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding()
        .frame(width: 300)
        .animation(.easeInOut, value: showSettings)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    showSettings.toggle()
                }) {
                    Label("Settings", systemImage: showSettings ? "gearshape.fill" : "gearshape")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
