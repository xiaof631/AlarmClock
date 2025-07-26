//
//  SwiftDataAddAlarmView.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import SwiftUI
import SwiftData

struct SwiftDataAddAlarmView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let template: AlarmTemplate?
    
    @State private var selectedTime = Date()
    @State private var label = ""
    @State private var selectedDays: Set<Weekday> = []
    @State private var isEnabled = true
    @State private var selectedSound = "默认"
    @State private var snoozeEnabled = true
    @State private var vibrationEnabled = true
    @State private var errorMessage: String?
    @State private var showingError = false
    
    init(template: AlarmTemplate? = nil) {
        self.template = template
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    DatePicker("时间", selection: $selectedTime, displayedComponents: .hourAndMinute)
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                }
                
                Section("闹钟设置") {
                    HStack {
                        Text("标签")
                        Spacer()
                        TextField("闹钟标签", text: $label)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    if let template = template {
                        HStack {
                            Text("模板")
                            Spacer()
                            HStack {
                                Text(template.icon)
                                Text(template.name)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
                
                Section("重复") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                        ForEach(Weekday.allCases, id: \.self) { day in
                            Button(action: {
                                if selectedDays.contains(day) {
                                    selectedDays.remove(day)
                                } else {
                                    selectedDays.insert(day)
                                }
                            }) {
                                Text(day.shortName)
                                    .font(.caption)
                                    .frame(width: 32, height: 32)
                                    .background(
                                        Circle()
                                            .fill(selectedDays.contains(day) ? Color.blue : Color(.systemGray5))
                                    )
                                    .foregroundColor(selectedDays.contains(day) ? .white : .primary)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    
                    if selectedDays.isEmpty {
                        Text("永不重复")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("选项") {
                    HStack {
                        Text("铃声")
                        Spacer()
                        Text(selectedSound)
                            .foregroundColor(.secondary)
                    }
                    
                    Toggle("稍后提醒", isOn: $snoozeEnabled)
                    Toggle("振动", isOn: $vibrationEnabled)
                }
            }
            .navigationTitle("添加闹钟")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveAlarm()
                    }
                }
            }
        }
        .onAppear {
            setupFromTemplate()
        }
        .alert("错误", isPresented: $showingError) {
            Button("确定") { }
        } message: {
            Text(errorMessage ?? "未知错误")
        }
    }
    
    private func setupFromTemplate() {
        guard let template = template else { return }
        
        label = template.name
        
        // 根据模板设置默认时间
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        if let defaultTime = formatter.date(from: template.defaultTime) {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: defaultTime)
            selectedTime = calendar.date(bySettingHour: components.hour ?? 9, minute: components.minute ?? 0, second: 0, of: Date()) ?? Date()
        }
        
        // 根据重复类型设置重复天数
        switch template.repeatType {
        case "daily":
            selectedDays = Set(Weekday.allCases)
        case "weekdays":
            selectedDays = Set([.monday, .tuesday, .wednesday, .thursday, .friday])
        case "weekly":
            // 默认选择当前星期几
            let today = Calendar.current.component(.weekday, from: Date())
            if let weekday = Weekday.allCases.first(where: { $0.rawValue == today }) {
                selectedDays = [weekday]
            }
        default:
            selectedDays = []
        }
    }
    
    private func saveAlarm() {
        do {
            // 创建新闹钟
            let alarm = Alarm(
                time: selectedTime,
                label: label,
                isEnabled: isEnabled,
                sound: selectedSound,
                snoozeEnabled: snoozeEnabled,
                vibrationEnabled: vibrationEnabled
            )
            
            // 设置模板关联
            alarm.template = template
            
            // 添加重复天数
            for weekday in selectedDays {
                let alarmRepeat = AlarmRepeat(weekday: weekday)
                alarmRepeat.alarm = alarm
                alarm.repeatDays.append(alarmRepeat)
                modelContext.insert(alarmRepeat)
            }
            
            // 保存闹钟
            let alarmManager = SwiftDataAlarmManager(modelContext: modelContext)
            try alarmManager.addAlarm(alarm)
            
            dismiss()
        } catch {
            errorMessage = "保存闹钟失败: \(error.localizedDescription)"
            showingError = true
        }
    }
}

#Preview {
    SwiftDataAddAlarmViewPreview()
}

struct SwiftDataAddAlarmViewPreview: View {
    var body: some View {
        if let container = try? ModelContainer(for: Alarm.self, AlarmRepeat.self, AlarmTemplate.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)) {
            SwiftDataAddAlarmView()
                .modelContainer(container)
        } else {
            Text("Preview Error: Failed to create container")
        }
    }
}