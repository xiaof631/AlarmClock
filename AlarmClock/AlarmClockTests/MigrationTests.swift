//
//  MigrationTests.swift
//  AlarmClockTests
//
//  Created by user on 25/7/25.
//

import XCTest
import SwiftData
@testable import AlarmClock

final class MigrationTests: SwiftDataTestBase {
    
    private let userDefaults = UserDefaults(suiteName: "MigrationTests")!
    
    override func setUp() {
        super.setUp()
        // 清理UserDefaults测试数据
        userDefaults.removeObject(forKey: "alarms")
        userDefaults.removeObject(forKey: "alarmTemplates")
    }
    
    override func tearDown() {
        // 清理UserDefaults测试数据
        userDefaults.removeObject(forKey: "alarms")
        userDefaults.removeObject(forKey: "alarmTemplates")
        super.tearDown()
    }
    
    // MARK: - 迁移检测测试
    
    func testDetectLegacyData() throws {
        // Given - 创建旧版本数据
        let legacyAlarms = createLegacyAlarmsData()
        let alarmsData = try JSONEncoder().encode(legacyAlarms)
        userDefaults.set(alarmsData, forKey: "alarms")
        
        // When
        let hasLegacyData = MigrationManager.hasLegacyData(in: userDefaults)
        
        // Then
        XCTAssertTrue(hasLegacyData)
    }
    
    func testNoLegacyDataDetection() throws {
        // Given - 没有旧数据
        
        // When
        let hasLegacyData = MigrationManager.hasLegacyData(in: userDefaults)
        
        // Then
        XCTAssertFalse(hasLegacyData)
    }
    
    // MARK: - 基本迁移测试
    
    func testMigrateSimpleAlarm() async throws {
        // Given
        let legacyAlarm = LegacyAlarm(
            id: UUID(),
            time: Date(),
            label: "测试闹钟",
            isEnabled: true,
            repeatDays: [.monday, .friday],
            sound: "默认",
            snoozeEnabled: true,
            vibrationEnabled: true,
            template: nil
        )
        
        let alarmsData = try JSONEncoder().encode([legacyAlarm])
        userDefaults.set(alarmsData, forKey: "alarms")
        
        // When
        try await MigrationManager.migrateFromUserDefaults(to: context, userDefaults: userDefaults)
        
        // Then
        let migratedAlarms = try getAllEntities(of: Alarm.self)
        XCTAssertEqual(migratedAlarms.count, 1)
        
        let migratedAlarm = migratedAlarms.first!
        XCTAssertEqual(migratedAlarm.id, legacyAlarm.id)
        XCTAssertEqual(migratedAlarm.label, legacyAlarm.label)
        XCTAssertEqual(migratedAlarm.isEnabled, legacyAlarm.isEnabled)
        XCTAssertEqual(migratedAlarm.sound, legacyAlarm.sound)
        XCTAssertEqual(migratedAlarm.snoozeEnabled, legacyAlarm.snoozeEnabled)
        XCTAssertEqual(migratedAlarm.vibrationEnabled, legacyAlarm.vibrationEnabled)
        
        // 验证重复天数迁移
        XCTAssertEqual(migratedAlarm.repeatDays.count, 2)
        let weekdays = Set(migratedAlarm.repeatDays.map { $0.weekday })
        XCTAssertTrue(weekdays.contains(Weekday.monday.rawValue))
        XCTAssertTrue(weekdays.contains(Weekday.friday.rawValue))
    }
    
    func testMigrateAlarmWithTemplate() async throws {
        // Given
        let legacyTemplate = LegacyAlarmTemplate(
            id: UUID(),
            name: "工作提醒",
            category: "工作",
            icon: "💼",
            description: "工作相关提醒",
            time: "每日",
            frequency: "每日",
            defaultTime: "09:00",
            repeatType: "daily",
            scenario: .work
        )
        
        let legacyAlarm = LegacyAlarm(
            id: UUID(),
            time: Date(),
            label: "工作闹钟",
            isEnabled: true,
            repeatDays: [],
            sound: "默认",
            snoozeEnabled: true,
            vibrationEnabled: true,
            template: legacyTemplate
        )
        
        let alarmsData = try JSONEncoder().encode([legacyAlarm])
        userDefaults.set(alarmsData, forKey: "alarms")
        
        // When
        try await MigrationManager.migrateFromUserDefaults(to: context, userDefaults: userDefaults)
        
        // Then
        let migratedAlarms = try getAllEntities(of: Alarm.self)
        let migratedTemplates = try getAllEntities(of: SwiftDataModels.AlarmTemplate.self)
        
        XCTAssertEqual(migratedAlarms.count, 1)
        XCTAssertEqual(migratedTemplates.count, 1)
        
        let migratedAlarm = migratedAlarms.first!
        let migratedTemplate = migratedTemplates.first!
        
        // 验证模板迁移
        XCTAssertEqual(migratedTemplate.name, legacyTemplate.name)
        XCTAssertEqual(migratedTemplate.category, legacyTemplate.category)
        XCTAssertEqual(migratedTemplate.scenario, legacyTemplate.scenario.rawValue)
        
        // 验证关系
        XCTAssertEqual(migratedAlarm.template, migratedTemplate)
        XCTAssertTrue(migratedTemplate.alarms.contains(migratedAlarm))
    }
    
    func testMigrateMultipleAlarms() async throws {
        // Given
        let legacyAlarms = createLegacyAlarmsData()
        let alarmsData = try JSONEncoder().encode(legacyAlarms)
        userDefaults.set(alarmsData, forKey: "alarms")
        
        // When
        try await MigrationManager.migrateFromUserDefaults(to: context, userDefaults: userDefaults)
        
        // Then
        let migratedAlarms = try getAllEntities(of: Alarm.self)
        XCTAssertEqual(migratedAlarms.count, legacyAlarms.count)
        
        // 验证每个闹钟都被正确迁移
        for legacyAlarm in legacyAlarms {
            let migratedAlarm = migratedAlarms.first { $0.id == legacyAlarm.id }
            XCTAssertNotNil(migratedAlarm, "闹钟 \(legacyAlarm.id) 未被迁移")
        }
    }
    
    // MARK: - 数据完整性测试
    
    func testMigrationDataIntegrity() async throws {
        // Given
        let legacyAlarms = createComplexLegacyData()
        let alarmsData = try JSONEncoder().encode(legacyAlarms)
        userDefaults.set(alarmsData, forKey: "alarms")
        
        // When
        try await MigrationManager.migrateFromUserDefaults(to: context, userDefaults: userDefaults)
        
        // Then
        try validateDataIntegrity()
        
        // 验证所有关系都正确建立
        let migratedAlarms = try getAllEntities(of: Alarm.self)
        for alarm in migratedAlarms {
            // 验证重复天数关系
            for repeatDay in alarm.repeatDays {
                XCTAssertEqual(repeatDay.alarm, alarm)
            }
            
            // 验证模板关系
            if let template = alarm.template {
                XCTAssertTrue(template.alarms.contains(alarm))
            }
        }
    }
    
    func testMigrationPreservesTimestamps() async throws {
        // Given
        let specificTime = Date(timeIntervalSince1970: 1640995200) // 2022-01-01 00:00:00
        let legacyAlarm = LegacyAlarm(
            id: UUID(),
            time: specificTime,
            label: "时间测试",
            isEnabled: true,
            repeatDays: [],
            sound: "默认",
            snoozeEnabled: true,
            vibrationEnabled: true,
            template: nil
        )
        
        let alarmsData = try JSONEncoder().encode([legacyAlarm])
        userDefaults.set(alarmsData, forKey: "alarms")
        
        // When
        try await MigrationManager.migrateFromUserDefaults(to: context, userDefaults: userDefaults)
        
        // Then
        let migratedAlarms = try getAllEntities(of: Alarm.self)
        let migratedAlarm = migratedAlarms.first!
        
        XCTAssertEqual(migratedAlarm.time, specificTime)
        XCTAssertNotNil(migratedAlarm.createdAt)
        XCTAssertNotNil(migratedAlarm.updatedAt)
    }
    
    // MARK: - 错误处理测试
    
    func testMigrationWithCorruptedData() async throws {
        // Given - 损坏的JSON数据
        let corruptedData = "invalid json data".data(using: .utf8)!
        userDefaults.set(corruptedData, forKey: "alarms")
        
        // When & Then
        await XCTAssertAsyncThrowsError(
            try await MigrationManager.migrateFromUserDefaults(to: context, userDefaults: userDefaults)
        ) { error in
            // 验证是预期的错误类型
            XCTAssertTrue(error is DecodingError || error is SwiftDataError)
        }
    }
    
    func testMigrationWithEmptyData() async throws {
        // Given - 空数据
        let emptyData = Data()
        userDefaults.set(emptyData, forKey: "alarms")
        
        // When
        try await MigrationManager.migrateFromUserDefaults(to: context, userDefaults: userDefaults)
        
        // Then - 应该成功完成，但没有迁移任何数据
        let migratedAlarms = try getAllEntities(of: Alarm.self)
        XCTAssertEqual(migratedAlarms.count, 0)
    }
    
    func testMigrationRollbackOnError() async throws {
        // Given - 创建一些有效数据和一些会导致错误的数据
        var legacyAlarms = createLegacyAlarmsData()
        
        // 添加一个会导致约束违反的闹钟（相同ID）
        let duplicateAlarm = legacyAlarms[0]
        legacyAlarms.append(duplicateAlarm)
        
        let alarmsData = try JSONEncoder().encode(legacyAlarms)
        userDefaults.set(alarmsData, forKey: "alarms")
        
        // When & Then
        await XCTAssertAsyncThrowsError(
            try await MigrationManager.migrateFromUserDefaults(to: context, userDefaults: userDefaults)
        )
        
        // 验证没有部分数据被保留（回滚成功）
        let remainingAlarms = try getAllEntities(of: Alarm.self)
        XCTAssertEqual(remainingAlarms.count, 0)
    }
    
    // MARK: - 清理测试
    
    func testDataCleanupAfterSuccessfulMigration() async throws {
        // Given
        let legacyAlarms = createLegacyAlarmsData()
        let alarmsData = try JSONEncoder().encode(legacyAlarms)
        userDefaults.set(alarmsData, forKey: "alarms")
        
        // 验证数据存在
        XCTAssertNotNil(userDefaults.data(forKey: "alarms"))
        
        // When
        try await MigrationManager.migrateFromUserDefaults(to: context, userDefaults: userDefaults)
        
        // Then - 旧数据应该被清理
        XCTAssertNil(userDefaults.data(forKey: "alarms"))
    }
    
    func testDataPreservationAfterFailedMigration() async throws {
        // Given - 会导致迁移失败的数据
        let corruptedData = "invalid json".data(using: .utf8)!
        userDefaults.set(corruptedData, forKey: "alarms")
        
        // When
        await XCTAssertAsyncThrowsError(
            try await MigrationManager.migrateFromUserDefaults(to: context, userDefaults: userDefaults)
        )
        
        // Then - 原始数据应该被保留
        XCTAssertNotNil(userDefaults.data(forKey: "alarms"))
    }
    
    // MARK: - 重复迁移测试
    
    func testPreventDuplicateMigration() async throws {
        // Given
        let legacyAlarms = createLegacyAlarmsData()
        let alarmsData = try JSONEncoder().encode(legacyAlarms)
        userDefaults.set(alarmsData, forKey: "alarms")
        
        // When - 执行第一次迁移
        try await MigrationManager.migrateFromUserDefaults(to: context, userDefaults: userDefaults)
        let firstMigrationCount = try getEntityCount(of: Alarm.self)
        
        // 重新设置数据（模拟重复迁移尝试）
        userDefaults.set(alarmsData, forKey: "alarms")
        
        // When - 执行第二次迁移
        try await MigrationManager.migrateFromUserDefaults(to: context, userDefaults: userDefaults)
        let secondMigrationCount = try getEntityCount(of: Alarm.self)
        
        // Then - 数据不应该重复
        XCTAssertEqual(firstMigrationCount, secondMigrationCount)
    }
    
    // MARK: - 性能测试
    
    func testLargeMigrationPerformance() async throws {
        // Given - 大量数据
        let largeDataSet = createLargeLegacyDataSet(count: 1000)
        let alarmsData = try JSONEncoder().encode(largeDataSet)
        userDefaults.set(alarmsData, forKey: "alarms")
        
        // When
        let startTime = CFAbsoluteTimeGetCurrent()
        try await MigrationManager.migrateFromUserDefaults(to: context, userDefaults: userDefaults)
        let endTime = CFAbsoluteTimeGetCurrent()
        
        // Then
        let migrationTime = endTime - startTime
        let migratedCount = try getEntityCount(of: Alarm.self)
        
        XCTAssertEqual(migratedCount, largeDataSet.count)
        XCTAssertLessThan(migrationTime, 10.0, "迁移1000个闹钟应该在10秒内完成")
        
        print("迁移\(largeDataSet.count)个闹钟耗时: \(String(format: "%.3f", migrationTime))秒")
    }
    
    // MARK: - 辅助方法
    
    private func createLegacyAlarmsData() -> [LegacyAlarm] {
        return [
            LegacyAlarm(
                id: UUID(),
                time: Date(),
                label: "工作日闹钟",
                isEnabled: true,
                repeatDays: [.monday, .tuesday, .wednesday, .thursday, .friday],
                sound: "默认",
                snoozeEnabled: true,
                vibrationEnabled: true,
                template: nil
            ),
            LegacyAlarm(
                id: UUID(),
                time: Date().addingTimeInterval(3600),
                label: "周末闹钟",
                isEnabled: false,
                repeatDays: [.saturday, .sunday],
                sound: "铃声",
                snoozeEnabled: false,
                vibrationEnabled: false,
                template: nil
            )
        ]
    }
    
    private func createComplexLegacyData() -> [LegacyAlarm] {
        let template = LegacyAlarmTemplate(
            id: UUID(),
            name: "复杂模板",
            category: "测试",
            icon: "🧪",
            description: "复杂测试模板",
            time: "每日",
            frequency: "每日",
            defaultTime: "10:00",
            repeatType: "daily",
            scenario: .work
        )
        
        return [
            LegacyAlarm(
                id: UUID(),
                time: Date(),
                label: "带模板的闹钟",
                isEnabled: true,
                repeatDays: [.monday, .wednesday, .friday],
                sound: "默认",
                snoozeEnabled: true,
                vibrationEnabled: true,
                template: template
            ),
            LegacyAlarm(
                id: UUID(),
                time: Date().addingTimeInterval(1800),
                label: "无模板闹钟",
                isEnabled: true,
                repeatDays: [],
                sound: "铃声",
                snoozeEnabled: false,
                vibrationEnabled: true,
                template: nil
            )
        ]
    }
    
    private func createLargeLegacyDataSet(count: Int) -> [LegacyAlarm] {
        var alarms: [LegacyAlarm] = []
        
        for i in 0..<count {
            let alarm = LegacyAlarm(
                id: UUID(),
                time: Date().addingTimeInterval(TimeInterval(i * 60)),
                label: "大数据集闹钟 \(i)",
                isEnabled: i % 2 == 0,
                repeatDays: i % 3 == 0 ? [.monday, .friday] : [],
                sound: "默认",
                snoozeEnabled: true,
                vibrationEnabled: true,
                template: nil
            )
            alarms.append(alarm)
        }
        
        return alarms
    }
}