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
    @Binding var hotkey: String
    @Binding var isHotkeyEditing: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Toggle("Launch Clicker at Login", isOn: $launchAtLogin)
            Toggle("Show Clicker in Menu Bar", isOn: $showMenuBarExtra)
            Toggle("Show Clicker in Dock", isOn: $showOnDock)
            
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
