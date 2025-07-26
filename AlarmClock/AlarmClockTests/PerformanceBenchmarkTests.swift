//
//  PerformanceBenchmarkTests.swift
//  AlarmClockTests
//
//  Created by user on 25/7/25.
//

import XCTest
import SwiftData
@testable import AlarmClock

final class PerformanceBenchmarkTests: SwiftDataPerformanceTestBase {
    
    // MARK: - 基准测试配置
    
    private let smallDataSetSize = 100
    private let mediumDataSetSize = 500
    private let largeDataSetSize = 1000
    private let performanceThreshold: TimeInterval = 1.0
    
    // MARK: - CRUD操作性能测试
    
    func testInsertPerformance() throws {
        // 测试单个插入性能
        let (_, averageTime, minTime, maxTime) = measurePerformance {
            let alarm = createTestAlarm()
            try saveContext()
            return alarm
        }
        
        XCTAssertLessThan(averageTime, 0.01, "单个闹钟插入应该在10ms内完成")
        print("插入性能 - 平均: \(String(format: "%.4f", averageTime))s, 最快: \(String(format: "%.4f", minTime))s, 最慢: \(String(format: "%.4f", maxTime))s")
    }
    
    func testBatchInsertPerformance() throws {
        let (_, averageTime, _, _) = measurePerformance {
            for i in 0..<smallDataSetSize {
                _ = createTestAlarm(label: "批量闹钟 \(i)")
            }
            try saveContext()
        }
        
        XCTAssertLessThan(averageTime, performanceThreshold, "批量插入\(smallDataSetSize)个闹钟应该在\(performanceThreshold)秒内完成")
        print("批量插入\(smallDataSetSize)个闹钟 - 平均耗时: \(String(format: "%.3f", averageTime))s")
    }
    
    func testUpdatePerformance() throws {
        // 准备数据
        let alarms = (0..<smallDataSetSize).map { createTestAlarm(label: "更新测试 \($0)") }
        try saveContext()
        
        // 测试更新性能
        let (_, averageTime, _, _) = measurePerformance {
            for alarm in alarms {
                alarm.label = "已更新 - \(alarm.label)"
                alarm.updateTimestamp()
            }
            try saveContext()
        }
        
        XCTAssertLessThan(averageTime, performanceThreshold, "批量更新\(smallDataSetSize)个闹钟应该在\(performanceThreshold)秒内完成")
        print("批量更新\(smallDataSetSize)个闹钟 - 平均耗时: \(String(format: "%.3f", averageTime))s")
    }
    
    func testDeletePerformance() throws {
        // 准备数据
        let alarms = (0..<smallDataSetSize).map { createTestAlarm(label: "删除测试 \($0)") }
        try saveContext()
        
        // 测试删除性能
        let (_, averageTime, _, _) = measurePerformance {
            for alarm in alarms {
                context.delete(alarm)
            }
            try saveContext()
        }
        
        XCTAssertLessThan(averageTime, performanceThreshold, "批量删除\(smallDataSetSize)个闹钟应该在\(performanceThreshold)秒内完成")
        print("批量删除\(smallDataSetSize)个闹钟 - 平均耗时: \(String(format: "%.3f", averageTime))s")
    }
    
    // MARK: - 查询性能测试
    
    func testSimpleQueryPerformance() throws {
        // 准备数据
        try generateLargeDataSet(alarmCount: mediumDataSetSize)
        
        // 测试简单查询性能
        let (result, averageTime, _, _) = measurePerformance {
            let fetchDescriptor = FetchDescriptor<Alarm>()
            return try context.fetch(fetchDescriptor)
        }
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.count, mediumDataSetSize)
        XCTAssertLessThan(averageTime, 0.1, "查询\(mediumDataSetSize)个闹钟应该在0.1秒内完成")
        print("简单查询\(mediumDataSetSize)个闹钟 - 平均耗时: \(String(format: "%.4f", averageTime))s")
    }
    
    func testFilteredQueryPerformance() throws {
        // 准备数据
        try generateLargeDataSet(alarmCount: mediumDataSetSize)
        
        // 测试过滤查询性能
        let (result, averageTime, _, _) = measurePerformance {
            let fetchDescriptor = FetchDescriptor<Alarm>(
                predicate: #Predicate { $0.isEnabled == true },
                sortBy: [SortDescriptor(\.time)]
            )
            return try context.fetch(fetchDescriptor)
        }
        
        XCTAssertNotNil(result)
        XCTAssertLessThan(averageTime, 0.2, "过滤查询应该在0.2秒内完成")
        print("过滤查询 - 平均耗时: \(String(format: "%.4f", averageTime))s, 结果数: \(result?.count ?? 0)")
    }
    
    func testComplexQueryPerformance() throws {
        // 准备复杂数据
        for i in 0..<mediumDataSetSize {
            let alarm = createTestAlarm(label: "复杂查询测试 \(i)", isEnabled: i % 2 == 0)
            if i % 3 == 0 {
                _ = createTestAlarmRepeat(weekday: .monday, alarm: alarm)
                _ = createTestAlarmRepeat(weekday: .friday, alarm: alarm)
            }
        }
        try saveContext()
        
        // 测试复杂查询性能
        let (result, averageTime, _, _) = measurePerformance {
            let fetchDescriptor = FetchDescriptor<Alarm>(
                predicate: #Predicate { alarm in
                    alarm.isEnabled == true && !alarm.repeatDays.isEmpty
                },
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
            return try context.fetch(fetchDescriptor)
        }
        
        XCTAssertNotNil(result)
        XCTAssertLessThan(averageTime, 0.5, "复杂查询应该在0.5秒内完成")
        print("复杂查询 - 平均耗时: \(String(format: "%.4f", averageTime))s, 结果数: \(result?.count ?? 0)")
    }
    
    func testPaginatedQueryPerformance() throws {
        // 准备数据
        try generateLargeDataSet(alarmCount: largeDataSetSize)
        
        let pageSize = 20
        var totalTime: TimeInterval = 0
        var pageCount = 0
        
        // 测试分页查询性能
        for offset in stride(from: 0, to: largeDataSetSize, by: pageSize) {
            let (result, time, _, _) = measurePerformance(iterations: 1) {
                let fetchDescriptor = FetchDescriptor<Alarm>(
                    sortBy: [SortDescriptor(\.time)]
                )
                fetchDescriptor.fetchOffset = offset
                fetchDescriptor.fetchLimit = pageSize
                return try context.fetch(fetchDescriptor)
            }
            
            totalTime += time
            pageCount += 1
            
            XCTAssertNotNil(result)
            XCTAssertLessThanOrEqual(result?.count ?? 0, pageSize)
        }
        
        let averagePageTime = totalTime / Double(pageCount)
        XCTAssertLessThan(averagePageTime, 0.05, "分页查询平均应该在0.05秒内完成")
        print("分页查询 - 总页数: \(pageCount), 平均每页耗时: \(String(format: "%.4f", averagePageTime))s")
    }
    
    // MARK: - 关系查询性能测试
    
    func testRelationshipQueryPerformance() throws {
        // 准备带关系的数据
        let templates = (0..<10).map { createTestTemplate(name: "模板 \($0)") }
        
        for i in 0..<mediumDataSetSize {
            let alarm = createTestAlarm(label: "关系测试 \(i)")
            alarm.template = templates[i % templates.count]
            
            if i % 2 == 0 {
                _ = createTestAlarmRepeat(weekday: .monday, alarm: alarm)
                _ = createTestAlarmRepeat(weekday: .wednesday, alarm: alarm)
            }
        }
        try saveContext()
        
        // 测试关系查询性能
        let (result, averageTime, _, _) = measurePerformance {
            let fetchDescriptor = FetchDescriptor<Alarm>(
                predicate: #Predicate { alarm in
                    alarm.template != nil && !alarm.repeatDays.isEmpty
                }
            )
            return try context.fetch(fetchDescriptor)
        }
        
        XCTAssertNotNil(result)
        XCTAssertLessThan(averageTime, 0.3, "关系查询应该在0.3秒内完成")
        print("关系查询 - 平均耗时: \(String(format: "%.4f", averageTime))s, 结果数: \(result?.count ?? 0)")
    }
    
    // MARK: - 大数据集性能测试
    
    func testLargeDataSetPerformance() throws {
        // 创建大数据集
        let startTime = CFAbsoluteTimeGetCurrent()
        try generateLargeDataSet(alarmCount: largeDataSetSize)
        let creationTime = CFAbsoluteTimeGetCurrent() - startTime
        
        print("创建\(largeDataSetSize)个闹钟耗时: \(String(format: "%.3f", creationTime))s")
        XCTAssertLessThan(creationTime, 5.0, "创建\(largeDataSetSize)个闹钟应该在5秒内完成")
        
        // 测试大数据集查询性能
        let (_, queryTime, _, _) = measurePerformance(iterations: 5) {
            let fetchDescriptor = FetchDescriptor<Alarm>(
                predicate: #Predicate { $0.isEnabled == true },
                sortBy: [SortDescriptor(\.time)]
            )
            return try context.fetch(fetchDescriptor)
        }
        
        XCTAssertLessThan(queryTime, 0.5, "大数据集查询应该在0.5秒内完成")
        print("大数据集查询 - 平均耗时: \(String(format: "%.4f", queryTime))s")
    }
    
    // MARK: - 内存使用性能测试
    
    func testMemoryUsagePerformance() throws {
        let initialMemory = getMemoryUsage()
        
        // 创建大量数据
        try generateLargeDataSet(alarmCount: largeDataSetSize)
        
        let afterCreationMemory = getMemoryUsage()
        let memoryIncrease = afterCreationMemory - initialMemory
        
        print("创建\(largeDataSetSize)个闹钟后内存增加: \(String(format: "%.2f", memoryIncrease))MB")
        
        // 执行查询操作
        for _ in 0..<10 {
            let fetchDescriptor = FetchDescriptor<Alarm>()
            _ = try context.fetch(fetchDescriptor)
        }
        
        let afterQueriesMemory = getMemoryUsage()
        let queryMemoryIncrease = afterQueriesMemory - afterCreationMemory
        
        print("执行10次查询后内存增加: \(String(format: "%.2f", queryMemoryIncrease))MB")
        
        // 验证内存使用合理
        XCTAssertLessThan(memoryIncrease, 50.0, "创建\(largeDataSetSize)个闹钟的内存增加应该少于50MB")
        XCTAssertLessThan(queryMemoryIncrease, 10.0, "查询操作的内存增加应该少于10MB")
    }
    
    // MARK: - 并发性能测试
    
    func testConcurrentReadPerformance() async throws {
        // 准备数据
        try generateLargeDataSet(alarmCount: mediumDataSetSize)
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        // 并发读取测试
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask { [weak self] in
                    guard let self = self else { return }
                    
                    do {
                        let fetchDescriptor = FetchDescriptor<Alarm>(
                            predicate: #Predicate { alarm in
                                alarm.label.contains("\(i)")
                            }
                        )
                        _ = try self.context.fetch(fetchDescriptor)
                    } catch {
                        XCTFail("并发读取失败: \(error)")
                    }
                }
            }
        }
        
        let concurrentTime = CFAbsoluteTimeGetCurrent() - startTime
        XCTAssertLessThan(concurrentTime, 2.0, "10个并发读取操作应该在2秒内完成")
        print("并发读取性能 - 10个任务耗时: \(String(format: "%.3f", concurrentTime))s")
    }
    
    // MARK: - 性能回归测试
    
    func testPerformanceRegression() throws {
        // 建立性能基准
        let benchmarks = [
            ("单个插入", 0.01, { try self.measureSingleInsert() }),
            ("批量查询", 0.1, { try self.measureBatchQuery() }),
            ("过滤查询", 0.2, { try self.measureFilteredQuery() }),
            ("关系查询", 0.3, { try self.measureRelationshipQuery() })
        ]
        
        var results: [(String, TimeInterval)] = []
        
        for (name, threshold, operation) in benchmarks {
            let (_, averageTime, _, _) = measurePerformance(iterations: 5) {
                return try operation()
            }
            
            results.append((name, averageTime))
            XCTAssertLessThan(averageTime, threshold, "\(name)性能回归：耗时\(String(format: "%.4f", averageTime))s 超过阈值\(threshold)s")
        }
        
        // 输出性能报告
        print("\n=== 性能基准测试报告 ===")
        for (name, time) in results {
            print("\(name): \(String(format: "%.4f", time))s")
        }
        print("========================\n")
    }
    
    // MARK: - 辅助测试方法
    
    private func measureSingleInsert() throws {
        let alarm = createTestAlarm()
        try saveContext()
        return alarm
    }
    
    private func measureBatchQuery() throws -> [Alarm] {
        if try getEntityCount(of: Alarm.self) < smallDataSetSize {
            try generateLargeDataSet(alarmCount: smallDataSetSize)
        }
        
        let fetchDescriptor = FetchDescriptor<Alarm>()
        return try context.fetch(fetchDescriptor)
    }
    
    private func measureFilteredQuery() throws -> [Alarm] {
        if try getEntityCount(of: Alarm.self) < smallDataSetSize {
            try generateLargeDataSet(alarmCount: smallDataSetSize)
        }
        
        let fetchDescriptor = FetchDescriptor<Alarm>(
            predicate: #Predicate { $0.isEnabled == true }
        )
        return try context.fetch(fetchDescriptor)
    }
    
    private func measureRelationshipQuery() throws -> [Alarm] {
        // 确保有关系数据
        if try getEntityCount(of: SwiftDataModels.AlarmTemplate.self) == 0 {
            let template = createTestTemplate()
            let alarm = createTestAlarm()
            alarm.template = template
            try saveContext()
        }
        
        let fetchDescriptor = FetchDescriptor<Alarm>(
            predicate: #Predicate { $0.template != nil }
        )
        return try context.fetch(fetchDescriptor)
    }
    
    private func getMemoryUsage() -> Double {
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
        
        if kerr == KERN_SUCCESS {
            return Double(info.resident_size) / 1024.0 / 1024.0 // 转换为MB
        } else {
            return 0.0
        }
    }
    
    // MARK: - 性能测试配置
    
    override func setUp() {
        super.setUp()
        // 性能测试专用设置
        continueAfterFailure = false
    }
    
    override func tearDown() {
        // 清理大数据集
        super.tearDown()
    }
}