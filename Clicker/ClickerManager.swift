//
//  ClickerManager.swift
//  Clicker
//
//  Created by Xentriom on 4/29/25.
//

import Cocoa

enum ClickerManager {
  /// Minimum interval between clicks (seconds). Caps max rate at 100 CPS.
  static let minClickInterval: TimeInterval = 0.01
  private static var timer: Timer?
  private static var onStopped: (() -> Void)?
  private static var remainingClicks: Int?

  static func startClicking(
    selectedMouseButton: String,
    intervalSeconds: TimeInterval,
    repeatCount: Int? = nil,
    onStopped: (() -> Void)? = nil
  ) {
    self.onStopped = onStopped
    self.remainingClicks = repeatCount
    let interval = max(minClickInterval, intervalSeconds)

    let button: CGMouseButton
    switch selectedMouseButton.lowercased() {
    case "right": button = .right
    case "middle": button = .center
    default: button = .left
    }

    timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) {
      _ in
      performClick(button: button)
      if var remaining = remainingClicks {
        remaining -= 1
        remainingClicks = remaining > 0 ? remaining : nil
        if remaining <= 0 {
          stopClicking()
          DispatchQueue.main.async { onStopped?() }
        }
      }
    }
    RunLoop.main.add(timer!, forMode: .common)
  }

  static func stopClicking() {
    timer?.invalidate()
    timer = nil
    onStopped = nil
    remainingClicks = nil
  }

  private static func performClick(button: CGMouseButton) {
    let point = NSEvent.mouseLocation
    guard let screenHeight = NSScreen.main?.frame.height else { return }
    let flippedPoint = CGPoint(x: point.x, y: screenHeight - point.y)

    let mouseDown = CGEvent(
      mouseEventSource: nil,
      mouseType: downType(for: button),
      mouseCursorPosition: flippedPoint,
      mouseButton: button
    )
    let mouseUp = CGEvent(
      mouseEventSource: nil,
      mouseType: upType(for: button),
      mouseCursorPosition: flippedPoint,
      mouseButton: button
    )

    mouseDown?.post(tap: .cghidEventTap)
    mouseUp?.post(tap: .cghidEventTap)
  }

  private static func downType(for button: CGMouseButton) -> CGEventType {
    switch button {
    case .left: return .leftMouseDown
    case .right: return .rightMouseDown
    case .center: return .otherMouseDown
    default: return .leftMouseDown
    }
  }

  private static func upType(for button: CGMouseButton) -> CGEventType {
    switch button {
    case .left: return .leftMouseUp
    case .right: return .rightMouseUp
    case .center: return .otherMouseUp
    default: return .leftMouseUp
    }
  }
}
