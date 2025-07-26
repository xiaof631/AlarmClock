//
//  SwiftDataTestBase.swift
//  AlarmClockTests
//
//  Created by user on 25/7/25.
//

import XCTest
import SwiftData
@testable import AlarmClock

// MARK: - SwiftData测试基础类
class SwiftDataTestBase: XCTestCase {
    var container: ModelContainer!
    var context: ModelContext!
    
    override func setUp() {
        super.setUp()
        setupInMemoryContainer()
    }
    
    override func tearDown() {
        cleanupTestData()
        container = nil
        context = nil
        super.tearDown()
    }
    
    // MARK: - 测试容器设置
    
    /// 设置内存数据库容器
    private func setupInMemoryContainer() {
        do {
            let schema = Schema([
                Alarm.self,
                AlarmRepeat.self,
                SwiftDataModels.AlarmTemplate.self
            ])
            
            let configuration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: true,
                allowsSave: true
            )
            
            container = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
            
            context = ModelContext(container)
            context.autosaveEnabled = false
        } catch {
            XCTFail("Failed to create test container: \(error)")
        }
    }
    
    /// 清理测试数据
    private func cleanupTestData() {
        guard let context = context else { return }
        
        do {
            // 删除所有测试数据
            try deleteAllEntities(of: Alarm.self)
            try deleteAllEntities(of: AlarmRepeat.self)
            try deleteAllEntities(of: SwiftDataModels.AlarmTemplate.self)
            
            try context.save()
        } catch {
            print("Failed to cleanup test data: \(error)")
        }
    }
    
    private func deleteAllEntities<T: PersistentModel>(of type: T.Type) throws {
        let fetchDescriptor = FetchDescriptor<T>()
        let entities = try context.fetch(fetchDescriptor)
        for entity in entities {
            context.delete(entity)
        }
    }
    
    // MARK: - 测试数据生成器
    
    /// 创建测试闹钟
    func createTestAlarm(
        time: Date = Date(),
        label: String = "测试闹钟",
        isEnabled: Bool = true,
        sound: String = "默认",
        snoozeEnabled: Bool = true,
        vibrationEnabled: Bool = true
    ) -> Alarm {
        let alarm = Alarm(
            time: time,
            label: label,
            isEnabled: isEnabled,
            sound: sound,
            snoozeEnabled: snoozeEnabled,
            vibrationEnabled: vibrationEnabled
        )
        
        context.insert(alarm)
        return alarm
    }
    
    /// 创建测试重复天数
    func createTestAlarmRepeat(
        weekday: Weekday,
        alarm: Alarm? = nil
    ) -> AlarmRepeat {
        let alarmRepeat = AlarmRepeat(weekday: weekday)
        
        if let alarm = alarm {
            alarmRepeat.alarm = alarm
            alarm.repeatDays.append(alarmRepeat)
        }
        
        context.insert(alarmRepeat)
        return alarmRepeat
    }
    
    /// 创建测试模板
    func createTestTemplate(
        name: String = "测试模板",
        category: String = "测试分类",
        icon: String = "🧪",
        description: String = "测试模板描述",
        time: String = "每日",
        frequency: String = "每日",
        defaultTime: String = "09:00",
        repeatType: String = "daily",
        scenario: SwiftDataModels.ScenarioType = .work
    ) -> SwiftDataModels.AlarmTemplate {
        let template = SwiftDataModels.AlarmTemplate(
            name: name,
            category: category,
            icon: icon,
            templateDescription: description,
            time: time,
            frequency: frequency,
            defaultTime: defaultTime,
            repeatType: repeatType,
            scenario: scenario.rawValue
        )
        
        context.insert(template)
        return template
    }
    
    /// 创建带重复天数的测试闹钟
    func createTestAlarmWithRepeats(
        weekdays: [Weekday] = [.monday, .tuesday, .wednesday, .thursday, .friday]
    ) -> Alarm {
        let alarm = createTestAlarm(label: "工作日闹钟")
        
        for weekday in weekdays {
            _ = createTestAlarmRepeat(weekday: weekday, alarm: alarm)
        }
        
        return alarm
    }
    
    /// 创建带模板的测试闹钟
    func createTestAlarmWithTemplate() -> (Alarm, SwiftDataModels.AlarmTemplate) {
        let template = createTestTemplate()
        let alarm = createTestAlarm(label: "模板闹钟")
        alarm.template = template
        
        return (alarm, template)
    }
    
    // MARK: - 测试辅助方法
    
    /// 保存上下文
    func saveContext() throws {
        try context.save()
    }
    
    /// 获取实体数量
    func getEntityCount<T: PersistentModel>(of type: T.Type) throws -> Int {
        let fetchDescriptor = FetchDescriptor<T>()
        return try context.fetchCount(fetchDescriptor)
    }
    
    /// 获取所有实体
    func getAllEntities<T: PersistentModel>(of type: T.Type) throws -> [T] {
        let fetchDescriptor = FetchDescriptor<T>()
        return try context.fetch(fetchDescriptor)
    }
    
    /// 验证数据完整性
    func validateDataIntegrity() throws {
        // 检查孤立的AlarmRepeat记录
        let allRepeats = try getAllEntities(of: AlarmRepeat.self)
        let orphanedRepeats = allRepeats.filter { $0.alarm == nil }
        XCTAssertTrue(orphanedRepeats.isEmpty, "发现孤立的AlarmRepeat记录: \(orphanedRepeats.count)")
        
        // 检查无效的模板引用
        let allAlarms = try getAllEntities(of: Alarm.self)
        for alarm in allAlarms {
            if let template = alarm.template {
                let templateExists = try getEntityCount(of: SwiftDataModels.AlarmTemplate.self) > 0
                XCTAssertTrue(templateExists, "闹钟引用了不存在的模板")
            }
        }
    }
    
    /// 等待异步操作完成
    func waitForAsyncOperation(timeout: TimeInterval = 5.0, operation: @escaping () async throws -> Void) async throws {
        try await withTimeout(timeout) {
            try await operation()
        }
    }
    
    private func withTimeout<T>(_ timeout: TimeInterval, operation: @escaping () async throws -> T) async throws -> T {
        return try await withThrowingTaskGroup(of: T.self) { group in
            group.addTask {
                try await operation()
            }
            
            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
                throw TestError.timeout
            }
            
            guard let result = try await group.next() else {
                throw TestError.timeout
            }
            
            group.cancelAll()
            return result
        }
    }
}

// MARK: - 测试错误类型
enum TestError: Error {
    case timeout
    case dataIntegrityViolation(String)
    case unexpectedResult(String)
}

// MARK: - 测试断言扩展
extension XCTestCase {
    /// 断言SwiftData错误类型
    func XCTAssertSwiftDataError<T>(
        _ expression: @autoclosure () throws -> T,
        expectedError: SwiftDataError,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        do {
            _ = try expression()
            XCTFail("Expected SwiftDataError but no error was thrown", file: file, line: line)
        } catch let error as SwiftDataError {
            XCTAssertEqual(error, expectedError, message(), file: file, line: line)
        } catch {
            XCTFail("Expected SwiftDataError but got \(type(of: error)): \(error)", file: file, line: line)
        }
    }
    
    /// 断言异步操作成功
    func XCTAssertAsyncNoThrow<T>(
        _ expression: @autoclosure () async throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line
    ) async -> T? {
        do {
            return try await expression()
        } catch {
            XCTFail("Unexpected error: \(error). \(message())", file: file, line: line)
            return nil
        }
    }
    
    /// 断言异步操作抛出错误
    func XCTAssertAsyncThrowsError<T>(
        _ expression: @autoclosure () async throws -> T,
        _ message: @autoclosure () -> String = "",
        file: StaticString = #filePath,
        line: UInt = #line,
        _ errorHandler: (_ error: Error) -> Void = { _ in }
    ) async {
        do {
            _ = try await expression()
            XCTFail("Expected error but none was thrown. \(message())", file: file, line: line)
        } catch {
            errorHandler(error)
        }
    }
}

// MARK: - 性能测试基础类
class SwiftDataPerformanceTestBase: SwiftDataTestBase {
    
    /// 测量操作性能
    func measurePerformance<T>(
        of operation: () throws -> T,
        iterations: Int = 10
    ) -> (result: T?, averageTime: TimeInterval, minTime: TimeInterval, maxTime: TimeInterval) {
        var times: [TimeInterval] = []
        var lastResult: T?
        
        for _ in 0..<iterations {
            let startTime = CFAbsoluteTimeGetCurrent()
            
            do {
                lastResult = try operation()
            } catch {
                XCTFail("Performance test failed: \(error)")
                break
            }
            
            let endTime = CFAbsoluteTimeGetCurrent()
            times.append(endTime - startTime)
        }
        
        let averageTime = times.reduce(0, +) / Double(times.count)
        let minTime = times.min() ?? 0
        let maxTime = times.max() ?? 0
        
        return (lastResult, averageTime, minTime, maxTime)
    }
    
    /// 测量异步操作性能
    func measureAsyncPerformance<T>(
        of operation: () async throws -> T,
        iterations: Int = 10
    ) async -> (result: T?, averageTime: TimeInterval, minTime: TimeInterval, maxTime: TimeInterval) {
        var times: [TimeInterval] = []
        var lastResult: T?
        
        for _ in 0..<iterations {
            let startTime = CFAbsoluteTimeGetCurrent()
            
            do {
                lastResult = try await operation()
            } catch {
                XCTFail("Async performance test failed: \(error)")
                break
            }
            
            let endTime = CFAbsoluteTimeGetCurrent()
            times.append(endTime - startTime)
        }
        
        let averageTime = times.reduce(0, +) / Double(times.count)
        let minTime = times.min() ?? 0
        let maxTime = times.max() ?? 0
        
        return (lastResult, averageTime, minTime, maxTime)
    }
    
    /// 生成大量测试数据
    func generateLargeDataSet(alarmCount: Int = 1000) throws {
        for i in 0..<alarmCount {
            let alarm = createTestAlarm(
                time: Date().addingTimeInterval(TimeInterval(i * 60)),
                label: "测试闹钟 \(i)",
                isEnabled: i % 2 == 0
            )
            
            // 为部分闹钟添加重复天数
            if i % 3 == 0 {
                _ = createTestAlarmRepeat(weekday: .monday, alarm: alarm)
                _ = createTestAlarmRepeat(weekday: .friday, alarm: alarm)
            }
        }
        
        try saveContext()
    }
}