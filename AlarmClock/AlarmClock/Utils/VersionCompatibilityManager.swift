//
//  VersionCompatibilityManager.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import Foundation
import SwiftUI
import SwiftData

// MARK: - 版本兼容性管理器
@Observable
final class VersionCompatibilityManager {
    static let shared = VersionCompatibilityManager()
    
    private let userDefaults = UserDefaults.standard
    private let minimumSupportedVersion = "17.0"
    
    // 版本检查结果
    private(set) var isSwiftDataSupported: Bool = false
    private(set) var currentIOSVersion: String = ""
    private(set) var compatibilityStatus: CompatibilityStatus = .checking
    private(set) var recommendedAction: RecommendedAction = .none
    
    private init() {
        checkVersionCompatibility()
    }
    
    // MARK: - 版本检查
    
    /// 检查版本兼容性
    func checkVersionCompatibility() {
        currentIOSVersion = UIDevice.current.systemVersion
        
        // 检查SwiftData支持
        isSwiftDataSupported = checkSwiftDataSupport()
        
        // 确定兼容性状态
        compatibilityStatus = determineCompatibilityStatus()
        
        // 确定推荐操作
        recommendedAction = determineRecommendedAction()
        
        // 记录版本检查结果
        logVersionCheck()
    }
    
    /// 检查SwiftData支持
    private func checkSwiftDataSupport() -> Bool {
        if #available(iOS 17.0, *) {
            return true
        } else {
            return false
        }
    }
    
    /// 确定兼容性状态
    private func determineCompatibilityStatus() -> CompatibilityStatus {
        let currentVersion = parseVersion(currentIOSVersion)
        let minimumVersion = parseVersion(minimumSupportedVersion)
        
        if currentVersion >= minimumVersion {
            return .compatible
        } else if currentVersion >= parseVersion("16.0") {
            return .partiallyCompatible
        } else {
            return .incompatible
        }
    }
    
    /// 确定推荐操作
    private func determineRecommendedAction() -> RecommendedAction {
        switch compatibilityStatus {
        case .compatible:
            return .none
        case .partiallyCompatible:
            return .upgradeRecommended
        case .incompatible:
            return .upgradeRequired
        case .checking:
            return .none
        }
    }
    
    /// 解析版本号
    private func parseVersion(_ versionString: String) -> Version {
        let components = versionString.split(separator: ".").compactMap { Int($0) }
        return Version(
            major: components.count > 0 ? components[0] : 0,
            minor: components.count > 1 ? components[1] : 0,
            patch: components.count > 2 ? components[2] : 0
        )
    }
    
    // MARK: - 功能可用性检查
    
    /// 检查SwiftData功能是否可用
    func isSwiftDataAvailable() -> Bool {
        return isSwiftDataSupported && compatibilityStatus == .compatible
    }
    
    /// 检查高级功能是否可用
    func isAdvancedFeaturesAvailable() -> Bool {
        return isSwiftDataAvailable() && parseVersion(currentIOSVersion) >= parseVersion("17.1")
    }
    
    /// 检查性能优化功能是否可用
    func isPerformanceOptimizationAvailable() -> Bool {
        return isSwiftDataAvailable() && parseVersion(currentIOSVersion) >= parseVersion("17.0")
    }
    
    /// 检查调试功能是否可用
    func isDebugFeaturesAvailable() -> Bool {
        #if DEBUG
        return isSwiftDataAvailable()
        #else
        return false
        #endif
    }
    
    // MARK: - 降级方案
    
    /// 获取降级方案
    func getFallbackStrategy() -> FallbackStrategy {
        if isSwiftDataSupported {
            return .useSwiftData
        } else if parseVersion(currentIOSVersion) >= parseVersion("16.0") {
            return .useCoreData
        } else {
            return .useUserDefaults
        }
    }
    
    /// 应用降级方案
    func applyFallbackStrategy() -> Bool {
        let strategy = getFallbackStrategy()
        
        switch strategy {
        case .useSwiftData:
            // 使用SwiftData（默认）
            return true
            
        case .useCoreData:
            // 降级到CoreData（需要实现）
            showFallbackAlert(
                title: "兼容性提示",
                message: "您的设备不支持最新的数据存储技术，将使用兼容模式。部分高级功能可能不可用。",
                actionTitle: "继续使用"
            )
            return false
            
        case .useUserDefaults:
            // 降级到UserDefaults
            showFallbackAlert(
                title: "版本过低",
                message: "您的iOS版本过低，建议升级到iOS 17.0或更高版本以获得最佳体验。",
                actionTitle: "了解更多"
            )
            return false
        }
    }
    
    // MARK: - 用户提示
    
    /// 显示版本兼容性警告
    func showCompatibilityWarningIfNeeded() {
        guard shouldShowCompatibilityWarning() else { return }
        
        switch recommendedAction {
        case .upgradeRecommended:
            showUpgradeRecommendationAlert()
        case .upgradeRequired:
            showUpgradeRequiredAlert()
        case .none:
            break
        }
        
        // 记录已显示警告
        markCompatibilityWarningShown()
    }
    
    /// 是否应该显示兼容性警告
    private func shouldShowCompatibilityWarning() -> Bool {
        let lastShownVersion = userDefaults.string(forKey: "LastCompatibilityWarningVersion")
        return lastShownVersion != currentIOSVersion && recommendedAction != .none
    }
    
    /// 标记兼容性警告已显示
    private func markCompatibilityWarningShown() {
        userDefaults.set(currentIOSVersion, forKey: "LastCompatibilityWarningVersion")
    }
    
    /// 显示升级推荐提示
    private func showUpgradeRecommendationAlert() {
        showFallbackAlert(
            title: "建议升级",
            message: "检测到您的iOS版本为\(currentIOSVersion)。建议升级到iOS 17.0或更高版本以获得最佳性能和完整功能。",
            actionTitle: "了解如何升级"
        )
    }
    
    /// 显示升级必需提示
    private func showUpgradeRequiredAlert() {
        showFallbackAlert(
            title: "需要升级",
            message: "此应用需要iOS 17.0或更高版本。您当前的版本(\(currentIOSVersion))不受支持。请升级您的设备以继续使用。",
            actionTitle: "升级指南"
        )
    }
    
    /// 显示降级提示
    private func showFallbackAlert(title: String, message: String, actionTitle: String) {
        DispatchQueue.main.async {
            // 这里应该显示系统警告，但在SwiftUI中需要通过状态管理
            print("兼容性提示: \(title) - \(message)")
        }
    }
    
    // MARK: - 升级指导
    
    /// 获取升级指导信息
    func getUpgradeGuidance() -> UpgradeGuidance {
        let currentVersion = parseVersion(currentIOSVersion)
        let targetVersion = parseVersion(minimumSupportedVersion)
        
        if currentVersion < targetVersion {
            return UpgradeGuidance(
                isUpgradeNeeded: true,
                currentVersion: currentIOSVersion,
                targetVersion: minimumSupportedVersion,
                upgradeSteps: getUpgradeSteps(),
                benefits: getUpgradeBenefits(),
                limitations: getCurrentLimitations()
            )
        } else {
            return UpgradeGuidance(
                isUpgradeNeeded: false,
                currentVersion: currentIOSVersion,
                targetVersion: minimumSupportedVersion,
                upgradeSteps: [],
                benefits: [],
                limitations: []
            )
        }
    }
    
    /// 获取升级步骤
    private func getUpgradeSteps() -> [String] {
        return [
            "1. 备份您的设备数据",
            "2. 连接到稳定的Wi-Fi网络",
            "3. 确保设备电量充足（建议50%以上）",
            "4. 前往\"设置\" > \"通用\" > \"软件更新\"",
            "5. 下载并安装iOS更新",
            "6. 重启设备完成更新",
            "7. 重新打开智能闹钟应用"
        ]
    }
    
    /// 获取升级好处
    private func getUpgradeBenefits() -> [String] {
        return [
            "🚀 更快的应用启动速度",
            "💾 更高效的数据存储",
            "🔄 更稳定的数据同步",
            "⚡ 更好的性能表现",
            "🛡️ 增强的数据安全性",
            "✨ 完整的功能体验",
            "🐛 更少的错误和崩溃"
        ]
    }
    
    /// 获取当前版本限制
    private func getCurrentLimitations() -> [String] {
        var limitations: [String] = []
        
        if !isSwiftDataSupported {
            limitations.append("• 无法使用高性能数据存储")
            limitations.append("• 数据同步功能受限")
        }
        
        if !isAdvancedFeaturesAvailable() {
            limitations.append("• 高级查询功能不可用")
            limitations.append("• 批量操作性能较低")
        }
        
        if !isPerformanceOptimizationAvailable() {
            limitations.append("• 性能优化功能不可用")
            limitations.append("• 内存使用可能较高")
        }
        
        return limitations
    }
    
    // MARK: - 日志记录
    
    /// 记录版本检查结果
    private func logVersionCheck() {
        let logMessage = """
        版本兼容性检查结果:
        - iOS版本: \(currentIOSVersion)
        - SwiftData支持: \(isSwiftDataSupported ? "是" : "否")
        - 兼容性状态: \(compatibilityStatus.description)
        - 推荐操作: \(recommendedAction.description)
        - 降级策略: \(getFallbackStrategy().description)
        """
        
        print(logMessage)
        
        // 记录到日志系统
        SwiftDataLogger.shared.logOperation(
            type: .migration,
            entity: "VersionCompatibility",
            operation: "check",
            details: [
                "iosVersion": currentIOSVersion,
                "swiftDataSupported": String(isSwiftDataSupported),
                "compatibilityStatus": compatibilityStatus.rawValue,
                "recommendedAction": recommendedAction.rawValue
            ],
            success: true
        )
    }
}

// MARK: - 支持数据结构

/// 版本结构
struct Version: Comparable {
    let major: Int
    let minor: Int
    let patch: Int
    
    static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        }
        if lhs.minor != rhs.minor {
            return lhs.minor < rhs.minor
        }
        return lhs.patch < rhs.patch
    }
    
    static func == (lhs: Version, rhs: Version) -> Bool {
        return lhs.major == rhs.major && lhs.minor == rhs.minor && lhs.patch == rhs.patch
    }
}

/// 兼容性状态
enum CompatibilityStatus: String, CaseIterable {
    case compatible = "compatible"
    case partiallyCompatible = "partiallyCompatible"
    case incompatible = "incompatible"
    case checking = "checking"
    
    var description: String {
        switch self {
        case .compatible: return "完全兼容"
        case .partiallyCompatible: return "部分兼容"
        case .incompatible: return "不兼容"
        case .checking: return "检查中"
        }
    }
}

/// 推荐操作
enum RecommendedAction: String, CaseIterable {
    case none = "none"
    case upgradeRecommended = "upgradeRecommended"
    case upgradeRequired = "upgradeRequired"
    
    var description: String {
        switch self {
        case .none: return "无需操作"
        case .upgradeRecommended: return "建议升级"
        case .upgradeRequired: return "必须升级"
        }
    }
}

/// 降级策略
enum FallbackStrategy: String, CaseIterable {
    case useSwiftData = "useSwiftData"
    case useCoreData = "useCoreData"
    case useUserDefaults = "useUserDefaults"
    
    var description: String {
        switch self {
        case .useSwiftData: return "使用SwiftData"
        case .useCoreData: return "使用CoreData"
        case .useUserDefaults: return "使用UserDefaults"
        }
    }
}

/// 升级指导信息
struct UpgradeGuidance {
    let isUpgradeNeeded: Bool
    let currentVersion: String
    let targetVersion: String
    let upgradeSteps: [String]
    let benefits: [String]
    let limitations: [String]
}

// MARK: - SwiftUI集成

/// 版本兼容性视图
struct VersionCompatibilityView: View {
    @State private var compatibilityManager = VersionCompatibilityManager.shared
    @State private var showingUpgradeGuidance = false
    
    var body: some View {
        VStack(spacing: 20) {
            // 版本信息
            VStack(alignment: .leading, spacing: 8) {
                Text("系统信息")
                    .font(.headline)
                
                InfoRow(title: "iOS版本", value: compatibilityManager.currentIOSVersion)
                InfoRow(title: "SwiftData支持", value: compatibilityManager.isSwiftDataSupported ? "是" : "否")
                InfoRow(title: "兼容性状态", value: compatibilityManager.compatibilityStatus.description)
            }
            
            // 功能可用性
            VStack(alignment: .leading, spacing: 8) {
                Text("功能可用性")
                    .font(.headline)
                
                FeatureRow(title: "SwiftData存储", available: compatibilityManager.isSwiftDataAvailable())
                FeatureRow(title: "高级功能", available: compatibilityManager.isAdvancedFeaturesAvailable())
                FeatureRow(title: "性能优化", available: compatibilityManager.isPerformanceOptimizationAvailable())
                FeatureRow(title: "调试工具", available: compatibilityManager.isDebugFeaturesAvailable())
            }
            
            // 操作按钮
            if compatibilityManager.recommendedAction != .none {
                Button("查看升级指导") {
                    showingUpgradeGuidance = true
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .sheet(isPresented: $showingUpgradeGuidance) {
            UpgradeGuidanceView()
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

struct FeatureRow: View {
    let title: String
    let available: Bool
    
    var body: some View {
        HStack {
            Image(systemName: available ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(available ? .green : .red)
            Text(title)
            Spacer()
        }
    }
}

/// 升级指导视图
struct UpgradeGuidanceView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var guidance = VersionCompatibilityManager.shared.getUpgradeGuidance()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if guidance.isUpgradeNeeded {
                        // 升级信息
                        VStack(alignment: .leading, spacing: 8) {
                            Text("版本信息")
                                .font(.headline)
                            Text("当前版本: \(guidance.currentVersion)")
                            Text("推荐版本: \(guidance.targetVersion)")
                        }
                        
                        // 升级步骤
                        VStack(alignment: .leading, spacing: 8) {
                            Text("升级步骤")
                                .font(.headline)
                            ForEach(guidance.upgradeSteps, id: \.self) { step in
                                Text(step)
                                    .padding(.leading)
                            }
                        }
                        
                        // 升级好处
                        VStack(alignment: .leading, spacing: 8) {
                            Text("升级好处")
                                .font(.headline)
                            ForEach(guidance.benefits, id: \.self) { benefit in
                                Text(benefit)
                                    .padding(.leading)
                            }
                        }
                        
                        // 当前限制
                        if !guidance.limitations.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("当前版本限制")
                                    .font(.headline)
                                ForEach(guidance.limitations, id: \.self) { limitation in
                                    Text(limitation)
                                        .foregroundColor(.orange)
                                        .padding(.leading)
                                }
                            }
                        }
                    } else {
                        VStack {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                            Text("您的设备完全兼容")
                                .font(.title2)
                                .fontWeight(.medium)
                            Text("可以享受所有功能")
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("升级指导")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    VersionCompatibilityView()
}