//
//  AppConstants.swift
//  Clicker
//
//  Created by Jason Chen on 11/19/24.
//

import Foundation

struct AppConstants {
    static let defaultLaunchAtLogin = false
    static let defaultShowInDock = true
    static let defaultShowMenuBarExtra = true
    
    static let defaultClickCount = 10
    static let clickCountRange = 1...100
    
    static let mouseButtons = ["Left", "Middle", "Right"]
    static let defaultMouseButton = "Left"
    
    static let timeUnits = ["Second", "Minute"]
    static let defaultTimeUnit = "Second"
    
    static let defaultShortcut = "⌘S"
}
