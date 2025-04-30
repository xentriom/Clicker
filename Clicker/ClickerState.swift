//
//  ClickerState.swift
//  Clicker
//
//  Created by Xentriom on 4/29/25.
//

import SwiftUI
import Cocoa
import ServiceManagement

class ClickerState: ObservableObject {
    @Published var isClicking: Bool = false
    
    @AppStorage("selectedMouseButton") var selectedMouseButton: String = "Left"
    @AppStorage("selectedClickInterval") var selectedClickInterval: String = "second"
    @AppStorage("selectedClickRate") var selectedClickRate: Int = 20
    
    @AppStorage("showExtraSettings") var showExtraSettings: Bool = false
    @AppStorage("toLaunchAtLogin") var toLaunchAtLogin: Bool = false
    @AppStorage("showMenuBarExtra") var showMenuBarExtra: Bool = true
    @AppStorage("showDockIcon") var showDockIcon: Bool = true
    
    @MainActor
    func toggleClicking() {
        isClicking.toggle()
        
        if isClicking {
            ClickerManager.startClicking(
                selectedMouseButton: selectedMouseButton,
                selectedClickInterval: selectedClickInterval,
                selectedClickRate: selectedClickRate
            )
        } else {
            ClickerManager.stopClicking()
        }
    }
    
    @MainActor
    func toggleExtraSettings() {
        showExtraSettings.toggle()
    }
    
    @MainActor
    func toggleLaunchAtLogin() {
        toLaunchAtLogin.toggle()
        
        if toLaunchAtLogin {
            try? SMAppService.mainApp.register()
        } else {
            try? SMAppService.mainApp.unregister()
        }
    }
    
    @MainActor
    func toggleShowMenuBarExtra() {
        showMenuBarExtra.toggle()
    }
    
    @MainActor
    func toggleShowDockIcon() {
        showDockIcon.toggle()
        
        if showDockIcon {
            NSApp.setActivationPolicy(.regular)
        } else {
            NSApp.setActivationPolicy(.accessory)
        }
    }
}
