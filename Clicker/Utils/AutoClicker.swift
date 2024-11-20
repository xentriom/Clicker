//
//  AutoClicker.swift
//  Clicker
//
//  Created by Jason Chen on 11/19/24.
//

import SwiftUI
import Combine

class AutoClickerUtility {
    private var shouldStopClicking = false
    private var cancellable: AnyCancellable?
    
    /// Starts the clicker
    func startClicking(clicksPerUnit: Int, timeUnit: String, mouseButton: String, isRunning: Published<Bool>.Publisher) {
        let timeInterval = calculateTimeInterval(timeUnit: timeUnit, clicksPerUnit: clicksPerUnit)
        let mouseButtonMapped = mapMouseButton(mouseButton)
        shouldStopClicking = false
        
        print("Clicker started, triggering \(timeInterval) Clicks/\(timeUnit) using the \(mouseButton) mouse button.")
        
        cancellable = isRunning.sink { [weak self] running in
            if !running {
                self?.shouldStopClicking = true
            }
        }
        
        clickContinuously(interval: timeInterval, mouseButton: mouseButtonMapped)
    }
    
    /// Stops the clicker
    func stopClicking(isRunning: Published<Bool>.Publisher) {
        shouldStopClicking = true
        cancellable?.cancel()
        cancellable = nil
    }
    
    /// Calculates the clicks per time unit
    private func calculateTimeInterval(timeUnit: String, clicksPerUnit: Int) -> TimeInterval {
        switch timeUnit.lowercased() {
        case "minute":
            return 60.0 / Double(clicksPerUnit)
        case "second":
            return 1.0 / Double(clicksPerUnit)
        default:
            return 1.0 / Double(clicksPerUnit)
        }
    }
    
    /// Clicks continuously
    private func clickContinuously(interval: TimeInterval, mouseButton: CGMouseButton) {
        guard !shouldStopClicking else {
            return
        }
        
        performClick(button: mouseButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
            self?.clickContinuously(interval: interval, mouseButton: mouseButton)
        }
    }
    
    /// Calculatess the new position and performs the click
    private func performClick(button: CGMouseButton) {
        let mousePos = NSEvent.mouseLocation
        let screenHeight = NSScreen.main?.frame.height ?? 1080
        let point = CGPoint(x: mousePos.x, y: screenHeight - mousePos.y)
        
        let mouseDownEventType: CGEventType
        let mouseUpEventType: CGEventType

        switch button {
        case .center:
            mouseDownEventType = .otherMouseDown
            mouseUpEventType = .otherMouseUp
        case .right:
            mouseDownEventType = .rightMouseDown
            mouseUpEventType = .rightMouseUp
        default:
            mouseDownEventType = .leftMouseDown
            mouseUpEventType = .leftMouseUp
        }
        
        let mouseDown = CGEvent(mouseEventSource: nil, mouseType: mouseDownEventType, mouseCursorPosition: point, mouseButton: button)
        let mouseUp = CGEvent(mouseEventSource: nil, mouseType: mouseUpEventType, mouseCursorPosition: point, mouseButton: button)
        
        mouseDown?.post(tap: .cghidEventTap)
        mouseUp?.post(tap: .cghidEventTap)
    }
    
    /// Converts mouse button string to CGMouseButton type
    private func mapMouseButton(_ mouseButton: String) -> CGMouseButton {
        switch mouseButton.lowercased() {
        case "left":
            return .left
        case "middle":
            return .center
        case "right":
            return .right
        default:
            return .left
        }
    }
}
