//
//  AlarmClockApp.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import SwiftUI
import SwiftData

@main
struct AlarmClockApp: App {
    let container: ModelContainer
    
    init() {
        do {
            // 使用性能优化的Schema配置
            let schema = PerformanceOptimizer.configureOptimizedSchema()
            
            // 配置ModelContainer with performance optimizations
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                allowsSave: true,
                cloudKitDatabase: .none // 可以根据需要启用CloudKit
            )
            
            container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            
        } catch {
            fatalError("Failed to create ModelContainer: \(error.localizedDescription)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            SwiftDataContentView()
                .modelContainer(container)
                .task {
                    await performInitialSetup()
                }
        }
    }
    
    // 执行初始设置
    @MainActor
    private func performInitialSetup() async {
        // 检查版本兼容性
        let compatibilityManager = VersionCompatibilityManager.shared
        compatibilityManager.checkVersionCompatibility()
        
        // 显示兼容性警告（如果需要）
        compatibilityManager.showCompatibilityWarningIfNeeded()
        
        // 如果SwiftData不可用，应用降级策略
        guard compatibilityManager.applyFallbackStrategy() else {
            print("使用降级策略，部分功能可能不可用")
            return
        }
        
        do {
            // 执行数据迁移
            try await MigrationManager.migrateFromUserDefaults(to: container.mainContext)
            
            // 初始化模板数据
            try await TemplateDataInitializer.initializeTemplates(in: container.mainContext)
            
        } catch {
            print("Initial setup failed: \(error.localizedDescription)")
            
            // 记录初始化失败
            SwiftDataLogger.shared.logOperation(
                type: .migration,
                entity: "AppInitialization",
                operation: "setup",
                success: false,
                error: error
            )
        }
    }
}
