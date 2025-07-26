//
//  SwiftDataAlarmManager.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import Foundation
import SwiftUI
import SwiftData
import UserNotifications

@Observable
final class SwiftDataAlarmManager: SwiftDataErrorHandling {
    private let modelContext: ModelContext
    private let performanceOptimizer: PerformanceOptimizer
    let operationTracker: DataOperationTracker
    private let errorHandler = SwiftDataErrorHandler.shared
    private let logger = SwiftDataLogger.shared
    
    init(modelContext: ModelContext, container: ModelContainer) {
        self.modelContext = modelContext
        self.performanceOptimizer = PerformanceOptimizer(container: container, mainContext: modelContext)
        self.operationTracker = DataOperationTracker()
        requestNotificationPermission()
    }
    
    // 便利初始化器，保持向后兼容
    convenience init(modelContext: ModelContext) {
        // 从modelContext获取container（这需要iOS 17.4+）
        let container = modelContext.container
        self.init(modelContext: modelContext, container: container)
    }
    
    // MARK: - 闹钟管理
    
    func addAlarm(_ alarm: Alarm) throws {
        let startTime = Date()
        
        do {
            // 数据验证
            try validateAlarm(alarm)
            
            modelContext.insert(alarm)
            try modelContext.save()
            scheduleNotification(for: alarm)
            
            // 记录成功日志
            let duration = Date().timeIntervalSince(startTime)
            logger.logOperation(
                type: .insert,
                entity: "Alarm",
                operation: "add",
                details: ["id": alarm.id.uuidString, "label": alarm.label],
                duration: duration,
                success: true
            )
        } catch {
            let duration = Date().timeIntervalSince(startTime)
            let swiftDataError = errorHandler.handleError(error, context: "添加闹钟")
            
            // 记录失败日志
            logger.logOperation(
                type: .insert,
                entity: "Alarm",
                operation: "add",
                details: ["id": alarm.id.uuidString],
                duration: duration,
                success: false,
                error: swiftDataError
            )
            
            throw swiftDataError
        }
    }
    
    func updateAlarm(_ alarm: Alarm) throws {
        let startTime = Date()
        
        do {
            // 数据验证
            try validateAlarm(alarm)
            
            alarm.updateTimestamp()
            try modelContext.save()
            scheduleNotification(for: alarm)
            
            // 记录成功日志
            let duration = Date().timeIntervalSince(startTime)
            logger.logOperation(
                type: .update,
                entity: "Alarm",
                operation: "update",
                details: ["id": alarm.id.uuidString, "label": alarm.label],
                duration: duration,
                success: true
            )
        } catch {
            let duration = Date().timeIntervalSince(startTime)
            let swiftDataError = errorHandler.handleError(error, context: "更新闹钟")
            
            // 记录失败日志
            logger.logOperation(
                type: .update,
                entity: "Alarm",
                operation: "update",
                details: ["id": alarm.id.uuidString],
                duration: duration,
                success: false,
                error: swiftDataError
            )
            
            throw swiftDataError
        }
    }
    
    func deleteAlarm(_ alarm: Alarm) throws {
        do {
            cancelNotification(for: alarm)
            modelContext.delete(alarm)
            try modelContext.save()
        } catch {
            let swiftDataError = errorHandler.handleError(error, context: "删除闹钟")
            throw swiftDataError
        }
    }
    
    func toggleAlarm(_ alarm: Alarm, enabled: Bool) throws {
        alarm.isEnabled = enabled
        alarm.updateTimestamp()
        try modelContext.save()
        
        if alarm.isEnabled {
            scheduleNotification(for: alarm)
        } else {
            cancelNotification(for: alarm)
        }
    }
    
    func toggleAlarm(_ alarm: Alarm) throws {
        try toggleAlarm(alarm, enabled: !alarm.isEnabled)
    }
    
    // MARK: - 查询方法（性能优化版本）
    
    func fetchAllAlarms() throws -> [Alarm] {
        let startTime = Date()
        
        do {
            let alarms = try performanceOptimizer.fetchAlarmsOptimized()
            
            // 记录查询日志
            let duration = Date().timeIntervalSince(startTime)
            logger.logQuery(
                entity: "Alarm",
                predicate: nil,
                sortDescriptors: ["time"],
                fetchLimit: nil,
                resultCount: alarms.count,
                duration: duration,
                cacheHit: false // 这里可以从performanceOptimizer获取缓存信息
            )
            
            return alarms
        } catch {
            let duration = Date().timeIntervalSince(startTime)
            let swiftDataError = errorHandler.handleError(error, context: "获取所有闹钟")
            
            // 记录失败日志
            logger.logOperation(
                type: .fetch,
                entity: "Alarm",
                operation: "fetchAll",
                duration: duration,
                success: false,
                error: swiftDataError
            )
            
            throw swiftDataError
        }
    }
    
    func fetchEnabledAlarms() throws -> [Alarm] {
        let predicate = #Predicate<Alarm> { $0.isEnabled == true }
        return try performanceOptimizer.fetchAlarmsOptimized(predicate: predicate)
    }
    
    func fetchAlarms(for scenario: ScenarioType) throws -> [Alarm] {
        // 获取所有闹钟然后在内存中过滤，避免复杂的SwiftData Predicate
        let allAlarms = try performanceOptimizer.fetchAlarmsOptimized(predicate: nil)
        return allAlarms.filter { alarm in
            alarm.template?.scenario == scenario.rawValue
        }
    }
    
    func fetchAlarmsPaginated(offset: Int = 0, limit: Int = 20) throws -> [Alarm] {
        return try performanceOptimizer.fetchAlarmsPaginated(offset: offset, limit: limit)
    }
    
    func fetchRecentAlarms(limit: Int = 10) throws -> [Alarm] {
        let predicate = #Predicate<Alarm> { $0.isEnabled == true }
        return try performanceOptimizer.fetchAlarmsOptimized(
            predicate: predicate,
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)],
            fetchLimit: limit
        )
    }
    
    // MARK: - 模板管理（性能优化版本）
    
    func fetchTemplates(for scenario: ScenarioType) throws -> [AlarmTemplate] {
        return try performanceOptimizer.fetchTemplatesOptimized(for: scenario)
    }
    
    func fetchAllTemplates() throws -> [AlarmTemplate] {
        return try performanceOptimizer.fetchTemplatesOptimized()
    }
    
    func createAlarmFromTemplate(_ template: AlarmTemplate) -> Alarm {
        let calendar = Calendar.current
        let now = Date()
        
        // 解析模板的默认时间
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let templateTime = timeFormatter.date(from: template.defaultTime) ?? now
        
        // 设置为今天的对应时间
        let alarmTime = calendar.date(
            bySettingHour: calendar.component(.hour, from: templateTime),
            minute: calendar.component(.minute, from: templateTime),
            second: 0,
            of: now
        ) ?? now
        
        // 创建新闹钟
        let alarm = Alarm(
            time: alarmTime,
            label: template.name,
            sound: "默认",
            snoozeEnabled: true,
            vibrationEnabled: true
        )
        
        // 设置模板关联
        alarm.template = template
        
        // 根据模板类型设置重复天数
        setupRepeatDays(for: alarm, template: template)
        
        return alarm
    }
    
    private func setupRepeatDays(for alarm: Alarm, template: AlarmTemplate) {
        let calendar = Calendar.current
        let now = Date()
        
        switch template.repeatType {
        case "daily":
            for weekday in Weekday.allCases {
                let alarmRepeat = AlarmRepeat(weekday: weekday)
                alarmRepeat.alarm = alarm
                alarm.repeatDays.append(alarmRepeat)
            }
        case "weekdays":
            let weekdays: [Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday]
            for weekday in weekdays {
                let alarmRepeat = AlarmRepeat(weekday: weekday)
                alarmRepeat.alarm = alarm
                alarm.repeatDays.append(alarmRepeat)
            }
        case "weekly":
            let currentWeekday = Weekday(rawValue: calendar.component(.weekday, from: now)) ?? .monday
            let alarmRepeat = AlarmRepeat(weekday: currentWeekday)
            alarmRepeat.alarm = alarm
            alarm.repeatDays.append(alarmRepeat)
        default:
            // 单次闹钟，不添加重复天数
            break
        }
    }
    
    // MARK: - 通知管理
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("通知权限请求失败: \(error)")
            }
        }
    }
    
    private func scheduleNotification(for alarm: Alarm) {
        guard alarm.isEnabled else { return }
        
        let center = UNUserNotificationCenter.current()
        
        // 取消现有通知
        center.removePendingNotificationRequests(withIdentifiers: [alarm.id.uuidString])
        
        // 创建通知内容
        let content = UNMutableNotificationContent()
        content.title = "闹钟"
        content.body = alarm.label
        content.sound = .default
        content.categoryIdentifier = "ALARM_CATEGORY"
        
        // 设置通知时间
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: alarm.time)
        let minute = calendar.component(.minute, from: alarm.time)
        
        if alarm.repeatDays.isEmpty {
            // 单次闹钟
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: alarm.id.uuidString, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("添加通知失败: \(error)")
                }
            }
        } else {
            // 重复闹钟
            for alarmRepeat in alarm.repeatDays {
                var dateComponents = DateComponents()
                dateComponents.hour = hour
                dateComponents.minute = minute
                dateComponents.weekday = alarmRepeat.weekday
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let identifier = "\(alarm.id.uuidString)_\(alarmRepeat.weekday)"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print("添加重复通知失败: \(error)")
                    }
                }
            }
        }
    }
    
    private func cancelNotification(for alarm: Alarm) {
        let center = UNUserNotificationCenter.current()
        
        if alarm.repeatDays.isEmpty {
            center.removePendingNotificationRequests(withIdentifiers: [alarm.id.uuidString])
        } else {
            let identifiers = alarm.repeatDays.map { "\(alarm.id.uuidString)_\($0.weekday)" }
            center.removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    // MARK: - 批量操作（性能优化）
    
    /// 批量添加闹钟
    func batchAddAlarms(_ alarms: [Alarm]) async throws {
        let operation = DataOperation(type: .batchInsert, description: "批量添加\(alarms.count)个闹钟")
        operationTracker.startOperation(operation)
        
        do {
            try await performanceOptimizer.batchInsertAlarms(alarms)
            
            // 为所有闹钟安排通知
            for alarm in alarms {
                if alarm.isEnabled {
                    scheduleNotification(for: alarm)
                }
            }
            
            operationTracker.completeOperation(operation.id, success: true)
        } catch {
            operationTracker.completeOperation(operation.id, success: false, error: error)
            throw error
        }
    }
    
    /// 批量删除闹钟
    func batchDeleteAlarms(matching predicate: Predicate<Alarm>) async throws -> Int {
        let operation = DataOperation(type: .batchDelete, description: "批量删除闹钟")
        operationTracker.startOperation(operation)
        
        do {
            // 先获取要删除的闹钟以取消通知
            let alarmsToDelete = try performanceOptimizer.fetchAlarmsOptimized(predicate: predicate)
            for alarm in alarmsToDelete {
                cancelNotification(for: alarm)
            }
            
            let deleteCount = try await performanceOptimizer.batchDeleteAlarms(matching: predicate)
            operationTracker.completeOperation(operation.id, success: true)
            return deleteCount
        } catch {
            operationTracker.completeOperation(operation.id, success: false, error: error)
            throw error
        }
    }
    
    /// 批量更新闹钟状态
    func batchToggleAlarms(enabled: Bool, matching predicate: Predicate<Alarm>) async throws -> Int {
        let operation = DataOperation(type: .batchUpdate, description: "批量\(enabled ? "启用" : "禁用")闹钟")
        operationTracker.startOperation(operation)
        
        do {
            let updateCount = try await performanceOptimizer.batchUpdateAlarmStatus(enabled: enabled, matching: predicate)
            
            // 更新通知状态
            let updatedAlarms = try performanceOptimizer.fetchAlarmsOptimized(predicate: predicate)
            for alarm in updatedAlarms {
                if alarm.isEnabled {
                    scheduleNotification(for: alarm)
                } else {
                    cancelNotification(for: alarm)
                }
            }
            
            operationTracker.completeOperation(operation.id, success: true)
            return updateCount
        } catch {
            operationTracker.completeOperation(operation.id, success: false, error: error)
            throw error
        }
    }
    
    // MARK: - 性能监控
    
    /// 获取性能统计信息
    var performanceStats: MemoryUsageStats {
        return performanceOptimizer.getMemoryUsageStats()
    }
    

    /// 优化内存使用
    func optimizeMemoryUsage() {
        let operation = DataOperation(type: .memoryOptimization, description: "内存优化")
        operationTracker.startOperation(operation)
        
        performanceOptimizer.optimizeMemoryUsage()
        operationTracker.completeOperation(operation.id, success: true)
    }
    
    /// 队列批量操作
    func queueBatchOperation(_ operation: @escaping () -> Void) {
        performanceOptimizer.queueBatchOperation(operation)
    }
    
    // MARK: - 数据验证方法
    
    private func validateAlarm(_ alarm: Alarm) throws {
        // 验证标签长度
        if alarm.label.count > 100 {
            throw SwiftDataError.validationFailed(field: "label", reason: "标签长度不能超过100个字符")
        }
        
        // 验证时间有效性
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: alarm.time)
        guard let hour = components.hour, let minute = components.minute,
              hour >= 0, hour < 24, minute >= 0, minute < 60 else {
            throw SwiftDataError.validationFailed(field: "time", reason: "时间格式无效")
        }
        
        // 验证重复天数
        for repeatDay in alarm.repeatDays {
            if repeatDay.weekday < 1 || repeatDay.weekday > 7 {
                throw SwiftDataError.validationFailed(field: "repeatDays", reason: "重复天数值必须在1-7之间")
            }
        }
        
        // 验证声音设置
        if alarm.sound.isEmpty {
            throw SwiftDataError.validationFailed(field: "sound", reason: "声音设置不能为空")
        }
    }
    
    private func validateTemplate(_ template: AlarmTemplate) throws {
        // 验证模板名称
        if template.name.isEmpty {
            throw SwiftDataError.validationFailed(field: "name", reason: "模板名称不能为空")
        }
        
        if template.name.count > 50 {
            throw SwiftDataError.validationFailed(field: "name", reason: "模板名称长度不能超过50个字符")
        }
        
        // 验证分类
        if template.category.isEmpty {
            throw SwiftDataError.validationFailed(field: "category", reason: "模板分类不能为空")
        }
        
        // 验证场景
        if template.scenario.isEmpty {
            throw SwiftDataError.validationFailed(field: "scenario", reason: "模板场景不能为空")
        }
        
        // 验证默认时间格式
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        if timeFormatter.date(from: template.defaultTime) == nil {
            throw SwiftDataError.validationFailed(field: "defaultTime", reason: "默认时间格式无效，应为HH:mm格式")
        }
    }
    
    // MARK: - 错误处理方法
    
    func handleSwiftDataError(_ error: SwiftDataError, context: String) {
        errorHandler.logError(error, context: context)
        
        // 根据错误类型执行特定的处理逻辑
        switch error {
        case .memoryPressure:
            // 触发内存优化
            optimizeMemoryUsage()
        case .queryTimeout:
            // 清理缓存以提高性能
            performanceOptimizer.optimizeMemoryUsage()
        case .dataCorruption, .inconsistentState:
            // 标记需要数据完整性检查
            scheduleDataIntegrityCheck()
        default:
            break
        }
    }
    
    private func scheduleDataIntegrityCheck() {
        // 安排数据完整性检查
        Task {
            await performDataIntegrityCheck()
        }
    }
    
    private func performDataIntegrityCheck() async {
        let operation = DataOperation(type: .migration, description: "数据完整性检查")
        operationTracker.startOperation(operation)
        
        do {
            // 检查孤立的AlarmRepeat记录
            let orphanedRepeats = try await findOrphanedAlarmRepeats()
            if !orphanedRepeats.isEmpty {
                handleSwiftDataError(.orphanedRecord(entity: "AlarmRepeat", id: "\(orphanedRepeats.count)条记录"), context: "完整性检查")
            }
            
            // 检查无效的模板引用
            let invalidTemplateRefs = try await findInvalidTemplateReferences()
            if !invalidTemplateRefs.isEmpty {
                handleSwiftDataError(.referentialIntegrityViolation(from: "Alarm", to: "AlarmTemplate"), context: "完整性检查")
            }
            
            operationTracker.completeOperation(operation.id, success: true)
        } catch {
            let swiftDataError = errorHandler.handleError(error, context: "数据完整性检查")
            operationTracker.completeOperation(operation.id, success: false, error: swiftDataError)
        }
    }
    
    private func findOrphanedAlarmRepeats() async throws -> [AlarmRepeat] {
        return try await performanceOptimizer.performBackgroundTask { context in
            let fetchDescriptor = FetchDescriptor<AlarmRepeat>()
            let allRepeats = try context.fetch(fetchDescriptor)
            return allRepeats.filter { $0.alarm == nil }
        }
    }
    
    private func findInvalidTemplateReferences() async throws -> [Alarm] {
        return try await performanceOptimizer.performBackgroundTask { context in
            let fetchDescriptor = FetchDescriptor<Alarm>()
            let allAlarms = try context.fetch(fetchDescriptor)
            return allAlarms.filter { alarm in
                if let template = alarm.template {
                    // 检查模板是否仍然存在于数据库中
                    let templateDescriptor = FetchDescriptor<AlarmTemplate>()
                    let templates = try? context.fetch(templateDescriptor)
                    return templates?.first(where: { $0.id == template.id }) == nil
                }
                return false
            }
        }
    }
    
    // MARK: - 辅助方法
    
    var nextAlarm: Alarm? {
        do {
            let enabledAlarms = try fetchEnabledAlarms()
            guard !enabledAlarms.isEmpty else { return nil }
            
            let calendar = Calendar.current
            let now = Date()
            
            var nextAlarmTime: Date?
            var nextAlarm: Alarm?
            
            for alarm in enabledAlarms {
                let alarmTime = getNextAlarmTime(for: alarm, from: now)
                
                if nextAlarmTime == nil || alarmTime < nextAlarmTime! {
                    nextAlarmTime = alarmTime
                    nextAlarm = alarm
                }
            }
            
            return nextAlarm
        } catch {
            print("获取下一个闹钟失败: \(error)")
            return nil
        }
    }
    
    private func getNextAlarmTime(for alarm: Alarm, from date: Date) -> Date {
        let calendar = Calendar.current
        let alarmHour = calendar.component(.hour, from: alarm.time)
        let alarmMinute = calendar.component(.minute, from: alarm.time)
        
        if alarm.repeatDays.isEmpty {
            // 单次闹钟
            let alarmTime = calendar.date(bySettingHour: alarmHour, minute: alarmMinute, second: 0, of: date) ?? date
            return alarmTime > date ? alarmTime : calendar.date(byAdding: .day, value: 1, to: alarmTime) ?? alarmTime
        } else {
            // 重复闹钟
            let currentWeekday = calendar.component(.weekday, from: date)
            let currentTime = calendar.date(bySettingHour: alarmHour, minute: alarmMinute, second: 0, of: date) ?? date
            
            // 检查今天是否有闹钟且还没过时间
            if alarm.repeatDays.contains(where: { $0.weekday == currentWeekday }) && currentTime > date {
                return currentTime
            }
            
            // 找下一个闹钟日期
            for i in 1...7 {
                let nextDate = calendar.date(byAdding: .day, value: i, to: date) ?? date
                let nextWeekday = calendar.component(.weekday, from: nextDate)
                
                if alarm.repeatDays.contains(where: { $0.weekday == nextWeekday }) {
                    return calendar.date(bySettingHour: alarmHour, minute: alarmMinute, second: 0, of: nextDate) ?? nextDate
                }
            }
            
            return currentTime
        }
    }
}