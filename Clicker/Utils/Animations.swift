//
//  Animations.swift
//  Clicker
//
//  Created by Jason Chen on 11/19/24.
//

import SwiftUI

struct Animations {
    // Smooth Ease
    static let smoothEase = Animation.easeInOut(duration: 0.5)
    
    // Bounce Effect
    static let bounce = Animation.interpolatingSpring(stiffness: 80, damping: 8)
    
    // Slow Fade
    static let slowFade = Animation.linear(duration: 1.0)
    
    // Elastic Overshoot
    static func elasticOvershoot(duration: Double) -> Animation {
        Animation.spring(response: duration, dampingFraction: 0.6, blendDuration: 0.4)
    }
    
    // Predefined Transitions
    static let slideAndFade = AnyTransition.move(edge: .top).combined(with: .opacity)
    static let scaleAndFade = AnyTransition.scale(scale: 0.9).combined(with: .opacity)
    
    // Cascading Fade and Slide Transition
    static let cascadingFadeAndSlide: AnyTransition = AnyTransition.asymmetric(
        insertion: slideAndFade.animation(Animation.easeInOut(duration: 0.4)),
        removal: scaleAndFade.animation(Animation.easeOut(duration: 0.3))
    )
}
