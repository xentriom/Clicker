//
//  IntervalView.swift
//  Clicker
//
//  Created by Jason Chen on 11/19/24.
//

import SwiftUI

struct IntervalView: View {
    @Binding var clicksPerUnit: Int
    @Binding var selectedMouseButton: String
    @Binding var selectedTimeUnit: String
    
    var body: some View {
        VStack {
            HStack {
                Text("Click using")
                
                Picker("", selection: $selectedMouseButton) {
                    ForEach(AppConstants.mouseButtons, id: \.self) { button in
                        Text(button)
                    }
                }
                
                Text("mouse button")
            }
            
            HStack {
                Text("Click")
                
                HStack(spacing: 0) {
                    TextField("Clicks", value: $clicksPerUnit, formatter: NumberFormatter())
                        .frame(width: 45)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Stepper("", value: $clicksPerUnit, in: AppConstants.clickCountRange)
                }
                
                Text("times per")
                
                Picker("", selection: $selectedTimeUnit) {
                    ForEach(AppConstants.timeUnits, id: \.self) { unit in
                        Text(unit)
                    }
                }
            }
        }
    }
}
