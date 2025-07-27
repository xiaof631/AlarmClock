//
//  ThemeTransitionManager.swift
//  AlarmClock
//
//  Created by Kiro on 27/7/25.
//

import SwiftUI
import Combine

@MainActor
class ThemeTransitionManager: ObservableObject {
    @Published var isTransitioning = false
    private let transitionDuration: TimeInterval = 0.2
    
    static let shared = ThemeTransitionManager()
    
    private init() {}
    
    func performThemeTransition<T>(_ action: @escaping () -> T) -> T {
        isTransitioning = true
        
        let result = withAnimation(.easeInOut(duration: transitionDuration)) {
            action()
        }
        
        // Reset transition state after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + transitionDuration) {
            self.isTransitioning = false
        }
        
        return result
    }
    
    func performThemeTransition(_ action: @escaping () -> Void) {
        isTransitioning = true
        
        withAnimation(.easeInOut(duration: transitionDuration)) {
            action()
        }
        
        // Reset transition state after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + transitionDuration) {
            self.isTransitioning = false
        }
    }
}

// MARK: - Theme Transition View Modifier

struct ThemeTransitionModifier: ViewModifier {
    @StateObject private var transitionManager = ThemeTransitionManager.shared
    @EnvironmentObject private var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .animation(.easeInOut(duration: 0.2), value: themeManager.currentTheme)
            .environmentObject(transitionManager)
    }
}

extension View {
    func withThemeTransitions() -> some View {
        self.modifier(ThemeTransitionModifier())
    }
}

// MARK: - Smooth Color Transition

struct SmoothColorTransition: ViewModifier {
    let colorType: ThemeColorType
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var transitionManager = ThemeTransitionManager.shared
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(ThemeColorProvider.getColor(for: colorType, theme: themeManager.currentTheme))
            .animation(.easeInOut(duration: 0.2), value: themeManager.currentTheme)
    }
}

struct SmoothBackgroundTransition: ViewModifier {
    let colorType: ThemeColorType
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var transitionManager = ThemeTransitionManager.shared
    
    func body(content: Content) -> some View {
        content
            .background(ThemeColorProvider.getColor(for: colorType, theme: themeManager.currentTheme))
            .animation(.easeInOut(duration: 0.2), value: themeManager.currentTheme)
    }
}

extension View {
    func smoothThemedForeground(_ colorType: ThemeColorType = .primaryText) -> some View {
        self.modifier(SmoothColorTransition(colorType: colorType))
    }
    
    func smoothThemedBackground(_ colorType: ThemeColorType = .primaryBackground) -> some View {
        self.modifier(SmoothBackgroundTransition(colorType: colorType))
    }
}

// MARK: - Theme Transition Coordinator

class ThemeTransitionCoordinator {
    static let shared = ThemeTransitionCoordinator()
    
    private var activeTransitions: Set<String> = []
    private let transitionQueue = DispatchQueue(label: "theme.transition", qos: .userInteractive)
    
    private init() {}
    
    func coordinateTransition(identifier: String, action: @escaping () -> Void) {
        transitionQueue.async {
            guard !self.activeTransitions.contains(identifier) else { return }
            
            self.activeTransitions.insert(identifier)
            
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.2)) {
                    action()
                }
                
                // Remove from active transitions after completion
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.transitionQueue.async {
                        self.activeTransitions.remove(identifier)
                    }
                }
            }
        }
    }
    
    func isTransitionActive(identifier: String) -> Bool {
        return transitionQueue.sync {
            activeTransitions.contains(identifier)
        }
    }
}