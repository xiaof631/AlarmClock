//
//  ThemePerformanceMonitor.swift
//  AlarmClock
//
//  Created by Kiro on 27/7/25.
//

import SwiftUI
import os.log

class ThemePerformanceMonitor: ObservableObject {
    static let shared = ThemePerformanceMonitor()
    
    private let logger = Logger(subsystem: "com.alarmclock.theme", category: "Performance")
    private let maxTransitionTime: TimeInterval = 0.2 // 200ms requirement
    
    @Published var averageTransitionTime: TimeInterval = 0
    @Published var lastTransitionTime: TimeInterval = 0
    @Published var transitionCount: Int = 0
    
    private var transitionTimes: [TimeInterval] = []
    private var currentTransitionStart: Date?
    
    private init() {}
    
    func startTransitionMeasurement() {
        currentTransitionStart = Date()
    }
    
    func endTransitionMeasurement() {
        guard let startTime = currentTransitionStart else { return }
        
        let transitionTime = Date().timeIntervalSince(startTime)
        lastTransitionTime = transitionTime
        transitionTimes.append(transitionTime)
        transitionCount += 1
        
        // Keep only last 100 measurements
        if transitionTimes.count > 100 {
            transitionTimes.removeFirst()
        }
        
        // Calculate average
        averageTransitionTime = transitionTimes.reduce(0, +) / Double(transitionTimes.count)
        
        // Log performance
        if transitionTime > maxTransitionTime {
            logger.warning("Theme transition exceeded target time: \(transitionTime * 1000)ms (target: \(self.maxTransitionTime * 1000)ms)")
        } else {
            logger.info("Theme transition completed in \(transitionTime * 1000)ms")
        }
        
        currentTransitionStart = nil
    }
    
    func getPerformanceStats() -> ThemePerformanceStats {
        return ThemePerformanceStats(
            averageTransitionTime: averageTransitionTime,
            lastTransitionTime: lastTransitionTime,
            transitionCount: transitionCount,
            isWithinTarget: averageTransitionTime <= maxTransitionTime,
            maxTransitionTime: transitionTimes.max() ?? 0,
            minTransitionTime: transitionTimes.min() ?? 0
        )
    }
    
    func resetStats() {
        transitionTimes.removeAll()
        averageTransitionTime = 0
        lastTransitionTime = 0
        transitionCount = 0
    }
}

struct ThemePerformanceStats {
    let averageTransitionTime: TimeInterval
    let lastTransitionTime: TimeInterval
    let transitionCount: Int
    let isWithinTarget: Bool
    let maxTransitionTime: TimeInterval
    let minTransitionTime: TimeInterval
    
    var averageTransitionTimeMs: Double {
        averageTransitionTime * 1000
    }
    
    var lastTransitionTimeMs: Double {
        lastTransitionTime * 1000
    }
    
    var maxTransitionTimeMs: Double {
        maxTransitionTime * 1000
    }
    
    var minTransitionTimeMs: Double {
        minTransitionTime * 1000
    }
}

// MARK: - Performance Optimized Theme Manager Extension

extension ThemeManager {
    func setThemeModeOptimized(_ mode: AppTheme) {
        ThemePerformanceMonitor.shared.startTransitionMeasurement()
        
        let oldMode = themeMode
        let oldTheme = currentTheme
        
        // Batch the updates to minimize redraws
        withAnimation(.easeInOut(duration: 0.2)) {
            setTheme(mode)
        }
        
        ThemePerformanceMonitor.shared.endTransitionMeasurement()
    }
    
    private func saveThemePreferenceAsync() async {
        // Simplified preference saving
        await MainActor.run {
            UserDefaults.standard.set(themeMode.rawValue, forKey: "app_theme_preference")
        }
    }
}

// MARK: - Lazy Color Loading

class LazyColorCache {
    static let shared = LazyColorCache()
    
    private var colorCache: [String: Color] = [:]
    private let cacheQueue = DispatchQueue(label: "theme.color.cache", attributes: .concurrent)
    
    private init() {}
    
    func getColor(for colorType: ThemeColorType, theme: ThemeManager.AppTheme) -> Color {
        let cacheKey = "\(colorType)_\(theme)"
        
        return cacheQueue.sync {
            if let cachedColor = colorCache[cacheKey] {
                return cachedColor
            }
            
            let color = ThemeColorProvider.getColor(for: colorType, theme: theme)
            
            cacheQueue.async(flags: .barrier) {
                self.colorCache[cacheKey] = color
            }
            
            return color
        }
    }
    
    func clearCache() {
        cacheQueue.async(flags: .barrier) {
            self.colorCache.removeAll()
        }
    }
    
    func getCacheSize() -> Int {
        return cacheQueue.sync {
            colorCache.count
        }
    }
}

// MARK: - Memory Management

extension ThemeManager {
    func optimizeMemoryUsage() {
        // Clear color cache if it gets too large
        if LazyColorCache.shared.getCacheSize() > 50 {
            LazyColorCache.shared.clearCache()
        }
        
        // Reset performance stats if they get too large
        if ThemePerformanceMonitor.shared.transitionCount > 1000 {
            ThemePerformanceMonitor.shared.resetStats()
        }
    }
}

// MARK: - Performance View Modifier

struct PerformanceOptimizedThemeModifier: ViewModifier {
    @EnvironmentObject private var themeManager: ThemeManager
    let colorType: ThemeColorType
    let isBackground: Bool
    
    func body(content: Content) -> some View {
        let color = LazyColorCache.shared.getColor(for: colorType, theme: themeManager.currentTheme)
        
        if isBackground {
            content
                .background(color)
                .animation(.easeInOut(duration: 0.2), value: themeManager.currentTheme)
        } else {
            content
                .foregroundColor(color)
                .animation(.easeInOut(duration: 0.2), value: themeManager.currentTheme)
        }
    }
}

extension View {
    func optimizedThemedForeground(_ colorType: ThemeColorType = .primaryText) -> some View {
        self.modifier(PerformanceOptimizedThemeModifier(colorType: colorType, isBackground: false))
    }
    
    func optimizedThemedBackground(_ colorType: ThemeColorType = .primaryBackground) -> some View {
        self.modifier(PerformanceOptimizedThemeModifier(colorType: colorType, isBackground: true))
    }
}