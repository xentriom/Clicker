//
//  SettingsView.swift
//  Clicker
//
//  Created by Jason Chen on 11/19/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var launchAtLogin: Bool
    @Binding var showOnDock: Bool
    @Binding var showMenuBarExtra: Bool
    @Binding var shortcut: String
    @Binding var isHotkeyEditing: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Toggle("Launch Clicker at Login", isOn: $launchAtLogin)
                .onChange(of: launchAtLogin) { oldValue, newValue in
                    AppUtilities.setLaunchAtLogin(enabled: newValue)
                }
            
            Toggle("Show Clicker in Menu Bar", isOn: $showMenuBarExtra)
            
            Toggle("Show Clicker in Dock", isOn: $showOnDock)
                .onChange(of: showOnDock) { oldValue, newValue in
                    AppUtilities.setDockIconVisibility(hidden: oldValue)
                }
            
            HStack {
                Text("Start/Stop shortcut:")

                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(isHotkeyEditing ? Color.blue : Color.gray, lineWidth: 1)
                        .frame(height: 20)
                    
                    if !isHotkeyEditing {
                        Text(shortcut)
                            .onTapGesture {
                                isHotkeyEditing.toggle()
                            }
                    } else {
                        ShortcutInputView(
                            shortcut: $shortcut,
                            isEditing: $isHotkeyEditing
                        )
                    }
                }
            }
        }
    }
}

