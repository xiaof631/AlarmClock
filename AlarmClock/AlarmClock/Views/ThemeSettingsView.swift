//
//  ThemeSettingsView.swift
//  AlarmClock
//
//  Created by Kiro on 27/7/25.
//

import SwiftUI

struct ThemeSettingsView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ThemeAwareView { theme in
            NavigationView {
                List {
                    Section(header: Text("主题设置").foregroundColor(theme.secondaryText)) {
                        ForEach(ThemeManager.AppTheme.allCases, id: \.self) { themeOption in
                            ThemeOptionRow(
                                theme: theme,
                                themeOption: themeOption,
                                isSelected: themeManager.themeMode == themeOption
                            ) {
                                themeManager.setTheme(themeOption)
                            }
                        }
                    }
                    
                    Section(header: Text("当前状态").foregroundColor(theme.secondaryText)) {
                        HStack {
                            Text("当前主题")
                                .foregroundColor(theme.primaryText)
                            Spacer()
                            Text(themeManager.currentTheme.displayName)
                                .foregroundColor(theme.secondaryText)
                        }
                    }
                }
                .background(theme.primaryBackground)
                .navigationTitle("主题")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("完成") {
                            dismiss()
                        }
                        .foregroundColor(theme.accentColor)
                    }
                }
            }
        }
    }
}

struct ThemeOptionRow: View {
    let theme: ColorTheme
    let themeOption: ThemeManager.AppTheme
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(themeOption.displayName)
                        .foregroundColor(theme.primaryText)
                        .font(.body)
                    
                    Text(themeOption.description)
                        .foregroundColor(theme.secondaryText)
                        .font(.caption)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(theme.accentColor)
                        .font(.body.weight(.semibold))
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Theme Extensions

extension ThemeManager.AppTheme {
    var displayName: String {
        switch self {
        case .light:
            return "浅色"
        case .dark:
            return "深色"
        case .auto:
            return "跟随系统"
        }
    }
    
    var description: String {
        switch self {
        case .light:
            return "始终使用浅色主题"
        case .dark:
            return "始终使用深色主题"
        case .auto:
            return "根据系统设置自动切换"
        }
    }
}

#Preview {
    ThemeSettingsView()
        .environmentObject(ThemeManager())
}