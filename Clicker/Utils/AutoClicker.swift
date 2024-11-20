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
    
    func startClicking(clicksPerUnit: Int, timeUnit: String, mouseButton: String, isRunning: Published<Bool>.Publisher) {
        print("Start clicking with \(clicksPerUnit) clicks per \(timeUnit) using the \(mouseButton) button.")
        
        let timeInterval: TimeInterval = {
            switch timeUnit.lowercased() {
            case "minute":
                return 60.0 / Double(clicksPerUnit)
            case "second":
                return 1.0 / Double(clicksPerUnit)
            default:
                print("Unsupported time unit: \(timeUnit). Defaulting to seconds.")
                return 1.0 / Double(clicksPerUnit)
            }
        }()
        
        let mouseButtonMapped = mapMouseButton(mouseButton)
        shouldStopClicking = false
        
        cancellable = isRunning.sink { [weak self] running in
            if !running {
                self?.shouldStopClicking = true
            }
        }
        
        clickContinuously(interval: timeInterval, mouseButton: mouseButtonMapped)
    }
    
    func stopClicking(isRunning: Published<Bool>.Publisher) {
        shouldStopClicking = true
        cancellable?.cancel()
        cancellable = nil
    }
    
    private func clickContinuously(interval: TimeInterval, mouseButton: CGMouseButton) {
        guard !shouldStopClicking else {
            return
        }
        
        print("clicking")
        performClick(button: mouseButton)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
            self?.clickContinuously(interval: interval, mouseButton: mouseButton)
        }
    }
    
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

