//
//  ThemeManager.swift
//  AlarmClock
//
//  Created by Kiro on 27/7/25.
//

import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    // 添加shared单例
    static let shared = ThemeManager()
    
    enum AppTheme: String, CaseIterable {
        case light = "light"
        case dark = "dark"
        case auto = "auto"
        
        var colorScheme: ColorScheme? {
            switch self {
            case .light: return .light
            case .dark: return .dark
            case .auto: return nil
            }
        }
        

    }
    
    @Published var currentTheme: AppTheme
    @Published var themeMode: AppTheme
    
    private let userDefaults = UserDefaults.standard
    private let themeKey = "selectedTheme"
    
    init() {
        // 先加载偏好设置
        let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme") ?? AppTheme.auto.rawValue
        let savedPreference = AppTheme(rawValue: savedTheme) ?? .auto
        self.themeMode = savedPreference
        
        // 再确定当前主题
        if savedPreference == .auto {
            self.currentTheme = .light // 默认为light，稍后通过observer更新
        } else {
            self.currentTheme = savedPreference
        }
        
        // 在所有属性初始化后再调用方法
        setupSystemAppearanceObserver()
    }
    
    private func loadThemePreference() -> AppTheme {
        let savedTheme = userDefaults.string(forKey: themeKey) ?? AppTheme.auto.rawValue
        return AppTheme(rawValue: savedTheme) ?? .auto
    }
    
    private func detectSystemAppearance() -> AppTheme {
        // This will be updated when the system appearance changes
        // For now, we'll default to light and update it through the observer
        return .light
    }
    
    private func setupSystemAppearanceObserver() {
        // System appearance observation will be handled by the SwiftUI environment
        // The actual detection will happen in the view layer
    }
    
    func setTheme(_ theme: AppTheme) {
        themeMode = theme
        userDefaults.set(theme.rawValue, forKey: themeKey)
        
        if theme == .auto {
            currentTheme = detectSystemAppearance()
        } else {
            currentTheme = theme
        }
    }
    
    func updateSystemAppearance(_ colorScheme: ColorScheme) {
        if themeMode == .auto {
            currentTheme = colorScheme == .dark ? .dark : .light
        }
    }
    
    func getColorTheme() -> ColorTheme {
        switch currentTheme {
        case .light, .auto:
            return ColorTheme.lightTheme()
        case .dark:
            return ColorTheme.darkTheme()
        }
    }
}

// MARK: - Theme Environment

struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue = ThemeManager()
}

extension EnvironmentValues {
    var themeManager: ThemeManager {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

// MARK: - View Extensions

extension View {
    func themeManager(_ manager: ThemeManager) -> some View {
        environment(\.themeManager, manager)
    }
    
    func withThemeProvider() -> some View {
        self.environmentObject(ThemeManager.shared)
    }
}