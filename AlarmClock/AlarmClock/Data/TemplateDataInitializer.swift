//
//  TemplateDataInitializer.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import Foundation
import SwiftData

final class TemplateDataInitializer {
    
    // MARK: - 公共方法
    
    /// 初始化模板数据到SwiftData（支持增量更新）
    static func initializeTemplates(in context: ModelContext) async throws {
        print("开始检查模板数据初始化...")
        
        // 获取现有模板数据
        let fetchDescriptor = FetchDescriptor<AlarmTemplate>()
        let existingTemplates = try context.fetch(fetchDescriptor)
        
        // 获取所有应该存在的模板数据
        let allTemplateData = getAllTemplateData()
        
        // 如果没有现有模板，进行全量初始化
        if existingTemplates.isEmpty {
            print("开始全量初始化模板数据...")
            
            var insertedCount = 0
            for templateData in allTemplateData {
                let template = AlarmTemplate(
                    name: templateData.name,
                    category: templateData.category,
                    icon: templateData.icon,
                    templateDescription: templateData.description,
                    time: templateData.time,
                    frequency: templateData.frequency,
                    defaultTime: templateData.defaultTime,
                    repeatType: templateData.repeatType,
                    scenario: templateData.scenario.rawValue
                )
                
                context.insert(template)
                insertedCount += 1
            }
            
            try context.save()
            print("成功全量初始化 \(insertedCount) 个模板到SwiftData")
            return
        }
        
        // 进行增量更新检查
        print("检查模板数据增量更新...")
        
        // 创建现有模板的唯一标识集合（使用名称+场景作为唯一标识）
        let existingTemplateKeys = Set(existingTemplates.map { "\($0.name)_\($0.scenario)" })
        
        // 找出需要新增的模板
        let newTemplates = allTemplateData.filter { templateData in
            let key = "\(templateData.name)_\(templateData.scenario.rawValue)"
            return !existingTemplateKeys.contains(key)
        }
        
        if newTemplates.isEmpty {
            print("模板数据已是最新，无需更新")
            return
        }
        
        print("发现 \(newTemplates.count) 个新模板，开始增量更新...")
        
        // 插入新模板
        var insertedCount = 0
        for templateData in newTemplates {
            let template = AlarmTemplate(
                name: templateData.name,
                category: templateData.category,
                icon: templateData.icon,
                templateDescription: templateData.description,
                time: templateData.time,
                frequency: templateData.frequency,
                defaultTime: templateData.defaultTime,
                repeatType: templateData.repeatType,
                scenario: templateData.scenario.rawValue
            )
            
            context.insert(template)
            insertedCount += 1
            print("新增模板: \(templateData.name) (\(templateData.scenario.rawValue))")
        }
        
        // 保存到数据库
        try context.save()
        print("成功增量更新 \(insertedCount) 个新模板到SwiftData")
    }
    
    /// 更新模板数据（如果有新版本）
    static func updateTemplates(in context: ModelContext) async throws {
        print("开始检查模板数据更新...")
        
        // 直接调用初始化方法，它现在支持增量更新
        try await initializeTemplates(in: context)
        
        print("模板数据更新检查完成")
    }
    
    /// 强制重新初始化所有模板数据（清空后重建）
    static func forceReinitializeTemplates(in context: ModelContext) async throws {
        print("开始强制重新初始化模板数据...")
        
        // 删除所有现有模板
        let fetchDescriptor = FetchDescriptor<AlarmTemplate>()
        let existingTemplates = try context.fetch(fetchDescriptor)
        
        for template in existingTemplates {
            context.delete(template)
        }
        
        print("已删除 \(existingTemplates.count) 个现有模板")
        
        // 获取所有模板数据并重新插入
        let allTemplateData = getAllTemplateData()
        
        var insertedCount = 0
        for templateData in allTemplateData {
            let template = AlarmTemplate(
                name: templateData.name,
                category: templateData.category,
                icon: templateData.icon,
                templateDescription: templateData.description,
                time: templateData.time,
                frequency: templateData.frequency,
                defaultTime: templateData.defaultTime,
                repeatType: templateData.repeatType,
                scenario: templateData.scenario.rawValue
            )
            
            context.insert(template)
            insertedCount += 1
        }
        
        // 保存到数据库
        try context.save()
        print("成功强制重新初始化 \(insertedCount) 个模板到SwiftData")
    }
    
    // MARK: - 私有方法
    
    /// 获取所有模板数据（从 TemplateData 获取）
    private static func getAllTemplateData() -> [TemplateDataStruct] {
        // 直接从 TemplateData 获取所有模板数据
        let allLegacyTemplates = TemplateData.getAllTemplates()
        
        // 转换为 TemplateDataStruct 格式
        return allLegacyTemplates.map { legacyTemplate in
            TemplateDataStruct(
                name: legacyTemplate.name,
                category: legacyTemplate.category,
                icon: legacyTemplate.icon,
                description: legacyTemplate.description,
                time: legacyTemplate.time,
                frequency: legacyTemplate.frequency,
                defaultTime: legacyTemplate.defaultTime,
                repeatType: legacyTemplate.repeatType,
                scenario: legacyTemplate.scenario
            )
        }
    }
    

}

// MARK: - 模板数据结构体
struct TemplateDataStruct {
    let name: String
    let category: String
    let icon: String
    let description: String
    let time: String
    let frequency: String
    let defaultTime: String
    let repeatType: String
    let scenario: ScenarioType
}