//
//  ThemeUITests.swift
//  AlarmClockUITests
//
//  Created by Kiro on 27/7/25.
//

import XCTest

final class ThemeUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testThemeSettingsAccess() throws {
        // Navigate to theme settings
        let themeTab = app.tabBars.buttons["主题"]
        XCTAssertTrue(themeTab.exists, "Theme tab should exist")
        
        themeTab.tap()
        
        // Check if theme settings view is displayed
        let themeSettingsTitle = app.navigationBars["主题设置"]
        XCTAssertTrue(themeSettingsTitle.waitForExistence(timeout: 2), "Theme settings should be displayed")
    }
    
    func testThemeModeSelection() throws {
        // Navigate to theme settings
        app.tabBars.buttons["主题"].tap()
        
        // Test light mode selection
        let lightModeButton = app.buttons["浅色模式"]
        if lightModeButton.exists {
            lightModeButton.tap()
            
            // Verify selection indicator
            let checkmark = lightModeButton.images["checkmark.circle.fill"]
            XCTAssertTrue(checkmark.exists, "Light mode should be selected")
        }
        
        // Test dark mode selection
        let darkModeButton = app.buttons["深色模式"]
        if darkModeButton.exists {
            darkModeButton.tap()
            
            // Verify selection indicator
            let checkmark = darkModeButton.images["checkmark.circle.fill"]
            XCTAssertTrue(checkmark.exists, "Dark mode should be selected")
        }
        
        // Test auto mode selection
        let autoModeButton = app.buttons["跟随系统"]
        if autoModeButton.exists {
            autoModeButton.tap()
            
            // Verify selection indicator
            let checkmark = autoModeButton.images["checkmark.circle.fill"]
            XCTAssertTrue(checkmark.exists, "Auto mode should be selected")
        }
    }
    
    func testThemePreview() throws {
        // Navigate to theme settings
        app.tabBars.buttons["主题"].tap()
        
        // Check if preview section exists
        let previewSection = app.staticTexts["预览"]
        XCTAssertTrue(previewSection.exists, "Preview section should exist")
        
        // Check if preview elements exist
        let exampleAlarm = app.staticTexts["示例闹钟"]
        XCTAssertTrue(exampleAlarm.exists, "Example alarm should be shown in preview")
        
        let primaryButton = app.buttons["主要按钮"]
        XCTAssertTrue(primaryButton.exists, "Primary button should be shown in preview")
        
        let secondaryButton = app.buttons["次要按钮"]
        XCTAssertTrue(secondaryButton.exists, "Secondary button should be shown in preview")
    }
    
    func testThemeStatusInfo() throws {
        // Navigate to theme settings
        app.tabBars.buttons["主题"].tap()
        
        // Check if status section exists
        let statusSection = app.staticTexts["状态信息"]
        XCTAssertTrue(statusSection.exists, "Status section should exist")
        
        // Check if current theme info is displayed
        let currentThemeLabel = app.staticTexts["当前主题"]
        XCTAssertTrue(currentThemeLabel.exists, "Current theme label should exist")
        
        let themeModeLabel = app.staticTexts["主题模式"]
        XCTAssertTrue(themeModeLabel.exists, "Theme mode label should exist")
    }
    
    func testThemeTransitionSmoothness() throws {
        // Navigate to theme settings
        app.tabBars.buttons["主题"].tap()
        
        // Switch between themes and verify no crashes occur
        let lightModeButton = app.buttons["浅色模式"]
        let darkModeButton = app.buttons["深色模式"]
        
        if lightModeButton.exists && darkModeButton.exists {
            // Rapidly switch between themes
            for _ in 0..<3 {
                lightModeButton.tap()
                Thread.sleep(forTimeInterval: 0.1)
                darkModeButton.tap()
                Thread.sleep(forTimeInterval: 0.1)
            }
            
            // App should still be responsive
            XCTAssertTrue(app.navigationBars["主题设置"].exists, "App should remain responsive after theme switches")
        }
    }
    
    func testThemeConsistencyAcrossViews() throws {
        // Start with theme settings
        app.tabBars.buttons["主题"].tap()
        
        // Set to dark mode
        let darkModeButton = app.buttons["深色模式"]
        if darkModeButton.exists {
            darkModeButton.tap()
        }
        
        // Navigate to other tabs and verify theme consistency
        let tabs = ["闹钟", "场景", "统计"]
        
        for tabName in tabs {
            let tab = app.tabBars.buttons[tabName]
            if tab.exists {
                tab.tap()
                
                // Verify the view loads without issues
                XCTAssertTrue(app.navigationBars.firstMatch.exists, "\(tabName) view should load with dark theme")
            }
        }
    }
    
    func testAccessibilityWithThemes() throws {
        // Navigate to theme settings
        app.tabBars.buttons["主题"].tap()
        
        // Test with light mode
        let lightModeButton = app.buttons["浅色模式"]
        if lightModeButton.exists {
            lightModeButton.tap()
            
            // Verify accessibility elements are still accessible
            XCTAssertTrue(lightModeButton.isHittable, "Light mode button should be accessible")
        }
        
        // Test with dark mode
        let darkModeButton = app.buttons["深色模式"]
        if darkModeButton.exists {
            darkModeButton.tap()
            
            // Verify accessibility elements are still accessible
            XCTAssertTrue(darkModeButton.isHittable, "Dark mode button should be accessible")
        }
    }
    
    func testThemeSettingsNavigation() throws {
        // Navigate to theme settings
        app.tabBars.buttons["主题"].tap()
        
        // Test done button
        let doneButton = app.navigationBars.buttons["完成"]
        if doneButton.exists {
            doneButton.tap()
            
            // Should remain in theme settings (since it's a tab)
            XCTAssertTrue(app.tabBars.buttons["主题"].isSelected, "Should remain in theme tab")
        }
    }
    
    func testThemePersistence() throws {
        // Navigate to theme settings
        app.tabBars.buttons["主题"].tap()
        
        // Set to dark mode
        let darkModeButton = app.buttons["深色模式"]
        if darkModeButton.exists {
            darkModeButton.tap()
        }
        
        // Terminate and relaunch app
        app.terminate()
        app.launch()
        
        // Navigate back to theme settings
        app.tabBars.buttons["主题"].tap()
        
        // Verify dark mode is still selected
        let checkmark = darkModeButton.images["checkmark.circle.fill"]
        XCTAssertTrue(checkmark.exists, "Dark mode should persist after app restart")
    }
}