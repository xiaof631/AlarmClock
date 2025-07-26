//
//  SwiftDataError.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import Foundation
import SwiftData

// MARK: - SwiftData错误类型定义
enum SwiftDataError: LocalizedError, Equatable {
    // 数据操作错误
    case insertFailed(String)
    case updateFailed(String)
    case deleteFailed(String)
    case fetchFailed(String)
    case saveFailed(String)
    
    // 数据验证错误
    case validationFailed(field: String, reason: String)
    case constraintViolation(constraint: String, value: String)
    case duplicateEntry(field: String, value: String)
    case invalidRelationship(from: String, to: String)
    
    // 数据迁移错误
    case migrationFailed(reason: String)
    case migrationDataCorrupted(details: String)
    case migrationVersionMismatch(expected: String, actual: String)
    case migrationRollbackFailed(reason: String)
    
    // 数据库配置错误
    case containerInitializationFailed(reason: String)
    case schemaConfigurationError(details: String)
    case contextCreationFailed(reason: String)
    case persistentStoreError(details: String)
    
    // 性能和资源错误
    case memoryPressure(currentUsage: String)
    case queryTimeout(duration: TimeInterval)
    case batchOperationFailed(operation: String, count: Int)
    case cacheError(operation: String, reason: String)
    
    // 数据完整性错误
    case dataCorruption(entity: String, details: String)
    case referentialIntegrityViolation(from: String, to: String)
    case orphanedRecord(entity: String, id: String)
    case inconsistentState(description: String)
    
    // 用户友好的错误描述
    var errorDescription: String? {
        switch self {
        // 数据操作错误
        case .insertFailed(let details):
            return "添加数据失败：\(details)"
        case .updateFailed(let details):
            return "更新数据失败：\(details)"
        case .deleteFailed(let details):
            return "删除数据失败：\(details)"
        case .fetchFailed(let details):
            return "获取数据失败：\(details)"
        case .saveFailed(let details):
            return "保存数据失败：\(details)"
            
        // 数据验证错误
        case .validationFailed(let field, let reason):
            return "数据验证失败：字段'\(field)'不符合要求 - \(reason)"
        case .constraintViolation(let constraint, let value):
            return "数据约束违反：\(constraint)约束不允许值'\(value)'"
        case .duplicateEntry(let field, let value):
            return "数据重复：字段'\(field)'的值'\(value)'已存在"
        case .invalidRelationship(let from, let to):
            return "关系数据无效：从'\(from)'到'\(to)'的关系不正确"
            
        // 数据迁移错误
        case .migrationFailed(let reason):
            return "数据迁移失败：\(reason)"
        case .migrationDataCorrupted(let details):
            return "迁移数据损坏：\(details)"
        case .migrationVersionMismatch(let expected, let actual):
            return "迁移版本不匹配：期望版本\(expected)，实际版本\(actual)"
        case .migrationRollbackFailed(let reason):
            return "迁移回滚失败：\(reason)"
            
        // 数据库配置错误
        case .containerInitializationFailed(let reason):
            return "数据库初始化失败：\(reason)"
        case .schemaConfigurationError(let details):
            return "数据库架构配置错误：\(details)"
        case .contextCreationFailed(let reason):
            return "数据上下文创建失败：\(reason)"
        case .persistentStoreError(let details):
            return "持久化存储错误：\(details)"
            
        // 性能和资源错误
        case .memoryPressure(let currentUsage):
            return "内存压力警告：当前使用量\(currentUsage)"
        case .queryTimeout(let duration):
            return "查询超时：操作耗时\(String(format: "%.2f", duration))秒"
        case .batchOperationFailed(let operation, let count):
            return "批量操作失败：\(operation)操作，影响\(count)条记录"
        case .cacheError(let operation, let reason):
            return "缓存错误：\(operation)操作失败 - \(reason)"
            
        // 数据完整性错误
        case .dataCorruption(let entity, let details):
            return "数据损坏：\(entity)实体 - \(details)"
        case .referentialIntegrityViolation(let from, let to):
            return "引用完整性违反：从\(from)到\(to)的引用无效"
        case .orphanedRecord(let entity, let id):
            return "孤立记录：\(entity)实体的记录\(id)缺少必要的关联"
        case .inconsistentState(let description):
            return "数据状态不一致：\(description)"
        }
    }
    
    // 错误恢复建议
    var recoverySuggestion: String? {
        switch self {
        // 数据操作错误
        case .insertFailed, .updateFailed, .deleteFailed, .saveFailed:
            return "请检查数据格式是否正确，然后重试操作。如果问题持续存在，请重启应用。"
        case .fetchFailed:
            return "请检查网络连接，然后重试。如果问题持续存在，请清理应用缓存。"
            
        // 数据验证错误
        case .validationFailed:
            return "请检查输入的数据是否符合要求，修正后重新提交。"
        case .constraintViolation, .duplicateEntry:
            return "请修改数据以满足约束要求，或选择不同的值。"
        case .invalidRelationship:
            return "请检查相关数据是否存在且有效。"
            
        // 数据迁移错误
        case .migrationFailed, .migrationDataCorrupted:
            return "数据迁移出现问题，建议备份当前数据后重新安装应用。"
        case .migrationVersionMismatch:
            return "应用版本不兼容，请更新到最新版本。"
        case .migrationRollbackFailed:
            return "迁移回滚失败，请联系技术支持。"
            
        // 数据库配置错误
        case .containerInitializationFailed, .schemaConfigurationError, .contextCreationFailed:
            return "数据库配置出现问题，请重启应用。如果问题持续存在，请重新安装应用。"
        case .persistentStoreError:
            return "存储系统出现问题，请检查设备存储空间，然后重启应用。"
            
        // 性能和资源错误
        case .memoryPressure:
            return "设备内存不足，请关闭其他应用释放内存，然后重试。"
        case .queryTimeout:
            return "操作超时，请检查设备性能和数据量，然后重试。"
        case .batchOperationFailed:
            return "批量操作失败，建议分批处理或减少操作数量。"
        case .cacheError:
            return "缓存出现问题，请清理应用缓存后重试。"
            
        // 数据完整性错误
        case .dataCorruption, .referentialIntegrityViolation, .orphanedRecord, .inconsistentState:
            return "数据完整性出现问题，建议备份数据后重置应用数据。"
        }
    }
    
    // 错误严重程度
    var severity: ErrorSeverity {
        switch self {
        case .insertFailed, .updateFailed, .deleteFailed, .fetchFailed, .saveFailed:
            return .medium
        case .validationFailed, .constraintViolation, .duplicateEntry:
            return .low
        case .invalidRelationship:
            return .medium
        case .migrationFailed, .migrationDataCorrupted, .migrationVersionMismatch:
            return .high
        case .migrationRollbackFailed:
            return .critical
        case .containerInitializationFailed, .schemaConfigurationError, .contextCreationFailed:
            return .critical
        case .persistentStoreError:
            return .high
        case .memoryPressure, .queryTimeout:
            return .medium
        case .batchOperationFailed, .cacheError:
            return .low
        case .dataCorruption, .referentialIntegrityViolation, .orphanedRecord, .inconsistentState:
            return .high
        }
    }
    
    // 是否需要用户干预
    var requiresUserIntervention: Bool {
        switch self {
        case .validationFailed, .constraintViolation, .duplicateEntry:
            return true
        case .migrationFailed, .migrationDataCorrupted, .migrationVersionMismatch:
            return true
        case .memoryPressure:
            return true
        case .dataCorruption, .inconsistentState:
            return true
        default:
            return false
        }
    }
    
    // 是否可以自动重试
    var canRetry: Bool {
        switch self {
        case .insertFailed, .updateFailed, .deleteFailed, .fetchFailed, .saveFailed:
            return true
        case .queryTimeout, .batchOperationFailed:
            return true
        case .cacheError:
            return true
        case .migrationRollbackFailed, .containerInitializationFailed, .schemaConfigurationError:
            return false
        default:
            return false
        }
    }
}

// MARK: - 错误严重程度枚举
enum ErrorSeverity: Int, CaseIterable {
    case low = 1
    case medium = 2
    case high = 3
    case critical = 4
    
    var description: String {
        switch self {
        case .low: return "轻微"
        case .medium: return "中等"
        case .high: return "严重"
        case .critical: return "致命"
        }
    }
    
    var color: String {
        switch self {
        case .low: return "green"
        case .medium: return "yellow"
        case .high: return "orange"
        case .critical: return "red"
        }
    }
}

// MARK: - 错误处理工具类
final class SwiftDataErrorHandler {
    static let shared = SwiftDataErrorHandler()
    
    private init() {}
    
    // 错误日志记录
    func logError(_ error: SwiftDataError, context: String = "", file: String = #file, function: String = #function, line: Int = #line) {
        let timestamp = DateFormatter.logFormatter.string(from: Date())
        let fileName = (file as NSString).lastPathComponent
        
        let logMessage = """
        [SwiftData Error] \(timestamp)
        Severity: \(error.severity.description)
        Context: \(context)
        Location: \(fileName):\(line) in \(function)
        Error: \(error.localizedDescription)
        Recovery: \(error.recoverySuggestion ?? "无建议")
        Can Retry: \(error.canRetry)
        Requires User Intervention: \(error.requiresUserIntervention)
        ---
        """
        
        print(logMessage)
        
        // 在调试模式下，严重错误触发断言
        #if DEBUG
        if error.severity == .critical {
            assertionFailure("Critical SwiftData error occurred: \(error.localizedDescription)")
        }
        #endif
    }
    
    // 处理错误并返回用户友好的消息
    func handleError(_ error: Error, context: String = "") -> SwiftDataError {
        let swiftDataError: SwiftDataError
        
        if let sdError = error as? SwiftDataError {
            swiftDataError = sdError
        } else {
            // 将系统错误转换为SwiftDataError
            swiftDataError = convertSystemError(error)
        }
        
        logError(swiftDataError, context: context)
        return swiftDataError
    }
    
    // 转换系统错误为SwiftDataError
    private func convertSystemError(_ error: Error) -> SwiftDataError {
        let errorDescription = error.localizedDescription.lowercased()
        
        if errorDescription.contains("save") {
            return .saveFailed(error.localizedDescription)
        } else if errorDescription.contains("fetch") {
            return .fetchFailed(error.localizedDescription)
        } else if errorDescription.contains("insert") {
            return .insertFailed(error.localizedDescription)
        } else if errorDescription.contains("delete") {
            return .deleteFailed(error.localizedDescription)
        } else if errorDescription.contains("constraint") {
            return .constraintViolation("未知约束", error.localizedDescription)
        } else if errorDescription.contains("duplicate") {
            return .duplicateEntry("未知字段", error.localizedDescription)
        } else if errorDescription.contains("memory") {
            return .memoryPressure("未知")
        } else if errorDescription.contains("timeout") {
            return .queryTimeout(0)
        } else {
            return .inconsistentState(error.localizedDescription)
        }
    }
    
    // 创建用户友好的错误提示
    func createUserAlert(for error: SwiftDataError) -> (title: String, message: String, actions: [String]) {
        let title: String
        let message: String
        var actions = ["确定"]
        
        switch error.severity {
        case .low:
            title = "提示"
            message = error.localizedDescription
        case .medium:
            title = "注意"
            message = "\(error.localizedDescription)\n\n\(error.recoverySuggestion ?? "")"
            if error.canRetry {
                actions.insert("重试", at: 0)
            }
        case .high:
            title = "错误"
            message = "\(error.localizedDescription)\n\n\(error.recoverySuggestion ?? "")"
            if error.canRetry {
                actions.insert("重试", at: 0)
            }
            actions.append("获取帮助")
        case .critical:
            title = "严重错误"
            message = "\(error.localizedDescription)\n\n\(error.recoverySuggestion ?? "")\n\n如果问题持续存在，请联系技术支持。"
            actions = ["重启应用", "联系支持"]
        }
        
        return (title, message, actions)
    }
}

// MARK: - 扩展DateFormatter用于日志
extension DateFormatter {
    static let logFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter
    }()
}

// MARK: - 错误处理协议
protocol SwiftDataErrorHandling {
    func handleSwiftDataError(_ error: SwiftDataError, context: String)
}

// MARK: - 默认错误处理实现
extension SwiftDataErrorHandling {
    func handleSwiftDataError(_ error: SwiftDataError, context: String = "") {
        SwiftDataErrorHandler.shared.logError(error, context: context)
    }
}