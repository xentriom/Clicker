//
//  AppConstants.swift
//  Clicker
//
//  Created by Xentriom on 4/29/25.
//

import KeyboardShortcuts

struct AppConstants {
    static let clickCountRange: ClosedRange<Int> = 1...100
    static let buttonOptions: [String] = ["Left", "Right", "Middle"]
    static let intervalOptions: [String] = ["second", "minute"]
}

extension KeyboardShortcuts.Name {
    static let toggleClicking = Self("toggleClicking", default: .init(.l, modifiers: [.command]))
}
