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
    @Binding var showInMenuBar: Bool
    @Binding var hotkey: String
    @Binding var isHotkeyEditing: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Toggle("Launch at Login", isOn: $launchAtLogin)
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
    }
}

