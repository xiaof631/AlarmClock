//
//  ThemeAwareView.swift
//  AlarmClock
//
//  Created by Kiro on 27/7/25.
//

import SwiftUI

// MARK: - View Extensions for Theme Support
extension View {
    func themedAccent() -> some View {
        self.modifier(ThemedAccentModifier())
    }
    
    func themedBackground(_ colorType: ThemeColorType = .primaryBackground) -> some View {
        self.modifier(ThemedBackgroundModifier(colorType: colorType))
    }
    
    func themedForeground(_ colorType: ThemeColorType = .primaryText) -> some View {
        self.modifier(ThemedForegroundModifier(colorType: colorType))
    }
}

// MARK: - Theme Modifiers
struct ThemedAccentModifier: ViewModifier {
    @EnvironmentObject private var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .accentColor(themeManager.getColorTheme().accentColor)
    }
}

struct ThemedBackgroundModifier: ViewModifier {
    let colorType: ThemeColorType
    @EnvironmentObject private var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        let theme = themeManager.getColorTheme()
        let backgroundColor: Color
        
        switch colorType {
        case .primaryBackground:
            backgroundColor = theme.primaryBackground
        case .secondaryBackground:
            backgroundColor = theme.secondaryBackground
        case .tertiaryBackground:
            backgroundColor = theme.tertiaryBackground
        case .cardBackground:
            backgroundColor = theme.cardBackground
        case .navigationBarBackground:
            backgroundColor = theme.navigationBarBackground
        case .tabBarBackground:
            backgroundColor = theme.tabBarBackground
        case .listBackground:
            backgroundColor = theme.listBackground
        default:
            backgroundColor = theme.primaryBackground
        }
        
        return content
            .background(backgroundColor)
    }
}

struct ThemedForegroundModifier: ViewModifier {
    let colorType: ThemeColorType
    @EnvironmentObject private var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        let theme = themeManager.getColorTheme()
        let foregroundColor: Color
        
        switch colorType {
        case .primaryText:
            foregroundColor = theme.primaryText
        case .secondaryText:
            foregroundColor = theme.secondaryText
        case .disabledText:
            foregroundColor = theme.disabledText
        default:
            foregroundColor = theme.primaryText
        }
        
        return content
            .foregroundColor(foregroundColor)
    }
}

struct ThemeAwareView<Content: View>: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.colorScheme) private var colorScheme
    
    let content: (ColorTheme) -> Content
    
    init(@ViewBuilder content: @escaping (ColorTheme) -> Content) {
        self.content = content
    }
    
    var body: some View {
        content(themeManager.getColorTheme())
            .onChange(of: colorScheme) { newColorScheme in
                themeManager.updateSystemAppearance(newColorScheme)
            }
    }
}

// MARK: - Usage Example

struct ExampleThemeUsage: View {
    @StateObject private var themeManager = ThemeManager()
    
    var body: some View {
        NavigationView {
            ThemeAwareView { theme in
                VStack(spacing: 20) {
                    Text("Theme Example")
                        .font(.title)
                        .foregroundColor(theme.primaryText)
                    
                    Button("Toggle Theme") {
                        switch themeManager.themeMode {
                        case .light:
                            themeManager.setTheme(.dark)
                        case .dark:
                            themeManager.setTheme(.auto)
                        case .auto:
                            themeManager.setTheme(.light)
                        }
                    }
                    .padding()
                    .background(theme.buttonBackground)
                    .foregroundColor(theme.buttonText)
                    .cornerRadius(8)
                    
                    Text("Current theme: \(themeManager.currentTheme.rawValue)")
                        .foregroundColor(theme.secondaryText)
                }
                .padding()
                .background(theme.primaryBackground)
            }
            .environmentObject(themeManager)
        }
    }
}

#Preview {
    ExampleThemeUsage()
}