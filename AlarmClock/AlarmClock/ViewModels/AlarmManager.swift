//
//  AlarmManager.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import Foundation
import SwiftUI
import UserNotifications

class AlarmManager: ObservableObject {
    @Published var alarms: [AlarmData] = []
    @Published var templates: [ScenarioType: [LegacyAlarmTemplate]] = [:]
    
    init() {
        loadAlarms()
        loadTemplates()
        requestNotificationPermission()
    }
    
    // MARK: - 闹钟管理
    func addAlarm(_ alarm: AlarmData) {
        alarms.append(alarm)
        saveAlarms()
        scheduleNotification(for: alarm)
    }
    
    func updateAlarm(_ alarm: AlarmData) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index] = alarm
            saveAlarms()
            scheduleNotification(for: alarm)
        }
    }
    
    func deleteAlarm(_ alarm: AlarmData) {
        alarms.removeAll { $0.id == alarm.id }
        saveAlarms()
        cancelNotification(for: alarm)
    }
    
    func toggleAlarm(_ alarm: AlarmData) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index].isEnabled.toggle()
            saveAlarms()
            
            if alarms[index].isEnabled {
                scheduleNotification(for: alarms[index])
            } else {
                cancelNotification(for: alarms[index])
            }
        }
    }
    
    func toggleAlarm(_ alarm: AlarmData, enabled: Bool) {
        if let index = alarms.firstIndex(where: { $0.id == alarm.id }) {
            alarms[index].isEnabled = enabled
            saveAlarms()
            
            if alarms[index].isEnabled {
                scheduleNotification(for: alarms[index])
            } else {
                cancelNotification(for: alarms[index])
            }
        }
    }
    
    // MARK: - 数据持久化
    private func saveAlarms() {
        if let encoded = try? JSONEncoder().encode(alarms) {
            UserDefaults.standard.set(encoded, forKey: "SavedAlarms")
        }
    }
    
    private func loadAlarms() {
        if let data = UserDefaults.standard.data(forKey: "SavedAlarms"),
           let decoded = try? JSONDecoder().decode([AlarmData].self, from: data) {
            alarms = decoded
        } else {
            // 添加示例闹钟
            alarms = [
                AlarmData(
                    time: Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date(),
                    label: "工作日闹钟",
                    repeatDays: [.monday, .tuesday, .wednesday, .thursday, .friday]
                ),
                AlarmData(
                    time: Calendar.current.date(bySettingHour: 22, minute: 30, second: 0, of: Date()) ?? Date(),
                    label: "睡前提醒",
                    isEnabled: false,
                    repeatDays: Array(Weekday.allCases)
                ),
                AlarmData(
                    time: Calendar.current.date(bySettingHour: 6, minute: 30, second: 0, of: Date()) ?? Date(),
                    label: "晨练",
                    repeatDays: [.saturday, .sunday]
                )
            ]
        }
    }
    
    // MARK: - 通知管理
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("通知权限请求失败: \(error)")
            }
        }
    }
    
    private func scheduleNotification(for alarm: AlarmData) {
        guard alarm.isEnabled else { return }
        
        let center = UNUserNotificationCenter.current()
        
        // 取消现有通知
        center.removePendingNotificationRequests(withIdentifiers: [alarm.id.uuidString])
        
        // 创建通知内容
        let content = UNMutableNotificationContent()
        content.title = "闹钟"
        content.body = alarm.label
        content.sound = .default
        content.categoryIdentifier = "ALARM_CATEGORY"
        
        // 设置通知时间
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: alarm.time)
        let minute = calendar.component(.minute, from: alarm.time)
        
        if alarm.repeatDays.isEmpty {
            // 单次闹钟
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = minute
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: alarm.id.uuidString, content: content, trigger: trigger)
            
            center.add(request) { error in
                if let error = error {
                    print("添加通知失败: \(error)")
                }
            }
        } else {
            // 重复闹钟
            for weekday in alarm.repeatDays {
                var dateComponents = DateComponents()
                dateComponents.hour = hour
                dateComponents.minute = minute
                dateComponents.weekday = weekday.rawValue
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let identifier = "\(alarm.id.uuidString)_\(weekday.rawValue)"
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error = error {
                        print("添加重复通知失败: \(error)")
                    }
                }
            }
        }
    }
    
    private func cancelNotification(for alarm: AlarmData) {
        let center = UNUserNotificationCenter.current()
        
        if alarm.repeatDays.isEmpty {
            center.removePendingNotificationRequests(withIdentifiers: [alarm.id.uuidString])
        } else {
            let identifiers = alarm.repeatDays.map { "\(alarm.id.uuidString)_\($0.rawValue)" }
            center.removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    // MARK: - 模板管理
    private func loadTemplates() {
        for scenario in ScenarioType.allCases {
            templates[scenario] = TemplateData.getTemplates(for: scenario)
        }
    }
    
    func getTemplates(for scenario: ScenarioType) -> [LegacyAlarmTemplate] {
        return templates[scenario] ?? []
    }
    
    func createAlarmFromTemplate(_ template: LegacyAlarmTemplate) -> AlarmData {
        let calendar = Calendar.current
        let now = Date()
        
        // 解析模板的默认时间
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let templateTime = timeFormatter.date(from: template.defaultTime) ?? now
        
        // 设置为今天的对应时间
        let alarmTime = calendar.date(bySettingHour: calendar.component(.hour, from: templateTime),
                                     minute: calendar.component(.minute, from: templateTime),
                                     second: 0,
                                     of: now) ?? now
        
        // 根据模板类型设置重复
        var repeatDays: [Weekday] = []
        switch template.repeatType {
        case "daily":
            repeatDays = Array(Weekday.allCases)
        case "weekdays":
            repeatDays = [.monday, .tuesday, .wednesday, .thursday, .friday]
        case "weekly":
            repeatDays = [Weekday(rawValue: calendar.component(.weekday, from: now)) ?? .monday]
        case "monthly", "yearly", "quarterly":
            repeatDays = []
        default:
            repeatDays = []
        }
        
        return AlarmData(
            time: alarmTime,
            label: template.name,
            repeatDays: repeatDays,
            template: template
        )
    }
    
    // MARK: - 辅助方法
    var nextAlarm: AlarmData? {
        let enabledAlarms = alarms.filter { $0.isEnabled }
        guard !enabledAlarms.isEmpty else { return nil }
        
        let calendar = Calendar.current
        let now = Date()
        
        var nextAlarmTime: Date?
        var nextAlarm: AlarmData?
        
        for alarm in enabledAlarms {
            let alarmTime = getNextAlarmTime(for: alarm, from: now)
            
            if nextAlarmTime == nil || alarmTime < nextAlarmTime! {
                nextAlarmTime = alarmTime
                nextAlarm = alarm
            }
        }
        
        return nextAlarm
    }
    
    private func getNextAlarmTime(for alarm: AlarmData, from date: Date) -> Date {
        let calendar = Calendar.current
        let alarmHour = calendar.component(.hour, from: alarm.time)
        let alarmMinute = calendar.component(.minute, from: alarm.time)
        
        if alarm.repeatDays.isEmpty {
            // 单次闹钟
            let alarmTime = calendar.date(bySettingHour: alarmHour, minute: alarmMinute, second: 0, of: date) ?? date
            return alarmTime > date ? alarmTime : calendar.date(byAdding: .day, value: 1, to: alarmTime) ?? alarmTime
        } else {
            // 重复闹钟
            let currentWeekday = Weekday(rawValue: calendar.component(.weekday, from: date)) ?? .monday
            let currentTime = calendar.date(bySettingHour: alarmHour, minute: alarmMinute, second: 0, of: date) ?? date
            
            // 检查今天是否有闹钟且还没过时间
            if alarm.repeatDays.contains(currentWeekday) && currentTime > date {
                return currentTime
            }
            
            // 找下一个闹钟日期
            for i in 1...7 {
                let nextDate = calendar.date(byAdding: .day, value: i, to: date) ?? date
                let nextWeekday = Weekday(rawValue: calendar.component(.weekday, from: nextDate)) ?? .monday
                
                if alarm.repeatDays.contains(nextWeekday) {
                    return calendar.date(bySettingHour: alarmHour, minute: alarmMinute, second: 0, of: nextDate) ?? nextDate
                }
            }
            
            return currentTime
        }
    }
}