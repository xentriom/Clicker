//
//  ClickerApp.swift
//  Clicker
//
//  Created by Xentriom on 4/29/25.
//

import AppKit
import Sparkle
import SwiftUI

private final class UpdaterDelegate: NSObject, SPUUpdaterDelegate {
  func feedURLString(for updater: SPUUpdater) -> String? {
    "https://raw.githubusercontent.com/xentriom/Clicker/main/appcast.xml"
  }
}

private enum Updater {
  static let delegate = UpdaterDelegate()
  static let controller = SPUStandardUpdaterController(
    startingUpdater: true,
    updaterDelegate: delegate,
    userDriverDelegate: nil
  )
}

@main
struct ClickerApp: App {
  @StateObject private var clickerState = ClickerState.shared
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    MenuBarExtra(
      "Clicker",
      systemImage: clickerState.isClicking ? "magicmouse.fill" : "magicmouse"
    ) {
      MenuBarView(updater: Updater.controller.updater)
        .environmentObject(clickerState)
    }.menuBarExtraStyle(.window)
  }
}
