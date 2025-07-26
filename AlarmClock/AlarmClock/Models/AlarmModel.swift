//
//  AlarmModel.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import Foundation
import SwiftUI

// MARK: - 闹钟数据模型
struct AlarmData: Identifiable, Codable {
    let id: UUID
    var time: Date
    var label: String
    var isEnabled: Bool
    var repeatDays: [Weekday]
    var sound: String
    var snoozeEnabled: Bool
    var vibrationEnabled: Bool
    var template: LegacyAlarmTemplate?
    
    init(id: UUID = UUID(),
         time: Date = Date(), 
         label: String = "闹钟", 
         isEnabled: Bool = true,
         repeatDays: [Weekday] = [],
         sound: String = "默认",
         snoozeEnabled: Bool = true,
         vibrationEnabled: Bool = true,
         template: LegacyAlarmTemplate? = nil) {
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

// Weekday 已在 SwiftDataModels.swift 中定义

// ScenarioType 已在 SwiftDataModels.swift 中定义

// MARK: - 闹钟模板（旧版本，用于兼容）
struct LegacyAlarmTemplate: Identifiable, Codable {
    var id = UUID()
    let name: String
    let category: String
    let icon: String
    let description: String
    let time: String
    let frequency: String
    let defaultTime: String
    let repeatType: String
    let scenario: ScenarioType
    
    init(name: String, category: String, icon: String, description: String, time: String, frequency: String, defaultTime: String, repeatType: String, scenario: ScenarioType) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.icon = icon
        self.description = description
        self.time = time
        self.frequency = frequency
        self.defaultTime = defaultTime
        self.repeatType = repeatType
        self.scenario = scenario
    }
    
    var suggestedTime: Date {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "zh_CN")
        return formatter.date(from: defaultTime) ?? Date()
    }
}