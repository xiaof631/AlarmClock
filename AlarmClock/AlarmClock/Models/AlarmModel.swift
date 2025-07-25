//
//  AlarmModel.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import Foundation
import SwiftUI

// MARK: - 闹钟数据模型
struct Alarm: Identifiable, Codable {
    let id: UUID
    var time: Date
    var label: String
    var isEnabled: Bool
    var repeatDays: [Weekday]
    var sound: String
    var snoozeEnabled: Bool
    var vibrationEnabled: Bool
    var template: AlarmTemplate?
    
    init(id: UUID = UUID(),
         time: Date = Date(), 
         label: String = "闹钟", 
         isEnabled: Bool = true,
         repeatDays: [Weekday] = [],
         sound: String = "默认",
         snoozeEnabled: Bool = true,
         vibrationEnabled: Bool = true,
         template: AlarmTemplate? = nil) {
        self.id = id
        self.time = time
        self.label = label
        self.isEnabled = isEnabled
        self.repeatDays = repeatDays
        self.sound = sound
        self.snoozeEnabled = snoozeEnabled
        self.vibrationEnabled = vibrationEnabled
        self.template = template
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.string(from: time)
    }
    
    var repeatString: String {
        if repeatDays.isEmpty {
            return "永不"
        } else if repeatDays.count == 7 {
            return "每天"
        } else if Set(repeatDays) == Set([.monday, .tuesday, .wednesday, .thursday, .friday]) {
            return "工作日"
        } else if Set(repeatDays) == Set([.saturday, .sunday]) {
            return "周末"
        } else {
            return repeatDays.sorted().map { $0.shortName }.joined(separator: " ")
        }
    }
}

// MARK: - 星期枚举
enum Weekday: Int, CaseIterable, Codable, Comparable {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
    
    var name: String {
        switch self {
        case .sunday: return "星期日"
        case .monday: return "星期一"
        case .tuesday: return "星期二"
        case .wednesday: return "星期三"
        case .thursday: return "星期四"
        case .friday: return "星期五"
        case .saturday: return "星期六"
        }
    }
    
    var shortName: String {
        switch self {
        case .sunday: return "日"
        case .monday: return "一"
        case .tuesday: return "二"
        case .wednesday: return "三"
        case .thursday: return "四"
        case .friday: return "五"
        case .saturday: return "六"
        }
    }
    
    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

// MARK: - 场景类型
enum ScenarioType: String, CaseIterable, Codable {
    case work = "work"
    case study = "study"
    case health = "health"
    case family = "family"
    case cooking = "cooking"
    case transport = "transport"
    case social = "social"
    case personal = "personal"
    case entertainment = "entertainment"
    case special = "special"
    case finance = "finance"
    case digital = "digital"
    case hobby = "hobby"
    case community = "community"
    case safety = "safety"
    case growth = "growth"
    
    var title: String {
        switch self {
        case .work: return "工作场景"
        case .study: return "学习场景"
        case .health: return "健康运动"
        case .family: return "家庭生活"
        case .cooking: return "厨房烹饪"
        case .transport: return "交通出行"
        case .social: return "社交活动"
        case .personal: return "个人护理"
        case .entertainment: return "休闲娱乐"
        case .special: return "特殊场合"
        case .finance: return "财务管理"
        case .digital: return "数字健康"
        case .hobby: return "兴趣爱好"
        case .community: return "社区邻里"
        case .safety: return "安全防护"
        case .growth: return "个人成长"
        }
    }
    
    var icon: String {
        switch self {
        case .work: return "💼"
        case .study: return "📚"
        case .health: return "❤️"
        case .family: return "🏠"
        case .cooking: return "🍳"
        case .transport: return "🚗"
        case .social: return "👥"
        case .personal: return "💆"
        case .entertainment: return "🎮"
        case .special: return "🎉"
        case .finance: return "💰"
        case .digital: return "📱"
        case .hobby: return "🎨"
        case .community: return "🏘️"
        case .safety: return "🛡️"
        case .growth: return "🌟"
        }
    }
    
    var description: String {
        switch self {
        case .work: return "会议管理、任务提醒、休息调整"
        case .study: return "课程管理、考试作业、自主学习"
        case .health: return "日常健康、药物提醒、运动锻炼"
        case .family: return "家务管理、儿童照顾、宠物护理"
        case .cooking: return "食材准备、烹饪计时、烘焙活动"
        case .transport: return "日常通勤、长途旅行、车辆维护"
        case .social: return "社交约会、人际维护、社交礼仪"
        case .personal: return "日常清洁、皮肤护理、美容美发"
        case .entertainment: return "数字娱乐、户外活动、文化娱乐"
        case .special: return "节日庆典、重要时刻、纪念活动"
        case .finance: return "投资理财、预算控制、税务合规"
        case .digital: return "屏幕时间、内容创作、网络安全"
        case .hobby: return "阅读计划、乐器练习、园艺创作"
        case .community: return "社区活动、邻里互助、环保行动"
        case .safety: return "安全检查、紧急联系、天气预警"
        case .growth: return "自我反思、目标管理、心理健康"
        }
    }
}

// MARK: - 闹钟模板
struct AlarmTemplate: Identifiable, Codable {
    let id = UUID()
    let name: String
    let category: String
    let icon: String
    let description: String
    let time: String
    let frequency: String
    let defaultTime: String
    let repeatType: String
    let scenario: ScenarioType
    
    var suggestedTime: Date {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.date(from: defaultTime) ?? Date()
    }
}