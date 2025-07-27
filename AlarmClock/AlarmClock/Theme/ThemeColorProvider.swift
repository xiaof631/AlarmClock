//
//  ThemeColorProvider.swift
//  AlarmClock
//
//  Created by Kiro on 27/7/25.
//

import SwiftUI

enum ThemeColorType {
    // Background Colors
    case primaryBackground
    case secondaryBackground
    case tertiaryBackground
    case cardBackground
    
    // Text Colors
    case primaryText
    case secondaryText
    case disabledText
    
    // Interactive Colors
    case accentColor
    case buttonBackground
    case buttonText
    case linkColor
    
    // System Colors
    case successColor
    case warningColor
    case errorColor
    
    // Component-specific Colors
    case navigationBarBackground
    case tabBarBackground
    case listBackground
    case separatorColor
    case selectionColor
}

struct ThemeColorProvider {
    static func getColor(for colorType: ThemeColorType, theme: ThemeManager.AppTheme) -> Color {
        switch theme {
        case .light, .auto:
            return getLightThemeColor(for: colorType)
        case .dark:
            return getDarkThemeColor(for: colorType)
        }
    }
    
    // MARK: - Light Theme Colors
    
    private static func getLightThemeColor(for colorType: ThemeColorType) -> Color {
        switch colorType {
        // Background Colors
        case .primaryBackground:
            return Color(.systemBackground)
        case .secondaryBackground:
            return Color(.secondarySystemBackground)
        case .tertiaryBackground:
            return Color(.tertiarySystemBackground)
        case .cardBackground:
            return Color(.systemGray6)
            
        // Text Colors
        case .primaryText:
            return Color(.label)
        case .secondaryText:
            return Color(.secondaryLabel)
        case .disabledText:
            return Color(.tertiaryLabel)
            
        // Interactive Colors
        case .accentColor:
            return Color.blue
        case .buttonBackground:
            return Color.blue
        case .buttonText:
            return Color.white
        case .linkColor:
            return Color.blue
            
        // System Colors
        case .successColor:
            return Color.green
        case .warningColor:
            return Color.orange
        case .errorColor:
            return Color.red
            
        // Component-specific Colors
        case .navigationBarBackground:
            return Color(.systemBackground)
        case .tabBarBackground:
            return Color(.systemBackground)
        case .listBackground:
            return Color(.systemBackground)
        case .separatorColor:
            return Color(.separator)
        case .selectionColor:
            return Color(.systemBlue).opacity(0.2)
        }
    }
    
    // MARK: - Dark Theme Colors
    
    private static func getDarkThemeColor(for colorType: ThemeColorType) -> Color {
        switch colorType {
        // Background Colors
        case .primaryBackground:
            return Color(.systemBackground)
        case .secondaryBackground:
            return Color(.secondarySystemBackground)
        case .tertiaryBackground:
            return Color(.tertiarySystemBackground)
        case .cardBackground:
            return Color(.systemGray5)
            
        // Text Colors
        case .primaryText:
            return Color(.label)
        case .secondaryText:
            return Color(.secondaryLabel)
        case .disabledText:
            return Color(.tertiaryLabel)
            
        // Interactive Colors
        case .accentColor:
            return Color.blue
        case .buttonBackground:
            return Color.blue
        case .buttonText:
            return Color.white
        case .linkColor:
            return Color.blue
            
        // System Colors
        case .successColor:
            return Color.green
        case .warningColor:
            return Color.orange
        case .errorColor:
            return Color.red
            
        // Component-specific Colors
        case .navigationBarBackground:
            return Color(.systemBackground)
        case .tabBarBackground:
            return Color(.systemBackground)
        case .listBackground:
            return Color(.systemBackground)
        case .separatorColor:
            return Color(.separator)
        case .selectionColor:
            return Color(.systemBlue).opacity(0.3)
        }
    }
}

// MARK: - Color Theme Configuration

struct ColorTheme {
    // Background Colors
    let primaryBackground: Color
    let secondaryBackground: Color
    let tertiaryBackground: Color
    let cardBackground: Color
    
    // Text Colors
    let primaryText: Color
    let secondaryText: Color
    let disabledText: Color
    
    // Interactive Colors
    let accentColor: Color
    let buttonBackground: Color
    let buttonText: Color
    let linkColor: Color
    
    // System Colors
    let successColor: Color
    let warningColor: Color
    let errorColor: Color
    
    // Component-specific Colors
    let navigationBarBackground: Color
    let tabBarBackground: Color
    let listBackground: Color
    let separatorColor: Color
    let selectionColor: Color
    
    static func lightTheme() -> ColorTheme {
        return ColorTheme(
            primaryBackground: ThemeColorProvider.getColor(for: .primaryBackground, theme: .light),
            secondaryBackground: ThemeColorProvider.getColor(for: .secondaryBackground, theme: .light),
            tertiaryBackground: ThemeColorProvider.getColor(for: .tertiaryBackground, theme: .light),
            cardBackground: ThemeColorProvider.getColor(for: .cardBackground, theme: .light),
            primaryText: ThemeColorProvider.getColor(for: .primaryText, theme: .light),
            secondaryText: ThemeColorProvider.getColor(for: .secondaryText, theme: .light),
            disabledText: ThemeColorProvider.getColor(for: .disabledText, theme: .light),
            accentColor: ThemeColorProvider.getColor(for: .accentColor, theme: .light),
            buttonBackground: ThemeColorProvider.getColor(for: .buttonBackground, theme: .light),
            buttonText: ThemeColorProvider.getColor(for: .buttonText, theme: .light),
            linkColor: ThemeColorProvider.getColor(for: .linkColor, theme: .light),
            successColor: ThemeColorProvider.getColor(for: .successColor, theme: .light),
            warningColor: ThemeColorProvider.getColor(for: .warningColor, theme: .light),
            errorColor: ThemeColorProvider.getColor(for: .errorColor, theme: .light),
            navigationBarBackground: ThemeColorProvider.getColor(for: .navigationBarBackground, theme: .light),
            tabBarBackground: ThemeColorProvider.getColor(for: .tabBarBackground, theme: .light),
            listBackground: ThemeColorProvider.getColor(for: .listBackground, theme: .light),
            separatorColor: ThemeColorProvider.getColor(for: .separatorColor, theme: .light),
            selectionColor: ThemeColorProvider.getColor(for: .selectionColor, theme: .light)
        )
    }
    
    static func darkTheme() -> ColorTheme {
        return ColorTheme(
            primaryBackground: ThemeColorProvider.getColor(for: .primaryBackground, theme: .dark),
            secondaryBackground: ThemeColorProvider.getColor(for: .secondaryBackground, theme: .dark),
            tertiaryBackground: ThemeColorProvider.getColor(for: .tertiaryBackground, theme: .dark),
            cardBackground: ThemeColorProvider.getColor(for: .cardBackground, theme: .dark),
            primaryText: ThemeColorProvider.getColor(for: .primaryText, theme: .dark),
            secondaryText: ThemeColorProvider.getColor(for: .secondaryText, theme: .dark),
            disabledText: ThemeColorProvider.getColor(for: .disabledText, theme: .dark),
            accentColor: ThemeColorProvider.getColor(for: .accentColor, theme: .dark),
            buttonBackground: ThemeColorProvider.getColor(for: .buttonBackground, theme: .dark),
            buttonText: ThemeColorProvider.getColor(for: .buttonText, theme: .dark),
            linkColor: ThemeColorProvider.getColor(for: .linkColor, theme: .dark),
            successColor: ThemeColorProvider.getColor(for: .successColor, theme: .dark),
            warningColor: ThemeColorProvider.getColor(for: .warningColor, theme: .dark),
            errorColor: ThemeColorProvider.getColor(for: .errorColor, theme: .dark),
            navigationBarBackground: ThemeColorProvider.getColor(for: .navigationBarBackground, theme: .dark),
            tabBarBackground: ThemeColorProvider.getColor(for: .tabBarBackground, theme: .dark),
            listBackground: ThemeColorProvider.getColor(for: .listBackground, theme: .dark),
            separatorColor: ThemeColorProvider.getColor(for: .separatorColor, theme: .dark),
            selectionColor: ThemeColorProvider.getColor(for: .selectionColor, theme: .dark)
        )
    }
}

// MARK: - Theme Configuration

struct ThemeConfiguration {
    let lightTheme: ColorTheme
    let darkTheme: ColorTheme
    let transitionDuration: TimeInterval
    
    static let `default` = ThemeConfiguration(
        lightTheme: ColorTheme.lightTheme(),
        darkTheme: ColorTheme.darkTheme(),
        transitionDuration: 0.2
    )
}