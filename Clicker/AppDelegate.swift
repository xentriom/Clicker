//
//  AppDelegate.swift
//  Clicker
//
//  Created by Xentriom on 3/2/26.
//

import AppKit
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
  static let toggleClicking = Self(
    "toggleClicking",
    default: .init(.l, modifiers: [.command])
  )
}

final class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    NSApp.setActivationPolicy(.accessory)

    if ClickerState.shared.toLaunchAtLogin {
      ClickerState.shared.applyLaunchAtLogin()
    }

    KeyboardShortcuts.onKeyDown(for: .toggleClicking) {
      Task { @MainActor in
        ClickerState.shared.toggleClicking()
      }
    }
  }
}
