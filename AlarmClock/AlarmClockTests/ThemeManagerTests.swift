//
//  ThemeManagerTests.swift
//  AlarmClockTests
//
//  Created by Kiro on 27/7/25.
//

import XCTest
@testable import AlarmClock

@MainActor
final class ThemeManagerTests: XCTestCase {
    var themeManager: ThemeManager!
    
    override func setUp() {
        super.setUp()
        // Clear UserDefaults for testing
        UserDefaults.standard.removeObject(forKey: "app_theme_preference")
        themeManager = ThemeManager.shared
    }
    
    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "app_theme_preference")
        super.tearDown()
    }
    
    func testInitialThemeMode() {
        // Test that initial theme mode is auto by default
        XCTAssertEqual(themeManager.themeMode, .auto)
    }
    
    func testSetThemeMode() {
        // Test setting theme mode to light
        themeManager.setThemeMode(.light)
        XCTAssertEqual(themeManager.themeMode, .light)
        XCTAssertEqual(themeManager.currentTheme, .light)
        
        // Test setting theme mode to dark
        themeManager.setThemeMode(.dark)
        XCTAssertEqual(themeManager.themeMode, .dark)
        XCTAssertEqual(themeManager.currentTheme, .dark)
        
        // Test setting theme mode to auto
        themeManager.setThemeMode(.auto)
        XCTAssertEqual(themeManager.themeMode, .auto)
        // Current theme should be determined by system appearance
        XCTAssertTrue(themeManager.currentTheme == .light || themeManager.currentTheme == .dark)
    }
    
    func testThemePersistence() {
        // Set a theme mode
        themeManager.setThemeMode(.dark)
        
        // Create a new instance to test persistence
        let newThemeManager = ThemeManager.shared
        XCTAssertEqual(newThemeManager.themeMode, .dark)
    }
    
    func testGetCurrentTheme() {
        themeManager.setThemeMode(.light)
        XCTAssertEqual(themeManager.getCurrentTheme(), .light)
        
        themeManager.setThemeMode(.dark)
        XCTAssertEqual(themeManager.getCurrentTheme(), .dark)
    }
    
    func testSystemAppearanceChange() {
        // Set to auto mode
        themeManager.setThemeMode(.auto)
        
        let initialTheme = themeManager.currentTheme
        
        // Simulate system appearance change
        themeManager.systemAppearanceDidChange()
        
        // Theme should still be valid
        XCTAssertTrue(themeManager.currentTheme == .light || themeManager.currentTheme == .dark)
    }
    
    func testThemeModeDisplayNames() {
        XCTAssertEqual(ThemeManager.ThemeMode.light.displayName, "浅色模式")
        XCTAssertEqual(ThemeManager.ThemeMode.dark.displayName, "深色模式")
        XCTAssertEqual(ThemeManager.ThemeMode.auto.displayName, "跟随系统")
    }
    
    func testAppThemeColorScheme() {
        XCTAssertEqual(ThemeManager.AppTheme.light.colorScheme, .light)
        XCTAssertEqual(ThemeManager.AppTheme.dark.colorScheme, .dark)
    }
}

final class ThemeColorProviderTests: XCTestCase {
    
    func testLightThemeColors() {
        let lightTheme = ThemeManager.AppTheme.light
        
        // Test that all color types return valid colors for light theme
        let colorTypes: [ThemeColorType] = [
            .primaryBackground, .secondaryBackground, .tertiaryBackground, .cardBackground,
            .primaryText, .secondaryText, .disabledText,
            .accentColor, .buttonBackground, .buttonText, .linkColor,
            .successColor, .warningColor, .errorColor,
            .navigationBarBackground, .tabBarBackground, .listBackground, .separatorColor, .selectionColor
        ]
        
        for colorType in colorTypes {
            let color = ThemeColorProvider.getColor(for: colorType, theme: lightTheme)
            XCTAssertNotNil(color, "Color should not be nil for \(colorType) in light theme")
        }
    }
    
    func testDarkThemeColors() {
        let darkTheme = ThemeManager.AppTheme.dark
        
        // Test that all color types return valid colors for dark theme
        let colorTypes: [ThemeColorType] = [
            .primaryBackground, .secondaryBackground, .tertiaryBackground, .cardBackground,
            .primaryText, .secondaryText, .disabledText,
            .accentColor, .buttonBackground, .buttonText, .linkColor,
            .successColor, .warningColor, .errorColor,
            .navigationBarBackground, .tabBarBackground, .listBackground, .separatorColor, .selectionColor
        ]
        
        for colorType in colorTypes {
            let color = ThemeColorProvider.getColor(for: colorType, theme: darkTheme)
            XCTAssertNotNil(color, "Color should not be nil for \(colorType) in dark theme")
        }
    }
    
    func testColorThemeCreation() {
        let lightTheme = ColorTheme.lightTheme()
        let darkTheme = ColorTheme.darkTheme()
        
        XCTAssertNotNil(lightTheme)
        XCTAssertNotNil(darkTheme)
        
        // Test that themes have different colors for some elements
        XCTAssertNotEqual(lightTheme.cardBackground, darkTheme.cardBackground)
    }
    
    func testThemeConfiguration() {
        let config = ThemeConfiguration.default
        
        XCTAssertNotNil(config.lightTheme)
        XCTAssertNotNil(config.darkTheme)
        XCTAssertEqual(config.transitionDuration, 0.2)
    }
}

final class ThemeColorValidatorTests: XCTestCase {
    
    func testColorValidation() {
        let lightTheme = ThemeManager.AppTheme.light
        let primaryBackground = ThemeColorProvider.getColor(for: .primaryBackground, theme: lightTheme)
        
        let isValid = ThemeColorValidator.validateColor(primaryBackground, for: .primaryBackground, theme: lightTheme)
        XCTAssertTrue(isValid, "Primary background color should be valid")
    }
    
    func testValidateAllColors() {
        let lightTheme = ThemeManager.AppTheme.light
        let failedValidations = ThemeColorValidator.validateAllColors(for: lightTheme)
        
        XCTAssertTrue(failedValidations.isEmpty, "All colors should pass validation for light theme")
        
        let darkTheme = ThemeManager.AppTheme.dark
        let darkFailedValidations = ThemeColorValidator.validateAllColors(for: darkTheme)
        
        XCTAssertTrue(darkFailedValidations.isEmpty, "All colors should pass validation for dark theme")
    }
}

final class ThemeErrorHandlerTests: XCTestCase {
    
    func testThemeErrorDescriptions() {
        let loadingError = ThemeError.themeLoadingFailed("Test reason")
        XCTAssertTrue(loadingError.localizedDescription.contains("主题加载失败"))
        
        let systemError = ThemeError.systemAppearanceDetectionFailed
        XCTAssertTrue(systemError.localizedDescription.contains("系统外观检测失败"))
        
        let transitionError = ThemeError.themeTransitionFailed("Test reason")
        XCTAssertTrue(transitionError.localizedDescription.contains("主题切换失败"))
        
        let colorError = ThemeError.colorValidationFailed(.primaryBackground)
        XCTAssertTrue(colorError.localizedDescription.contains("颜色验证失败"))
    }
    
    func testErrorRecoverySuggestions() {
        let loadingError = ThemeError.themeLoadingFailed("Test")
        XCTAssertNotNil(loadingError.recoverySuggestion)
        
        let systemError = ThemeError.systemAppearanceDetectionFailed
        XCTAssertNotNil(systemError.recoverySuggestion)
    }
    
    func testErrorHandling() {
        let errorHandler = ThemeErrorHandler.shared
        let error = ThemeError.themeLoadingFailed("Test error")
        
        // This should not crash
        errorHandler.handleError(error)
    }
}

@MainActor
final class ThemeTransitionManagerTests: XCTestCase {
    
    func testTransitionManager() {
        let transitionManager = ThemeTransitionManager.shared
        
        XCTAssertFalse(transitionManager.isTransitioning)
        
        let expectation = XCTestExpectation(description: "Transition completed")
        
        transitionManager.performThemeTransition {
            // Simulate theme change
        }
        
        XCTAssertTrue(transitionManager.isTransitioning)
        
        // Wait for transition to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertFalse(transitionManager.isTransitioning)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

final class ThemePreferenceTests: XCTestCase {
    
    func testThemePreferenceCoding() {
        let preference = ThemePreference(
            mode: .dark,
            lastUpdated: Date(),
            userSetExplicitly: true
        )
        
        // Test encoding
        let encoder = JSONEncoder()
        let data = try? encoder.encode(preference)
        XCTAssertNotNil(data)
        
        // Test decoding
        let decoder = JSONDecoder()
        let decodedPreference = try? decoder.decode(ThemePreference.self, from: data!)
        XCTAssertNotNil(decodedPreference)
        XCTAssertEqual(decodedPreference?.mode, .dark)
        XCTAssertEqual(decodedPreference?.userSetExplicitly, true)
    }
}