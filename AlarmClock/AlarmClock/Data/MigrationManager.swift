//
//  MigrationManager.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import Foundation
import SwiftData

// MARK: - 迁移错误类型
enum MigrationError: LocalizedError {
    case invalidLegacyData
    case migrationFailed(Error)
    case dataCorruption
    
    var errorDescription: String? {
        switch self {
        case .invalidLegacyData:
            return "无效的旧数据格式"
        case .migrationFailed(let error):
            return "数据迁移失败: \(error.localizedDescription)"
        case .dataCorruption:
            return "数据损坏，无法迁移"
        }
    }
}

// MARK: - 迁移管理器
final class MigrationManager {
    
    // MARK: - 公共方法
    
    /// 从UserDefaults迁移到SwiftData
    static func migrateFromUserDefaults(to context: ModelContext) async throws {
        print("开始检查是否需要数据迁移...")
        
        guard hasLegacyData() else {
            print("未发现旧数据，跳过迁移")
            return
        }
        
        print("发现旧数据，开始迁移...")
        
        do {
            // 读取旧数据
            guard let data = UserDefaults.standard.data(forKey: "SavedAlarms"),
                  let legacyAlarms = try? JSONDecoder().decode([LegacyAlarm].self, from: data) else {
                throw MigrationError.invalidLegacyData
            }
            
            print("成功读取 \(legacyAlarms.count) 个旧闹钟数据")
            
            // 转换并保存数据
            var migratedCount = 0
            for legacyAlarm in legacyAlarms {
                do {
                    let newAlarm = try convertLegacyAlarm(legacyAlarm, context: context)
                    context.insert(newAlarm)
                    migratedCount += 1
                } catch {
                    print("迁移闹钟失败: \(error.localizedDescription)")
                    // 继续处理其他闹钟，不中断整个迁移过程
                }
            }
            
            // 保存到SwiftData
            try context.save()
            print("成功迁移 \(migratedCount) 个闹钟到SwiftData")
            
            // 验证迁移结果
            try await validateMigration(context: context, expectedCount: migratedCount)
            
            // 清理旧数据
            cleanupLegacyData()
            print("数据迁移完成，已清理旧数据")
            
        } catch {
            print("数据迁移失败: \(error.localizedDescription)")
            throw MigrationError.migrationFailed(error)
        }
    }
    
    /// 检查是否有旧数据
    static func hasLegacyData() -> Bool {
        return UserDefaults.standard.data(forKey: "SavedAlarms") != nil
    }
    
    /// 清理旧数据
    static func cleanupLegacyData() {
        UserDefaults.standard.removeObject(forKey: "SavedAlarms")
        UserDefaults.standard.synchronize()
    }
    
    // MARK: - 私有方法
    
    /// 转换旧闹钟数据
    private static func convertLegacyAlarm(_ legacyAlarm: LegacyAlarm, context: ModelContext) throws -> Alarm {
        // 创建新的Alarm实例
        let newAlarm = Alarm(
            time: legacyAlarm.time,
            label: legacyAlarm.label,
            isEnabled: legacyAlarm.isEnabled,
            sound: legacyAlarm.sound,
            snoozeEnabled: legacyAlarm.snoozeEnabled,
            vibrationEnabled: legacyAlarm.vibrationEnabled
        )
        
        // 转换重复天数
        for weekday in legacyAlarm.repeatDays {
            let alarmRepeat = AlarmRepeat(weekday: weekday)
            alarmRepeat.alarm = newAlarm
            newAlarm.repeatDays.append(alarmRepeat)
        }
        
        // 处理模板关联（如果存在）
        if let legacyTemplate = legacyAlarm.template {
            // 查找或创建对应的模板
            let template = try findOrCreateTemplate(from: legacyTemplate, context: context)
            newAlarm.template = template
        }
        
        return newAlarm
    }
    
    /// 查找或创建模板
    private static func findOrCreateTemplate(from legacyTemplate: LegacyAlarmTemplate, context: ModelContext) throws -> AlarmTemplate {
        // 首先尝试查找现有模板
        let fetchDescriptor = FetchDescriptor<AlarmTemplate>(
            predicate: #Predicate { template in
                template.name == legacyTemplate.name && 
                template.scenario == legacyTemplate.scenario.rawValue
            }
        )
        
        if let existingTemplate = try context.fetch(fetchDescriptor).first {
            return existingTemplate
        }
        
        // 如果不存在，创建新模板
        let newTemplate = AlarmTemplate(from: legacyTemplate)
        context.insert(newTemplate)
        return newTemplate
    }
    
    /// 验证迁移结果
    private static func validateMigration(context: ModelContext, expectedCount: Int) async throws {
        let fetchDescriptor = FetchDescriptor<Alarm>()
        let migratedAlarms = try context.fetch(fetchDescriptor)
        
        guard migratedAlarms.count >= expectedCount else {
            throw MigrationError.dataCorruption
        }
        
        print("迁移验证通过: 期望 \(expectedCount) 个，实际 \(migratedAlarms.count) 个闹钟")
    }
}

// MARK: - 扩展LegacyAlarmTemplate的便利初始化
extension AlarmTemplate {
    convenience init(from legacyTemplate: LegacyAlarmTemplate) {
        self.init(
            name: legacyTemplate.name,
            category: legacyTemplate.category,
            icon: legacyTemplate.icon,
            templateDescription: legacyTemplate.description,
            time: legacyTemplate.time,
            frequency: legacyTemplate.frequency,
            defaultTime: legacyTemplate.defaultTime,
            repeatType: legacyTemplate.repeatType,
            scenario: legacyTemplate.scenario.rawValue
        )
    }
}