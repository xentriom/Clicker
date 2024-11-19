//
//  AppUtilities.swift
//  Clicker
//
//  Created by Jason Chen on 11/19/24.
//

import Cocoa
import ServiceManagement

struct AppUtilities {
    /// Toggle Launch Item
    static func setLaunchAtLogin(enabled: Bool) {
        if enabled {
            try? SMAppService.mainApp.register()
            
        } else {
            try? SMAppService.mainApp.unregister()
        }
    }
    
    /// Hide/Show Dock Icon
    static func setDockIconVisibility(hidden: Bool) {
        if hidden {
            NSApp.setActivationPolicy(.accessory)
        } else {
            NSApp.setActivationPolicy(.regular)
        }
    }
}
