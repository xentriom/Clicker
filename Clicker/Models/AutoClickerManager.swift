//
//  AutoClickerManager.swift
//  Clicker
//
//  Created by Jason Chen on 11/19/24.
//

import Combine
import SwiftUI

final class AutoClickerManager: ObservableObject {
    @Published var isRunning = false {
        didSet {
            if isRunning {
                startClicking()
            } else {
                stopClicking()
            }
        }
    }
    
    private let autoClicker = AutoClickerUtility()
    
    // Configuration from AppStorage
    @AppStorage("selectedMouseButton") private var selectedMouseButton = AppConstants.defaultMouseButton
    @AppStorage("selectedTimeUnit") private var selectedTimeUnit = AppConstants.defaultTimeUnit
    @AppStorage("clicksPerUnit") private var clicksPerUnit = AppConstants.defaultClickCount
    
    private func startClicking() {
        guard clicksPerUnit >= 1 && clicksPerUnit <= 500 else {
            isRunning = false
            return
        }
        
        autoClicker.startClicking(
            clicksPerUnit: clicksPerUnit,
            timeUnit: selectedTimeUnit,
            mouseButton: selectedMouseButton,
            isRunning: $isRunning
        )
    }
    
    private func stopClicking() {
        autoClicker.stopClicking(isRunning: $isRunning)
    }
}
