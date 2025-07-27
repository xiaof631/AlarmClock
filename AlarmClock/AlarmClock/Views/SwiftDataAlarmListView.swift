//
//  SwiftDataAlarmListView.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import SwiftUI
import SwiftData

struct SwiftDataAlarmListView: View {
    @Query(sort: \Alarm.time) private var alarms: [Alarm]
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var alarmManager: SwiftDataAlarmManager?
    @State private var showingAddAlarm = false
    @State private var errorMessage: String?
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(alarms) { alarm in
                    SwiftDataAlarmRowView(alarm: alarm)
                }
                .onDelete(perform: deleteAlarms)
            }
            .themedBackground(.listBackground)
            .navigationTitle("我的闹钟")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddAlarm = true
                    }) {
                        Image(systemName: "plus")
                            .themedForeground(.accentColor)
                    }
                }
            }
            .sheet(isPresented: $showingAddAlarm) {
                SwiftDataAddAlarmView()
            }
            .alert("错误", isPresented: $showingError) {
                Button("确定") { }
            } message: {
                Text(errorMessage ?? "未知错误")
            }
            .onAppear {
                setupAlarmManager()
            }
        }
    }
    
    private func setupAlarmManager() {
        let container = modelContext.container
        alarmManager = SwiftDataAlarmManager(modelContext: modelContext, container: container)
    }
    
    private func deleteAlarms(offsets: IndexSet) {
        for index in offsets {
            let alarm = alarms[index]
            do {
                try alarmManager?.deleteAlarm(alarm)
            } catch {
                errorMessage = "删除闹钟失败: \(error.localizedDescription)"
                showingError = true
            }
        }
    }
}

struct SwiftDataAlarmRowView: View {
    let alarm: Alarm
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var alarmManager: SwiftDataAlarmManager?
    @State private var errorMessage: String?
    @State private var showingError = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(alarm.time, style: .time)
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    if !alarm.label.isEmpty {
                        Text(alarm.label)
                            .font(.caption)
                            .themedForeground(.secondaryText)
                    }
                }
                
                if !alarm.repeatDays.isEmpty {
                    Text(alarm.repeatString)
                        .font(.caption)
                        .themedForeground(.secondaryText)
                }
                
                if let template = alarm.template {
                    HStack {
                        Text(template.icon)
                        Text(template.name)
                            .font(.caption)
                            .themedForeground(.linkColor)
                    }
                }
            }
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { alarm.isEnabled },
                set: { newValue in
                    toggleAlarm(enabled: newValue)
                }
            ))
            .labelsHidden()
        }
        .padding(.vertical, 4)
        .opacity(alarm.isEnabled ? 1.0 : 0.6)
        .alert("错误", isPresented: $showingError) {
            Button("确定") { }
        } message: {
            Text(errorMessage ?? "未知错误")
        }
        .onAppear {
            setupAlarmManager()
        }
    }
    
    private func setupAlarmManager() {
        let container = modelContext.container
        alarmManager = SwiftDataAlarmManager(modelContext: modelContext, container: container)
    }
    
    private func toggleAlarm(enabled: Bool) {
        do {
            try alarmManager?.toggleAlarm(alarm, enabled: enabled)
        } catch {
            errorMessage = "切换闹钟状态失败: \(error.localizedDescription)"
            showingError = true
        }
    }
}

#Preview {
    SwiftDataAlarmListViewPreview()
}

struct SwiftDataAlarmListViewPreview: View {
    var body: some View {
        if let container = try? ModelContainer(for: Alarm.self, AlarmRepeat.self, AlarmTemplate.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)) {
            SwiftDataAlarmListView()
                .modelContainer(container)
                .onAppear {
                    // 添加示例数据
                    let context = container.mainContext
                    let sampleAlarm = Alarm(
                        time: Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date(),
                        label: "工作日闹钟"
                    )
                    context.insert(sampleAlarm)
                }
        } else {
            Text("Preview Error: Failed to create ModelContainer")
        }
    }
}