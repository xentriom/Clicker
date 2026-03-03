//
//  ClickerApp.swift
//  Clicker
//
//  Created by Xentriom on 4/29/25.
//

import AppKit
import SwiftUI

@main
struct ClickerApp: App {
  @StateObject private var clickerState = ClickerState.shared
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    MenuBarExtra(
      "Clicker",
      systemImage: clickerState.isClicking ? "magicmouse.fill" : "magicmouse"
    ) {
      MenuBarView().environmentObject(clickerState)
    }.menuBarExtraStyle(.window)
  }
}
