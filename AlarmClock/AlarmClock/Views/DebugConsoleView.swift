//
//  DebugConsoleView.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import SwiftUI
import SwiftData

struct DebugConsoleView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    @State private var logs: [DataOperationLog] = []
    @State private var performanceStats: PerformanceStats = PerformanceStats()
    @State private var databaseReport: String = ""
    @State private var isGeneratingReport = false
    @State private var showingExportSheet = false
    @State private var exportedLogs: String = ""
    
    private let logger = SwiftDataLogger.shared
    private let debugTools = SwiftDataDebugTools.shared
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                // 操作日志标签页
                LogsTabView(logs: logs)
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle")
                        Text("操作日志")
                    }
                    .tag(0)
                
                // 性能统计标签页
                PerformanceTabView(stats: performanceStats)
                    .tabItem {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Text("性能统计")
                    }
                    .tag(1)
                
                // 数据库健康标签页
                DatabaseHealthTabView(
                    report: databaseReport,
                    isGenerating: isGeneratingReport,
                    onGenerateReport: generateDatabaseReport
                )
                .tabItem {
                    Image(systemName: "heart.text.square")
                    Text("数据库健康")
                }
                .tag(2)
                
                // 调试工具标签页
                DebugToolsTabView(
                    onExportLogs: exportLogs,
                    onClearLogs: clearLogs,
                    onRunIntegrityCheck: runIntegrityCheck
                )
                .tabItem {
                    Image(systemName: "wrench.and.screwdriver")
                    Text("调试工具")
                }
                .tag(3)
            }
            .navigationTitle("调试控制台")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                refreshData()
            }
            .refreshable {
                refreshData()
            }
            .sheet(isPresented: $showingExportSheet) {
                NavigationView {
                    ScrollView {
                        Text(exportedLogs)
                            .font(.system(.caption, design: .monospaced))
                            .padding()
                    }
                    .navigationTitle("导出的日志")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("完成") {
                                showingExportSheet = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func refreshData() {
        logs = logger.getRecentLogs(limit: 100)
        performanceStats = logger.getPerformanceStats()
    }
    
    private func generateDatabaseReport() {
        isGeneratingReport = true
        Task {
            let report = await debugTools.generateDatabaseReport(context: modelContext)
            await MainActor.run {
                databaseReport = report
                isGeneratingReport = false
            }
        }
    }
    
    private func exportLogs() {
        if let exported = logger.exportLogs() {
            exportedLogs = exported
            showingExportSheet = true
        }
    }
    
    private func clearLogs() {
        logger.cleanupOldLogs(olderThan: Date())
        refreshData()
    }
    
    private func runIntegrityCheck() {
        Task {
            let healthReport = await debugTools.checkDatabaseHealth(context: modelContext)
            await MainActor.run {
                // 可以显示健康检查结果的弹窗
                print("数据库健康检查完成: \(healthReport.isHealthy ? "健康" : "存在问题")")
            }
        }
    }
}

// MARK: - 操作日志标签页
struct LogsTabView: View {
    let logs: [DataOperationLog]
    @State private var selectedLogType: DataOperationType? = nil
    @State private var showingErrorsOnly = false
    
    var filteredLogs: [DataOperationLog] {
        var filtered = logs
        
        if let selectedType = selectedLogType {
            filtered = filtered.filter { $0.type == selectedType }
        }
        
        if showingErrorsOnly {
            filtered = filtered.filter { !$0.success }
        }
        
        return filtered
    }
    
    var body: some View {
        VStack {
            // 过滤器
            HStack {
                Picker("类型", selection: $selectedLogType) {
                    Text("全部").tag(DataOperationType?.none)
                    ForEach([DataOperationType.insert, .update, .delete, .fetch, .batchInsert, .batchUpdate, .batchDelete], id: \.self) { type in
                        Text(type.description).tag(type as DataOperationType?)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Spacer()
                
                Toggle("仅错误", isOn: $showingErrorsOnly)
                    .toggleStyle(SwitchToggleStyle())
            }
            .padding(.horizontal)
            
            // 日志列表
            List(filteredLogs) { log in
                LogRowView(log: log)
            }
        }
    }
}

// MARK: - 日志行视图
struct LogRowView: View {
    let log: DataOperationLog
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(log.typeIcon)
                Text(log.statusIcon)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(log.entity).\(log.operation)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(log.formattedTimestamp)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if let duration = log.duration {
                    Text(log.formattedDuration)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 4) {
                    if !log.details.isEmpty {
                        Text("详细信息:")
                            .font(.caption)
                            .fontWeight(.semibold)
                        
                        ForEach(log.details.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                            Text("• \(key): \(value)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if let error = log.error {
                        Text("错误:")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.red)
                        
                        Text(error)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 2)
    }
}

// MARK: - 性能统计标签页
struct PerformanceTabView: View {
    let stats: PerformanceStats
    
    var body: some View {
        List {
            Section("总体统计") {
                StatRow(title: "总操作数", value: "\(stats.totalOperations)")
                StatRow(title: "成功率", value: stats.formattedSuccessRate)
                StatRow(title: "平均耗时", value: stats.formattedAverageDuration)
                StatRow(title: "最快操作", value: String(format: "%.3fs", stats.minDuration))
                StatRow(title: "最慢操作", value: String(format: "%.3fs", stats.maxDuration))
            }
            
            if !stats.operationBreakdown.isEmpty {
                Section("操作分解") {
                    ForEach(stats.operationBreakdown.sorted(by: { $0.key < $1.key }), id: \.key) { operation, operationStats in
                        OperationStatsView(operation: operation, stats: operationStats)
                    }
                }
            }
        }
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
                .font(.system(.body, design: .monospaced))
        }
    }
}

struct OperationStatsView: View {
    let operation: String
    let stats: OperationStats
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(operation)
                    .fontWeight(.medium)
                Spacer()
                Text("\(stats.count) 次")
                    .foregroundColor(.secondary)
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 2) {
                    StatRow(title: "成功率", value: stats.formattedSuccessRate)
                    StatRow(title: "平均耗时", value: stats.formattedAverageDuration)
                    StatRow(title: "最快", value: String(format: "%.3fs", stats.minDuration))
                    StatRow(title: "最慢", value: String(format: "%.3fs", stats.maxDuration))
                }
                .padding(.top, 4)
            }
        }
    }
}

// MARK: - 数据库健康标签页
struct DatabaseHealthTabView: View {
    let report: String
    let isGenerating: Bool
    let onGenerateReport: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button("生成报告", action: onGenerateReport)
                    .disabled(isGenerating)
                
                Spacer()
                
                if isGenerating {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
            .padding()
            
            if !report.isEmpty {
                ScrollView {
                    Text(report)
                        .font(.system(.caption, design: .monospaced))
                        .padding()
                }
            } else {
                Spacer()
                Text("点击\"生成报告\"查看数据库健康状况")
                    .foregroundColor(.secondary)
                Spacer()
            }
        }
    }
}

// MARK: - 调试工具标签页
struct DebugToolsTabView: View {
    let onExportLogs: () -> Void
    let onClearLogs: () -> Void
    let onRunIntegrityCheck: () -> Void
    
    var body: some View {
        List {
            Section("日志管理") {
                Button("导出日志", action: onExportLogs)
                    .foregroundColor(.blue)
                
                Button("清理日志", action: onClearLogs)
                    .foregroundColor(.orange)
            }
            
            Section("数据完整性") {
                Button("运行完整性检查", action: onRunIntegrityCheck)
                    .foregroundColor(.green)
            }
            
            Section("系统信息") {
                StatRow(title: "iOS版本", value: UIDevice.current.systemVersion)
                StatRow(title: "设备型号", value: UIDevice.current.model)
                StatRow(title: "应用版本", value: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "未知")
            }
        }
    }
}

// MARK: - 扩展DataOperationType
extension DataOperationType {
    var description: String {
        switch self {
        case .insert: return "插入"
        case .update: return "更新"
        case .delete: return "删除"
        case .fetch: return "查询"
        case .batchInsert: return "批量插入"
        case .batchUpdate: return "批量更新"
        case .batchDelete: return "批量删除"
        case .migration: return "迁移"
        case .cacheRefresh: return "缓存刷新"
        case .memoryOptimization: return "内存优化"
        }
    }
}

#Preview {
    DebugConsoleViewPreview()
}

struct DebugConsoleViewPreview: View {
    var body: some View {
        if let container = try? ModelContainer(for: Alarm.self, AlarmRepeat.self, AlarmTemplate.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)) {
            DebugConsoleView()
                .modelContainer(container)
        } else {
            Text("Preview Error: Failed to create container")
        }
    }
}