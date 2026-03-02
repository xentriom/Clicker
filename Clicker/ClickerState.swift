//
//  ClickerState.swift
//  Clicker
//
//  Created by Xentriom on 4/29/25.
//

import AppKit
import ServiceManagement
import SwiftUI

class ClickerState: ObservableObject {
  static let shared = ClickerState()

  @Published var isClicking = false

  @AppStorage("selectedMouseButton") var selectedMouseButton = "Left"
  @AppStorage("intervalHours") var intervalHours = 0
  @AppStorage("intervalMinutes") var intervalMinutes = 0
  @AppStorage("intervalSeconds") var intervalSeconds = 0
  @AppStorage("intervalMilliseconds") var intervalMilliseconds = 100
  @AppStorage("repeatMode") var repeatMode = "infinite"
  @AppStorage("repeatCount") var repeatCount = 10
  @AppStorage("toLaunchAtLogin") var toLaunchAtLogin = false

  var clickIntervalSeconds: TimeInterval {
    TimeInterval(intervalHours) * 3600
      + TimeInterval(intervalMinutes) * 60
      + TimeInterval(intervalSeconds)
      + TimeInterval(intervalMilliseconds) / 1000
  }

  @MainActor
  func toggleClicking() {
    isClicking.toggle()

    if isClicking {
      let count: Int? = repeatMode == "limited" ? max(1, repeatCount) : nil
      ClickerManager.startClicking(
        selectedMouseButton: selectedMouseButton,
        intervalSeconds: max(
          ClickerManager.minClickInterval,
          clickIntervalSeconds
        ),
        repeatCount: count
      ) { [weak self] in
        Task { @MainActor in
          self?.isClicking = false
        }
      }
    } else {
      ClickerManager.stopClicking()
    }
  }

  @MainActor
  func applyLaunchAtLogin() {
    if toLaunchAtLogin {
      try? SMAppService.mainApp.register()
    } else {
      try? SMAppService.mainApp.unregister()
    }
  }
}
