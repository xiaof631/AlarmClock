//
//  ThemeDebugView.swift
//  AlarmClock
//
//  Created by Kiro on 27/7/25.
//

import SwiftUI

#if DEBUG
struct ThemeDebugView: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var performanceMonitor = ThemePerformanceMonitor.shared
    @StateObject private var healthMonitor = ThemeHealthMonitor.shared
    @State private var integrityReport: ThemeIntegrityReport?
    @State private var showingIntegrityReport = false
    
    var body: some View {
        NavigationView {
            List {
                Section("当前状态") {
                    StatusRow(title: "主题模式", value: themeManager.themeMode.displayName)
                    StatusRow(title: "当前主题", value: themeManager.currentTheme == .light ? "浅色" : "深色")
                    StatusRow(title: "健康状态", value: healthMonitor.isHealthy ? "正常" : "异常")
                        .foregroundColor(healthMonitor.isHealthy ? .green : .red)
                }
                
                Section("性能指标") {
                    StatusRow(title: "平均切换时间", value: String(format: "%.1fms", performanceMonitor.averageTransitionTime * 1000))
                    StatusRow(title: "最后切换时间", value: String(format: "%.1fms", performanceMonitor.lastTransitionTime * 1000))
                    StatusRow(title: "切换次数", value: "\(performanceMonitor.transitionCount)")
                    StatusRow(title: "性能目标", value: performanceMonitor.averageTransitionTime <= 0.2 ? "达标" : "未达标")
                        .foregroundColor(performanceMonitor.averageTransitionTime <= 0.2 ? .green : .red)
                }
                
                Section("缓存信息") {
                    StatusRow(title: "颜色缓存大小", value: "\(LazyColorCache.shared.getCacheSize())")
                    
                    Button("清理缓存") {
                        LazyColorCache.shared.clearCache()
                    }
                    .foregroundColor(.blue)
                }
                
                Section("测试工具") {
                    Button("运行完整性检查") {
                        runIntegrityCheck()
                    }
                    .foregroundColor(.blue)
                    
                    Button("性能压力测试") {
                        performStressTest()
                    }
                    .foregroundColor(.orange)
                    
                    Button("切换到浅色") {
                        themeManager.setTheme(.light)
                    }
                    .disabled(themeManager.themeMode == .light)
                    
                    Button("切换到深色") {
                        themeManager.setTheme(.dark)
                    }
                    .disabled(themeManager.themeMode == .dark)
                    
                    Button("切换到自动") {
                        themeManager.setTheme(.auto)
                    }
                    .disabled(themeManager.themeMode == .auto)
                    
                    Button("重置性能统计") {
                        performanceMonitor.resetStats()
                    }
                    .foregroundColor(.red)
                }
                
                Section("颜色预览") {
                    ColorPreviewGrid()
                }
            }
            .navigationTitle("主题调试")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingIntegrityReport) {
                IntegrityReportView(report: integrityReport)
            }
        }
    }
    
    private func runIntegrityCheck() {
        integrityReport = ThemeIntegrityChecker.shared.performFullIntegrityCheck()
        showingIntegrityReport = true
    }
    
    private func performStressTest() {
        Task {
            for i in 0..<20 {
                await MainActor.run {
                themeManager.setTheme(i % 2 == 0 ? .light : .dark)
            }
                try? await Task.sleep(nanoseconds: 50_000_000) // 50ms
            }
            
            await MainActor.run {
                themeManager.setTheme(.auto)
            }
        }
    }
}

struct StatusRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

struct ColorPreviewGrid: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    let colorTypes: [ThemeColorType] = [
        .primaryBackground, .secondaryBackground, .cardBackground,
        .primaryText, .secondaryText, .accentColor,
        .buttonBackground, .successColor, .warningColor, .errorColor
    ]
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
            ForEach(colorTypes, id: \.self) { colorType in
                ColorPreviewCard(colorType: colorType)
            }
        }
    }
}

struct ColorPreviewCard: View {
    let colorType: ThemeColorType
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 4) {
            Rectangle()
                .fill(ThemeColorProvider.getColor(for: colorType, theme: themeManager.currentTheme))
                .frame(height: 40)
                .cornerRadius(8)
            
            Text(colorTypeName)
                .font(.caption2)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
    }
    
    private var colorTypeName: String {
        switch colorType {
        case .primaryBackground: return "主背景"
        case .secondaryBackground: return "次背景"
        case .cardBackground: return "卡片背景"
        case .primaryText: return "主文本"
        case .secondaryText: return "次文本"
        case .accentColor: return "强调色"
        case .buttonBackground: return "按钮背景"
        case .successColor: return "成功色"
        case .warningColor: return "警告色"
        case .errorColor: return "错误色"
        default: return "\(colorType)"
        }
    }
}

struct IntegrityReportView: View {
    let report: ThemeIntegrityReport?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let report = report {
                        Text(report.summary)
                            .font(.system(.body, design: .monospaced))
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        
                        if !report.colorValidation.failedValidations.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("颜色验证失败:")
                                    .font(.headline)
                                    .foregroundColor(.red)
                                
                                ForEach(report.colorValidation.failedValidations, id: \.self) { failure in
                                    Text("• \(failure)")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            }
                            .padding()
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        if !report.accessibilityValidation.contrastFailures.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("无障碍对比度失败:")
                                    .font(.headline)
                                    .foregroundColor(.orange)
                                
                                ForEach(report.accessibilityValidation.contrastFailures, id: \.self) { failure in
                                    Text("• \(failure)")
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                }
                            }
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                        }
                    } else {
                        Text("无报告数据")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
            }
            .navigationTitle("完整性报告")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("关闭") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ThemeDebugViewPreview()
}

struct ThemeDebugViewPreview: View {
    @StateObject private var themeManager = ThemeManager.shared
    
    var body: some View {
        ThemeDebugView()
            .environmentObject(themeManager)
    }
}
#endif