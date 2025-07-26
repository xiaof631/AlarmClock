//
//  PerformanceMonitorView.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import SwiftUI
import SwiftData

struct PerformanceMonitorView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var alarmManager: SwiftDataAlarmManager?
    @State private var memoryStats: MemoryUsageStats?
    @State private var refreshTimer: Timer?
    
    var body: some View {
        NavigationView {
            List {
                if let stats = memoryStats {
                    Section("内存使用情况") {
                        MemoryUsageRow(title: "已使用内存", value: stats.formattedUsedMemory)
                        MemoryUsageRow(title: "总物理内存", value: stats.formattedTotalMemory)
                        MemoryUsageRow(title: "内存使用率", value: String(format: "%.1f%%", stats.memoryUsagePercentage))
                        MemoryUsageRow(title: "缓存项数", value: "\(stats.cacheSize)")
                        MemoryUsageRow(title: "批量队列", value: "\(stats.batchQueueSize)")
                    }
                }
                
                if let manager = alarmManager {
                    Section("数据操作状态") {
                        if manager.operationTracker.isAnyOperationInProgress {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("正在进行的操作")
                                    .font(.headline)
                                
                                ForEach(manager.operationTracker.currentOperations) { operation in
                                    OperationProgressView(operation: operation)
                                }
                                
                                ProgressView(value: manager.operationTracker.totalProgress)
                                    .progressViewStyle(LinearProgressViewStyle())
                            }
                            .padding(.vertical, 4)
                        } else {
                            Text("无正在进行的操作")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Section("最近完成的操作") {
                        ForEach(manager.operationTracker.completedOperations.suffix(5).reversed(), id: \.id) { operation in
                            CompletedOperationView(operation: operation)
                        }
                    }
                }
                
                Section("性能优化操作") {
                    Button("优化内存使用") {
                        alarmManager?.optimizeMemoryUsage()
                        refreshStats()
                    }
                    .foregroundColor(.blue)
                    
                    Button("清理缓存") {
                        // 通过重新创建manager来清理缓存
                        let container = modelContext.container
                        alarmManager = SwiftDataAlarmManager(modelContext: modelContext, container: container)
                        refreshStats()
                    }
                    .foregroundColor(.orange)
                }
                
                Section("批量操作示例") {
                    Button("批量禁用所有闹钟") {
                        Task {
                            let predicate = #Predicate<Alarm> { $0.isEnabled == true }
                            try? await alarmManager?.batchToggleAlarms(enabled: false, matching: predicate)
                        }
                    }
                    .foregroundColor(.red)
                    
                    Button("批量启用所有闹钟") {
                        Task {
                            let predicate = #Predicate<Alarm> { $0.isEnabled == false }
                            try? await alarmManager?.batchToggleAlarms(enabled: true, matching: predicate)
                        }
                    }
                    .foregroundColor(.green)
                }
            }
            .navigationTitle("性能监控")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                setupAlarmManager()
                startRefreshTimer()
            }
            .onDisappear {
                stopRefreshTimer()
            }
        }
    }
    
    private func setupAlarmManager() {
        let container = modelContext.container
        alarmManager = SwiftDataAlarmManager(modelContext: modelContext, container: container)
        refreshStats()
    }
    
    private func refreshStats() {
        memoryStats = alarmManager?.performanceStats
    }
    
    private func startRefreshTimer() {
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            refreshStats()
        }
    }
    
    private func stopRefreshTimer() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
}

struct MemoryUsageRow: View {
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

struct OperationProgressView: View {
    let operation: DataOperation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(operation.description)
                    .font(.subheadline)
                Spacer()
                Text(String(format: "%.0f%%", operation.progress * 100))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: operation.progress)
                .progressViewStyle(LinearProgressViewStyle())
                .scaleEffect(y: 0.5)
        }
    }
}

struct CompletedOperationView: View {
    let operation: DataOperation
    
    var body: some View {
        HStack {
            Image(systemName: operation.isSuccessful ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(operation.isSuccessful ? .green : .red)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(operation.description)
                    .font(.subheadline)
                
                if let completedAt = operation.completedAt {
                    Text(completedAt, style: .time)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let error = operation.error {
                    Text(error.localizedDescription)
                        .font(.caption)
                        .foregroundColor(.red)
                        .lineLimit(2)
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    PerformanceMonitorViewPreview()
}

struct PerformanceMonitorViewPreview: View {
    var body: some View {
        if let container = try? ModelContainer(for: Alarm.self, AlarmRepeat.self, AlarmTemplate.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)) {
            PerformanceMonitorView()
                .modelContainer(container)
        } else {
            Text("Preview Error: Failed to create container")
        }
    }
}