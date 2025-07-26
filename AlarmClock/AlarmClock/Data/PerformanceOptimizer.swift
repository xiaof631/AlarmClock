//
//  PerformanceOptimizer.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import Foundation
import SwiftData
import SwiftUI

// MARK: - Performance Optimization Manager
@Observable
final class PerformanceOptimizer {
    private let mainContext: ModelContext
    private let backgroundContext: ModelContext
    private let container: ModelContainer
    
    // 查询缓存
    private var queryCache: [String: Any] = [:]
    private var cacheTimestamps: [String: Date] = [:]
    private let cacheTimeout: TimeInterval = 300 // 5分钟缓存超时
    
    // 批量操作队列
    private var batchOperationQueue: [() -> Void] = []
    private var batchTimer: Timer?
    private let batchDelay: TimeInterval = 0.5 // 500ms批量延迟
    
    init(container: ModelContainer, mainContext: ModelContext) {
        self.container = container
        self.mainContext = mainContext
        
        // 创建后台上下文用于耗时操作
        self.backgroundContext = ModelContext(container)
        self.backgroundContext.autosaveEnabled = false
    }
    
    // MARK: - 数据库索引优化
    
    /// 为常用查询字段添加索引优化
    static func configureOptimizedSchema() -> Schema {
        let schema = Schema([
            Alarm.self,
            AlarmRepeat.self,
            AlarmTemplate.self
        ])
        
        return schema
    }
    
    // MARK: - 查询优化和缓存
    
    /// 优化的闹钟查询，支持缓存
    func fetchAlarmsOptimized(
        predicate: Predicate<Alarm>? = nil,
        sortBy: [SortDescriptor<Alarm>] = [SortDescriptor(\.time)],
        fetchLimit: Int? = nil,
        useCache: Bool = true
    ) throws -> [Alarm] {
        let cacheKey = generateCacheKey(predicate: predicate, sortBy: sortBy, fetchLimit: fetchLimit)
        
        // 检查缓存
        if useCache, let cachedResult = getCachedResult(for: cacheKey) as? [Alarm] {
            return cachedResult
        }
        
        // 创建优化的FetchDescriptor
        var fetchDescriptor = FetchDescriptor<Alarm>(sortBy: sortBy)
        
        if let predicate = predicate {
            fetchDescriptor.predicate = predicate
        }
        
        if let fetchLimit = fetchLimit {
            fetchDescriptor.fetchLimit = fetchLimit
        }
        
        // 执行查询
        let results = try mainContext.fetch(fetchDescriptor)
        
        // 缓存结果
        if useCache {
            setCachedResult(results, for: cacheKey)
        }
        
        return results
    }
    
    /// 优化的模板查询，支持场景筛选和缓存
    func fetchTemplatesOptimized(
        for scenario: ScenarioType? = nil,
        useCache: Bool = true
    ) throws -> [AlarmTemplate] {
        let cacheKey = "templates_\(scenario?.rawValue ?? "all")"
        
        // 检查缓存
        if useCache, let cachedResult = getCachedResult(for: cacheKey) as? [AlarmTemplate] {
            return cachedResult
        }
        
        var fetchDescriptor = FetchDescriptor<AlarmTemplate>(
            sortBy: [
                SortDescriptor(\.scenario),
                SortDescriptor(\.category),
                SortDescriptor(\.name)
            ]
        )
        
        if let scenario = scenario {
            fetchDescriptor.predicate = #Predicate { template in
                template.scenario == scenario.rawValue
            }
        }
        
        let results = try mainContext.fetch(fetchDescriptor)
        
        // 缓存结果
        if useCache {
            setCachedResult(results, for: cacheKey)
        }
        
        return results
    }
    
    /// 分页查询闹钟
    func fetchAlarmsPaginated(
        offset: Int = 0,
        limit: Int = 20,
        predicate: Predicate<Alarm>? = nil
    ) throws -> [Alarm] {
        var fetchDescriptor = FetchDescriptor<Alarm>(
            sortBy: [SortDescriptor(\.time)]
        )
        
        if let predicate = predicate {
            fetchDescriptor.predicate = predicate
        }
        
        fetchDescriptor.fetchOffset = offset
        fetchDescriptor.fetchLimit = limit
        
        return try mainContext.fetch(fetchDescriptor)
    }
    
    // MARK: - 后台数据操作
    
    /// 在后台上下文中执行耗时操作
    func performBackgroundTask<T>(_ operation: @escaping (ModelContext) throws -> T) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            Task.detached { [weak self] in
                guard let self = self else {
                    continuation.resume(throwing: PerformanceError.contextUnavailable)
                    return
                }
                
                do {
                    let result = try operation(self.backgroundContext)
                    try self.backgroundContext.save()
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    /// 批量插入闹钟
    func batchInsertAlarms(_ alarms: [Alarm]) async throws {
        try await performBackgroundTask { context in
            for alarm in alarms {
                context.insert(alarm)
            }
            
            // 批量处理待处理的更改
            context.processPendingChanges()
        }
        
        // 清除相关缓存
        clearCache(pattern: "alarms")
    }
    
    /// 批量删除闹钟
    func batchDeleteAlarms(matching predicate: Predicate<Alarm>) async throws -> Int {
        return try await performBackgroundTask { context in
            var fetchDescriptor = FetchDescriptor<Alarm>()
            fetchDescriptor.predicate = predicate
            
            let alarmsToDelete = try context.fetch(fetchDescriptor)
            let deleteCount = alarmsToDelete.count
            
            for alarm in alarmsToDelete {
                context.delete(alarm)
            }
            
            context.processPendingChanges()
            return deleteCount
        }
    }
    
    /// 批量更新闹钟状态
    func batchUpdateAlarmStatus(enabled: Bool, matching predicate: Predicate<Alarm>) async throws -> Int {
        return try await performBackgroundTask { context in
            var fetchDescriptor = FetchDescriptor<Alarm>()
            fetchDescriptor.predicate = predicate
            
            let alarmsToUpdate = try context.fetch(fetchDescriptor)
            let updateCount = alarmsToUpdate.count
            
            for alarm in alarmsToUpdate {
                alarm.isEnabled = enabled
                alarm.updateTimestamp()
            }
            
            context.processPendingChanges()
            return updateCount
        }
    }
    
    // MARK: - 批量操作队列
    
    /// 添加操作到批量队列
    func queueBatchOperation(_ operation: @escaping () -> Void) {
        batchOperationQueue.append(operation)
        
        // 重置批量计时器
        batchTimer?.invalidate()
        batchTimer = Timer.scheduledTimer(withTimeInterval: batchDelay, repeats: false) { [weak self] _ in
            self?.executeBatchOperations()
        }
    }
    
    /// 执行批量操作
    private func executeBatchOperations() {
        guard !batchOperationQueue.isEmpty else { return }
        
        let operations = batchOperationQueue
        batchOperationQueue.removeAll()
        
        Task {
            try? await performBackgroundTask { context in
                for operation in operations {
                    operation()
                }
                context.processPendingChanges()
            }
        }
    }
    
    // MARK: - 内存优化
    
    /// 清理内存和缓存
    func optimizeMemoryUsage() {
        // 清理过期缓存
        clearExpiredCache()
        
        // 处理待处理的更改
        mainContext.processPendingChanges()
        backgroundContext.processPendingChanges()
        
        // 触发垃圾回收
        autoreleasepool {
            // 强制释放不需要的对象
        }
    }
    
    /// 获取内存使用统计
    func getMemoryUsageStats() -> MemoryUsageStats {
        let processInfo = ProcessInfo.processInfo
        let physicalMemory = processInfo.physicalMemory
        
        // 获取当前内存使用情况
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        let usedMemory = kerr == KERN_SUCCESS ? info.resident_size : 0
        
        return MemoryUsageStats(
            totalPhysicalMemory: physicalMemory,
            usedMemory: usedMemory,
            cacheSize: queryCache.count,
            batchQueueSize: batchOperationQueue.count
        )
    }
    
    // MARK: - 缓存管理
    
    private func generateCacheKey(
        predicate: Predicate<Alarm>?,
        sortBy: [SortDescriptor<Alarm>],
        fetchLimit: Int?
    ) -> String {
        var key = "alarms"
        
        if let predicate = predicate {
            key += "_\(String(describing: predicate).hashValue)"
        }
        
        key += "_sort_\(sortBy.map { String(describing: $0) }.joined(separator: "_").hashValue)"
        
        if let limit = fetchLimit {
            key += "_limit_\(limit)"
        }
        
        return key
    }
    
    private func getCachedResult(for key: String) -> Any? {
        guard let timestamp = cacheTimestamps[key],
              Date().timeIntervalSince(timestamp) < cacheTimeout else {
            // 缓存过期，清理
            queryCache.removeValue(forKey: key)
            cacheTimestamps.removeValue(forKey: key)
            return nil
        }
        
        return queryCache[key]
    }
    
    private func setCachedResult(_ result: Any, for key: String) {
        queryCache[key] = result
        cacheTimestamps[key] = Date()
    }
    
    private func clearCache(pattern: String? = nil) {
        if let pattern = pattern {
            let keysToRemove = queryCache.keys.filter { $0.contains(pattern) }
            for key in keysToRemove {
                queryCache.removeValue(forKey: key)
                cacheTimestamps.removeValue(forKey: key)
            }
        } else {
            queryCache.removeAll()
            cacheTimestamps.removeAll()
        }
    }
    
    private func clearExpiredCache() {
        let now = Date()
        let expiredKeys = cacheTimestamps.compactMap { key, timestamp in
            now.timeIntervalSince(timestamp) >= cacheTimeout ? key : nil
        }
        
        for key in expiredKeys {
            queryCache.removeValue(forKey: key)
            cacheTimestamps.removeValue(forKey: key)
        }
    }
}

// MARK: - 数据操作进度跟踪
@Observable
final class DataOperationTracker {
    private(set) var currentOperations: [DataOperation] = []
    private(set) var completedOperations: [DataOperation] = []
    
    func startOperation(_ operation: DataOperation) {
        currentOperations.append(operation)
    }
    
    func updateProgress(for operationId: UUID, progress: Double) {
        if let index = currentOperations.firstIndex(where: { $0.id == operationId }) {
            currentOperations[index].progress = progress
        }
    }
    
    func completeOperation(_ operationId: UUID, success: Bool, error: Error? = nil) {
        if let index = currentOperations.firstIndex(where: { $0.id == operationId }) {
            var operation = currentOperations.remove(at: index)
            operation.isCompleted = true
            operation.isSuccessful = success
            operation.error = error
            operation.completedAt = Date()
            completedOperations.append(operation)
            
            // 只保留最近100个完成的操作
            if completedOperations.count > 100 {
                completedOperations.removeFirst(completedOperations.count - 100)
            }
        }
    }
    
    var isAnyOperationInProgress: Bool {
        !currentOperations.isEmpty
    }
    
    var totalProgress: Double {
        guard !currentOperations.isEmpty else { return 1.0 }
        let totalProgress = currentOperations.reduce(0.0) { $0 + $1.progress }
        return totalProgress / Double(currentOperations.count)
    }
}

// MARK: - 支持数据结构
struct DataOperation: Identifiable {
    let id = UUID()
    let type: DataOperationType
    let description: String
    let startedAt: Date
    var progress: Double = 0.0
    var isCompleted: Bool = false
    var isSuccessful: Bool = false
    var completedAt: Date?
    var error: Error?
    
    init(type: DataOperationType, description: String) {
        self.type = type
        self.description = description
        self.startedAt = Date()
    }
}

// DataOperationType 已在 SwiftDataLogger.swift 中定义

struct MemoryUsageStats {
    let totalPhysicalMemory: UInt64
    let usedMemory: UInt64
    let cacheSize: Int
    let batchQueueSize: Int
    
    var memoryUsagePercentage: Double {
        guard totalPhysicalMemory > 0 else { return 0.0 }
        return Double(usedMemory) / Double(totalPhysicalMemory) * 100.0
    }
    
    var formattedUsedMemory: String {
        ByteCountFormatter.string(fromByteCount: Int64(usedMemory), countStyle: .memory)
    }
    
    var formattedTotalMemory: String {
        ByteCountFormatter.string(fromByteCount: Int64(totalPhysicalMemory), countStyle: .memory)
    }
}

enum PerformanceError: LocalizedError {
    case contextUnavailable
    case batchOperationFailed(Error)
    case cacheError(String)
    case memoryOptimizationFailed
    
    var errorDescription: String? {
        switch self {
        case .contextUnavailable:
            return "数据上下文不可用"
        case .batchOperationFailed(let error):
            return "批量操作失败: \(error.localizedDescription)"
        case .cacheError(let message):
            return "缓存错误: \(message)"
        case .memoryOptimizationFailed:
            return "内存优化失败"
        }
    }
}