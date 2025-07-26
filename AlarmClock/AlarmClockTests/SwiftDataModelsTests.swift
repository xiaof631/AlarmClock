//
//  SwiftDataModelsTests.swift
//  AlarmClockTests
//
//  Created by user on 25/7/25.
//

import XCTest
import SwiftData
@testable import AlarmClock

final class SwiftDataModelsTests: SwiftDataTestBase {
    
    // MARK: - Alarm模型测试
    
    func testAlarmCreation() throws {
        // Given
        let testTime = Date()
        let testLabel = "测试闹钟"
        
        // When
        let alarm = createTestAlarm(time: testTime, label: testLabel)
        try saveContext()
        
        // Then
        XCTAssertEqual(alarm.time, testTime)
        XCTAssertEqual(alarm.label, testLabel)
        XCTAssertTrue(alarm.isEnabled)
        XCTAssertEqual(alarm.sound, "默认")
        XCTAssertTrue(alarm.snoozeEnabled)
        XCTAssertTrue(alarm.vibrationEnabled)
        XCTAssertNotNil(alarm.id)
        XCTAssertNotNil(alarm.createdAt)
        XCTAssertNotNil(alarm.updatedAt)
    }
    
    func testAlarmUniqueID() throws {
        // Given & When
        let alarm1 = createTestAlarm(label: "闹钟1")
        let alarm2 = createTestAlarm(label: "闹钟2")
        try saveContext()
        
        // Then
        XCTAssertNotEqual(alarm1.id, alarm2.id)
    }
    
    func testAlarmTimeString() throws {
        // Given
        let calendar = Calendar.current
        let testDate = calendar.date(bySettingHour: 14, minute: 30, second: 0, of: Date())!
        let alarm = createTestAlarm(time: testDate)
        
        // When
        let timeString = alarm.timeString
        
        // Then
        XCTAssertTrue(timeString.contains("14:30") || timeString.contains("2:30"))
    }
    
    func testAlarmUpdateTimestamp() throws {
        // Given
        let alarm = createTestAlarm()
        let originalUpdatedAt = alarm.updatedAt
        
        // When
        Thread.sleep(forTimeInterval: 0.01) // 确保时间差异
        alarm.updateTimestamp()
        
        // Then
        XCTAssertGreaterThan(alarm.updatedAt, originalUpdatedAt)
    }
    
    func testAlarmRepeatString() throws {
        // Given
        let alarm = createTestAlarm()
        
        // When & Then - 无重复
        XCTAssertEqual(alarm.repeatString, "永不")
        
        // When & Then - 工作日
        let weekdays: [Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday]
        for weekday in weekdays {
            _ = createTestAlarmRepeat(weekday: weekday, alarm: alarm)
        }
        XCTAssertEqual(alarm.repeatString, "工作日")
        
        // When & Then - 周末
        alarm.repeatDays.removeAll()
        _ = createTestAlarmRepeat(weekday: .saturday, alarm: alarm)
        _ = createTestAlarmRepeat(weekday: .sunday, alarm: alarm)
        XCTAssertEqual(alarm.repeatString, "周末")
        
        // When & Then - 每天
        alarm.repeatDays.removeAll()
        for weekday in Weekday.allCases {
            _ = createTestAlarmRepeat(weekday: weekday, alarm: alarm)
        }
        XCTAssertEqual(alarm.repeatString, "每天")
    }
    
    func testAlarmWeekdays() throws {
        // Given
        let alarm = createTestAlarm()
        let expectedWeekdays: [Weekday] = [.monday, .wednesday, .friday]
        
        // When
        for weekday in expectedWeekdays {
            _ = createTestAlarmRepeat(weekday: weekday, alarm: alarm)
        }
        
        // Then
        let actualWeekdays = alarm.weekdays
        XCTAssertEqual(Set(actualWeekdays), Set(expectedWeekdays))
    }
    
    // MARK: - AlarmRepeat模型测试
    
    func testAlarmRepeatCreation() throws {
        // Given
        let weekday = Weekday.monday
        
        // When
        let alarmRepeat = createTestAlarmRepeat(weekday: weekday)
        try saveContext()
        
        // Then
        XCTAssertEqual(alarmRepeat.weekday, weekday.rawValue)
        XCTAssertNotNil(alarmRepeat.id)
    }
    
    func testAlarmRepeatWithIntegerWeekday() throws {
        // Given
        let weekdayInt = 3 // Tuesday
        
        // When
        let alarmRepeat = AlarmRepeat(weekday: weekdayInt)
        context.insert(alarmRepeat)
        try saveContext()
        
        // Then
        XCTAssertEqual(alarmRepeat.weekday, weekdayInt)
    }
    
    func testAlarmRepeatRelationship() throws {
        // Given
        let alarm = createTestAlarm()
        let weekday = Weekday.tuesday
        
        // When
        let alarmRepeat = createTestAlarmRepeat(weekday: weekday, alarm: alarm)
        try saveContext()
        
        // Then
        XCTAssertEqual(alarmRepeat.alarm, alarm)
        XCTAssertTrue(alarm.repeatDays.contains(alarmRepeat))
    }
    
    // MARK: - AlarmTemplate模型测试
    
    func testAlarmTemplateCreation() throws {
        // Given
        let testName = "工作提醒"
        let testCategory = "工作"
        let testScenario = SwiftDataModels.ScenarioType.work
        
        // When
        let template = createTestTemplate(
            name: testName,
            category: testCategory,
            scenario: testScenario
        )
        try saveContext()
        
        // Then
        XCTAssertEqual(template.name, testName)
        XCTAssertEqual(template.category, testCategory)
        XCTAssertEqual(template.scenario, testScenario.rawValue)
        XCTAssertNotNil(template.id)
    }
    
    func testAlarmTemplateSuggestedTime() throws {
        // Given
        let defaultTime = "09:30"
        let template = createTestTemplate(defaultTime: defaultTime)
        
        // When
        let suggestedTime = template.suggestedTime
        
        // Then
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: suggestedTime)
        XCTAssertEqual(components.hour, 9)
        XCTAssertEqual(components.minute, 30)
    }
    
    func testAlarmTemplateScenarioType() throws {
        // Given
        let scenario = SwiftDataModels.ScenarioType.health
        let template = createTestTemplate(scenario: scenario)
        
        // When
        let scenarioType = template.scenarioType
        
        // Then
        XCTAssertEqual(scenarioType, scenario)
    }
    
    func testAlarmTemplateFromLegacy() throws {
        // Given
        let legacyTemplate = LegacyAlarmTemplate(
            id: UUID(),
            name: "旧模板",
            category: "旧分类",
            icon: "🔄",
            description: "旧描述",
            time: "每日",
            frequency: "每日",
            defaultTime: "08:00",
            repeatType: "daily",
            scenario: .study
        )
        
        // When
        let template = SwiftDataModels.AlarmTemplate(from: legacyTemplate)
        context.insert(template)
        try saveContext()
        
        // Then
        XCTAssertEqual(template.name, legacyTemplate.name)
        XCTAssertEqual(template.category, legacyTemplate.category)
        XCTAssertEqual(template.icon, legacyTemplate.icon)
        XCTAssertEqual(template.templateDescription, legacyTemplate.description)
        XCTAssertEqual(template.scenario, legacyTemplate.scenario.rawValue)
    }
    
    // MARK: - 关系测试
    
    func testAlarmTemplateRelationship() throws {
        // Given
        let template = createTestTemplate()
        let alarm1 = createTestAlarm(label: "闹钟1")
        let alarm2 = createTestAlarm(label: "闹钟2")
        
        // When
        alarm1.template = template
        alarm2.template = template
        try saveContext()
        
        // Then
        XCTAssertEqual(alarm1.template, template)
        XCTAssertEqual(alarm2.template, template)
        XCTAssertTrue(template.alarms.contains(alarm1))
        XCTAssertTrue(template.alarms.contains(alarm2))
        XCTAssertEqual(template.alarms.count, 2)
    }
    
    func testCascadeDeleteAlarmRepeat() throws {
        // Given
        let alarm = createTestAlarm()
        let alarmRepeat = createTestAlarmRepeat(weekday: .monday, alarm: alarm)
        try saveContext()
        
        let initialRepeatCount = try getEntityCount(of: AlarmRepeat.self)
        XCTAssertEqual(initialRepeatCount, 1)
        
        // When - 删除闹钟
        context.delete(alarm)
        try saveContext()
        
        // Then - AlarmRepeat应该被级联删除
        let finalRepeatCount = try getEntityCount(of: AlarmRepeat.self)
        XCTAssertEqual(finalRepeatCount, 0)
    }
    
    func testNullifyTemplateRelationship() throws {
        // Given
        let template = createTestTemplate()
        let alarm = createTestAlarm()
        alarm.template = template
        try saveContext()
        
        XCTAssertNotNil(alarm.template)
        
        // When - 删除模板
        context.delete(template)
        try saveContext()
        
        // Then - 闹钟的模板引用应该被设为nil
        XCTAssertNil(alarm.template)
    }
    
    // MARK: - 数据验证测试
    
    func testDataIntegrity() throws {
        // Given
        let alarm = createTestAlarmWithRepeats()
        let (alarmWithTemplate, _) = createTestAlarmWithTemplate()
        try saveContext()
        
        // When & Then
        XCTAssertNoThrow(try validateDataIntegrity())
    }
    
    func testUniqueConstraints() throws {
        // Given
        let id = UUID()
        let alarm1 = Alarm(time: Date(), label: "闹钟1")
        alarm1.id = id
        let alarm2 = Alarm(time: Date(), label: "闹钟2")
        alarm2.id = id
        
        // When
        context.insert(alarm1)
        context.insert(alarm2)
        
        // Then - 应该抛出唯一约束违反错误
        XCTAssertThrowsError(try saveContext()) { error in
            // 验证是唯一约束错误
            print("Expected unique constraint error: \(error)")
        }
    }
    
    // MARK: - 枚举测试
    
    func testWeekdayEnum() {
        // Test all cases
        XCTAssertEqual(Weekday.allCases.count, 7)
        
        // Test raw values
        XCTAssertEqual(Weekday.sunday.rawValue, 1)
        XCTAssertEqual(Weekday.monday.rawValue, 2)
        XCTAssertEqual(Weekday.saturday.rawValue, 7)
        
        // Test names
        XCTAssertEqual(Weekday.monday.name, "星期一")
        XCTAssertEqual(Weekday.sunday.shortName, "日")
        
        // Test comparison
        XCTAssertLessThan(Weekday.sunday, Weekday.monday)
        XCTAssertGreaterThan(Weekday.saturday, Weekday.friday)
    }
    
    func testScenarioTypeEnum() {
        // Test all cases
        XCTAssertEqual(SwiftDataModels.ScenarioType.allCases.count, 16)
        
        // Test properties
        let workScenario = SwiftDataModels.ScenarioType.work
        XCTAssertEqual(workScenario.title, "工作场景")
        XCTAssertEqual(workScenario.icon, "💼")
        XCTAssertFalse(workScenario.description.isEmpty)
        
        // Test raw values
        XCTAssertEqual(SwiftDataModels.ScenarioType.work.rawValue, "work")
        XCTAssertEqual(SwiftDataModels.ScenarioType.health.rawValue, "health")
    }
    
    // MARK: - 性能测试
    
    func testLargeDataSetCreation() throws {
        // Given
        let alarmCount = 100
        
        // When
        let (_, averageTime, _, _) = measurePerformance {
            for i in 0..<alarmCount {
                _ = createTestAlarm(label: "闹钟 \(i)")
            }
            try saveContext()
        }
        
        // Then
        let finalCount = try getEntityCount(of: Alarm.self)
        XCTAssertEqual(finalCount, alarmCount)
        XCTAssertLessThan(averageTime, 1.0, "创建\(alarmCount)个闹钟应该在1秒内完成")
    }
    
    func testQueryPerformance() throws {
        // Given
        try generateLargeDataSet(alarmCount: 500)
        
        // When
        let (result, averageTime, _, _) = measurePerformance {
            let fetchDescriptor = FetchDescriptor<Alarm>(
                predicate: #Predicate { $0.isEnabled == true },
                sortBy: [SortDescriptor(\.time)]
            )
            return try context.fetch(fetchDescriptor)
        }
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertLessThan(averageTime, 0.1, "查询500个闹钟应该在0.1秒内完成")
    }
}