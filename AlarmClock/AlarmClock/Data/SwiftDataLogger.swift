//
//  SwiftDataLogger.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import Foundation
import SwiftData
import SwiftUI

// MARK: - 数据操作日志系统
@Observable
final class SwiftDataLogger {
    static let shared = SwiftDataLogger()
    
    private var logs: [DataOperationLog] = []
    private var performanceMetrics: [PerformanceMetric] = []
    private let maxLogCount = 1000
    private let maxMetricCount = 500
    
    private init() {}
    
    // MARK: - 日志记录方法
    
    /// 记录数据操作日志
    func logOperation(
        type: DataOperationType,
        entity: String,
        operation: String,
        details: [String: Any] = [:],
        duration: TimeInterval? = nil,
        success: Bool = true,
        error: Error? = nil
    ) {
        let log = DataOperationLog(
            type: type,
            entity: entity,
            operation: operation,
            details: details,
            duration: duration,
            success: success,
            error: error?.localizedDescription
        )
        
        addLog(log)
        
        // 如果有性能数据，也记录性能指标
        if let duration = duration {
            recordPerformanceMetric(
                operation: "\(entity).\(operation)",
                duration: duration,
                success: success
            )
        }
    }
    
    /// 记录查询操作
    func logQuery(
        entity: String,
        predicate: String? = nil,
        sortDescriptors: [String] = [],
        fetchLimit: Int? = nil,
        resultCount: Int,
        duration: TimeInterval,
        cacheHit: Bool = false
    ) {
        var details: [String: Any] = [
            "resultCount": resultCount,
            "cacheHit": cacheHit
        ]
        
        if let predicate = predicate {
            details["predicate"] = predicate
        }
        
        if !sortDescriptors.isEmpty {
            details["sortDescriptors"] = sortDescriptors
        }
        
        if let fetchLimit = fetchLimit {
            details["fetchLimit"] = fetchLimit
        }
        
        logOperation(
            type: .fetch,
            entity: entity,
            operation: "query",
            details: details,
            duration: duration,
            success: true
        )
    }
    
    /// 记录批量操作
    func logBatchOperation(
        type: DataOperationType,
        entity: String,
        count: Int,
        duration: TimeInterval,
        success: Bool,
        error: Error? = nil
    ) {
        logOperation(
            type: type,
            entity: entity,
            operation: "batch",
            details: ["count": count],
            duration: duration,
            success: success,
            error: error
        )
    }
    
    /// 记录迁移操作
    func logMigration(
        fromVersion: String,
        toVersion: String,
        recordCount: Int,
        duration: TimeInterval,
        success: Bool,
        error: Error? = nil
    ) {
        logOperation(
            type: .migration,
            entity: "Migration",
            operation: "migrate",
            details: [
                "fromVersion": fromVersion,
                "toVersion": toVersion,
                "recordCount": recordCount
            ],
            duration: duration,
            success: success,
            error: error
        )
    }
    
    // MARK: - 性能指标记录
    
    private func recordPerformanceMetric(
        operation: String,
        duration: TimeInterval,
        success: Bool
    ) {
        let metric = PerformanceMetric(
            operation: operation,
            duration: duration,
            success: success
        )
        
        addPerformanceMetric(metric)
    }
    
    private func addLog(_ log: DataOperationLog) {
        logs.append(log)
        
        // 保持日志数量在限制内
        if logs.count > maxLogCount {
            logs.removeFirst(logs.count - maxLogCount)
        }
    }
    
    private func addPerformanceMetric(_ metric: PerformanceMetric) {
        performanceMetrics.append(metric)
        
        // 保持指标数量在限制内
        if performanceMetrics.count > maxMetricCount {
            performanceMetrics.removeFirst(performanceMetrics.count - maxMetricCount)
        }
    }
    
    // MARK: - 查询和统计方法
    
    /// 获取最近的日志
    func getRecentLogs(limit: Int = 50) -> [DataOperationLog] {
        return Array(logs.suffix(limit).reversed())
    }
    
    /// 获取特定类型的日志
    func getLogs(ofType type: DataOperationType, limit: Int = 50) -> [DataOperationLog] {
        return logs.filter { $0.type == type }.suffix(limit).reversed()
    }
    
    /// 获取错误日志
    func getErrorLogs(limit: Int = 50) -> [DataOperationLog] {
        return logs.filter { !$0.success }.suffix(limit).reversed()
    }
    
    /// 获取性能统计
    func getPerformanceStats() -> PerformanceStats {
        let recentMetrics = performanceMetrics.suffix(100)
        
        guard !recentMetrics.isEmpty else {
            return PerformanceStats()
        }
        
        let durations = recentMetrics.map { $0.duration }
        let successCount = recentMetrics.filter { $0.success }.count
        
        return PerformanceStats(
            totalOperations: recentMetrics.count,
            successRate: Double(successCount) / Double(recentMetrics.count),
            averageDuration: durations.reduce(0, +) / Double(durations.count),
            minDuration: durations.min() ?? 0,
            maxDuration: durations.max() ?? 0,
            operationBreakdown: getOperationBreakdown(from: Array(recentMetrics))
        )
    }
    
    private func getOperationBreakdown(from metrics: [PerformanceMetric]) -> [String: OperationStats] {
        let grouped = Dictionary(grouping: metrics) { $0.operation }
        
        return grouped.mapValues { operationMetrics in
            let durations = operationMetrics.map { $0.duration }
            let successCount = operationMetrics.filter { $0.success }.count
            
            return OperationStats(
                count: operationMetrics.count,
                successRate: Double(successCount) / Double(operationMetrics.count),
                averageDuration: durations.reduce(0, +) / Double(durations.count),
                minDuration: durations.min() ?? 0,
                maxDuration: durations.max() ?? 0
            )
        }
    }
    
    /// 清理旧日志
    func cleanupOldLogs(olderThan date: Date = Date().addingTimeInterval(-7 * 24 * 60 * 60)) {
        logs.removeAll { $0.timestamp < date }
        performanceMetrics.removeAll { $0.timestamp < date }
    }
    
    /// 导出日志为JSON
    func exportLogs() -> String? {
        let exportData = LogExportData(
            logs: getRecentLogs(limit: 200),
            performanceStats: getPerformanceStats(),
            exportDate: Date()
        )
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let data = try encoder.encode(exportData)
            return String(data: data, encoding: .utf8)
        } catch {
            print("导出日志失败: \(error)")
            return nil
        }
    }
}

// MARK: - 数据操作日志模型
struct DataOperationLog: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    let type: DataOperationType
    let entity: String
    let operation: String
    let details: [String: String] // 简化为String类型以支持Codable
    let duration: TimeInterval?
    let success: Bool
    let error: String?
    
    init(
        type: DataOperationType,
        entity: String,
        operation: String,
        details: [String: Any] = [:],
        duration: TimeInterval? = nil,
        success: Bool = true,
        error: String? = nil
    ) {
        self.timestamp = Date()
        self.type = type
        self.entity = entity
        self.operation = operation
        self.details = details.mapValues { "\($0)" } // 转换为String
        self.duration = duration
        self.success = success
        self.error = error
    }
    
    var formattedTimestamp: String {
        DateFormatter.logFormatter.string(from: timestamp)
    }
    
    var formattedDuration: String {
        guard let duration = duration else { return "N/A" }
        return String(format: "%.3fs", duration)
    }
    
    var statusIcon: String {
        success ? "✅" : "❌"
    }
    
    var typeIcon: String {
        switch type {
        case .batchInsert: return "📥"
        case .batchUpdate: return "✏️"
        case .batchDelete: return "🗑️"
        case .migration: return "🔄"
        case .cacheRefresh: return "🔄"
        case .memoryOptimization: return "🧹"
        case .fetch: return "🔍"
        case .insert: return "➕"
        case .update: return "✏️"
        case .delete: return "➖"
        }
    }
}

// MARK: - 扩展DataOperationType
extension DataOperationType {
    case fetch
    case insert
    case update
    case delete
}

// MARK: - 性能指标模型
struct PerformanceMetric: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    let operation: String
    let duration: TimeInterval
    let success: Bool
    
    init(operation: String, duration: TimeInterval, success: Bool) {
        self.timestamp = Date()
        self.operation = operation
        self.duration = duration
        self.success = success
    }
}

// MARK: - 性能统计模型
struct PerformanceStats: Codable {
    let totalOperations: Int
    let successRate: Double
    let averageDuration: TimeInterval
    let minDuration: TimeInterval
    let maxDuration: TimeInterval
    let operationBreakdown: [String: OperationStats]
    
    init() {
        self.totalOperations = 0
        self.successRate = 0
        self.averageDuration = 0
        self.minDuration = 0
        self.maxDuration = 0
        self.operationBreakdown = [:]
    }
    
    init(
        totalOperations: Int,
        successRate: Double,
        averageDuration: TimeInterval,
        minDuration: TimeInterval,
        maxDuration: TimeInterval,
        operationBreakdown: [String: OperationStats]
    ) {
        self.totalOperations = totalOperations
        self.successRate = successRate
        self.averageDuration = averageDuration
        self.minDuration = minDuration
        self.maxDuration = maxDuration
        self.operationBreakdown = operationBreakdown
    }
    
    var formattedSuccessRate: String {
        String(format: "%.1f%%", successRate * 100)
    }
    
    var formattedAverageDuration: String {
        String(format: "%.3fs", averageDuration)
    }
}

struct OperationStats: Codable {
    let count: Int
    let successRate: Double
    let averageDuration: TimeInterval
    let minDuration: TimeInterval
    let maxDuration: TimeInterval
    
    var formattedSuccessRate: String {
        String(format: "%.1f%%", successRate * 100)
    }
    
    var formattedAverageDuration: String {
        String(format: "%.3fs", averageDuration)
    }
}

// MARK: - 日志导出数据模型
struct LogExportData: Codable {
    let logs: [DataOperationLog]
    let performanceStats: PerformanceStats
    let exportDate: Date
}

// MARK: - 调试工具类
final class SwiftDataDebugTools {
    static let shared = SwiftDataDebugTools()
    
    private init() {}
    
    /// 检查数据库状态
    func checkDatabaseHealth(context: ModelContext) async -> DatabaseHealthReport {
        let startTime = Date()
        var issues: [String] = []
        var stats: [String: Int] = [:]
        
        do {
            // 检查各个实体的记录数
            let alarmCount = try context.fetchCount(FetchDescriptor<Alarm>())
            let repeatCount = try context.fetchCount(FetchDescriptor<AlarmRepeat>())
            let templateCount = try context.fetchCount(FetchDescriptor<AlarmTemplate>())
            
            stats["Alarm"] = alarmCount
            stats["AlarmRepeat"] = repeatCount
            stats["AlarmTemplate"] = templateCount
            
            // 检查孤立记录
            let orphanedRepeats = try context.fetch(FetchDescriptor<AlarmRepeat>()).filter { $0.alarm == nil }
            if !orphanedRepeats.isEmpty {
                issues.append("发现 \(orphanedRepeats.count) 个孤立的AlarmRepeat记录")
            }
            
            // 检查无效引用
            let alarmsWithInvalidTemplates = try context.fetch(FetchDescriptor<Alarm>()).filter { alarm in
                if let template = alarm.template {
                    let templateExists = (try? context.fetchCount(FetchDescriptor<AlarmTemplate>(
                        predicate: #Predicate { $0.id == template.id }
                    ))) ?? 0 > 0
                    return !templateExists
                }
                return false
            }
            
            if !alarmsWithInvalidTemplates.isEmpty {
                issues.append("发现 \(alarmsWithInvalidTemplates.count) 个闹钟引用了不存在的模板")
            }
            
        } catch {
            issues.append("数据库健康检查失败: \(error.localizedDescription)")
        }
        
        let duration = Date().timeIntervalSince(startTime)
        
        return DatabaseHealthReport(
            checkDate: Date(),
            duration: duration,
            entityCounts: stats,
            issues: issues,
            isHealthy: issues.isEmpty
        )
    }
    
    /// 生成数据库报告
    func generateDatabaseReport(context: ModelContext) async -> String {
        let healthReport = await checkDatabaseHealth(context: context)
        let performanceStats = SwiftDataLogger.shared.getPerformanceStats()
        
        var report = """
        # SwiftData数据库报告
        
        生成时间: \(DateFormatter.logFormatter.string(from: Date()))
        
        ## 数据库健康状况
        状态: \(healthReport.isHealthy ? "✅ 健康" : "⚠️ 存在问题")
        检查耗时: \(String(format: "%.3fs", healthReport.duration))
        
        ### 实体统计
        """
        
        for (entity, count) in healthReport.entityCounts.sorted(by: { $0.key < $1.key }) {
            report += "\n- \(entity): \(count) 条记录"
        }
        
        if !healthReport.issues.isEmpty {
            report += "\n\n### 发现的问题"
            for issue in healthReport.issues {
                report += "\n- ⚠️ \(issue)"
            }
        }
        
        report += """
        
        ## 性能统计
        总操作数: \(performanceStats.totalOperations)
        成功率: \(performanceStats.formattedSuccessRate)
        平均耗时: \(performanceStats.formattedAverageDuration)
        最快操作: \(String(format: "%.3fs", performanceStats.minDuration))
        最慢操作: \(String(format: "%.3fs", performanceStats.maxDuration))
        
        ### 操作分解
        """
        
        for (operation, stats) in performanceStats.operationBreakdown.sorted(by: { $0.key < $1.key }) {
            report += """
            
            **\(operation)**
            - 次数: \(stats.count)
            - 成功率: \(stats.formattedSuccessRate)
            - 平均耗时: \(stats.formattedAverageDuration)
            """
        }
        
        return report
    }
}

// MARK: - 数据库健康报告模型
struct DatabaseHealthReport {
    let checkDate: Date
    let duration: TimeInterval
    let entityCounts: [String: Int]
    let issues: [String]
    let isHealthy: Bool
}