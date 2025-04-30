//
//  ClickerManager.swift
//  Clicker
//
//  Created by Xentriom on 4/29/25.
//

import Cocoa

enum ClickerManager {
    private static var timer: Timer?
    private static var lastMovedTime: TimeInterval = Date().timeIntervalSince1970

    static func startClicking(selectedMouseButton: String, selectedClickInterval: String, selectedClickRate: Int) {
        // Monitor mouse movement
        NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { _ in
            self.lastMovedTime = Date().timeIntervalSince1970
        }

        // Convert "20 per second" → 0.05 sec
        let multiplier: TimeInterval = selectedClickInterval.lowercased() == "minute" ? 60.0 : 1.0
        let interval = multiplier / max(1.0, Double(selectedClickRate))

        let button: CGMouseButton
        switch selectedMouseButton.lowercased() {
        case "right": button = .right
        case "middle": button = .center
        default: button = .left
        }

        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            performClick(button: button)
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    static func stopClicking() {
        timer?.invalidate()
        timer = nil
    }

    private static func performClick(button: CGMouseButton) {
        let point = NSEvent.mouseLocation
        guard let screenHeight = NSScreen.main?.frame.height else { return }
        let flippedPoint = CGPoint(x: point.x, y: screenHeight - point.y)

        let mouseDown = CGEvent(mouseEventSource: nil, mouseType: downType(for: button), mouseCursorPosition: flippedPoint, mouseButton: button)
        let mouseUp = CGEvent(mouseEventSource: nil, mouseType: upType(for: button), mouseCursorPosition: flippedPoint, mouseButton: button)

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
