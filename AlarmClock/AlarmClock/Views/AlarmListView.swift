//
//  AlarmListView.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import SwiftUI

struct AlarmListView: View {
    @EnvironmentObject var alarmManager: AlarmManager
    @State private var showingAddAlarm = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(alarmManager.alarms) { alarm in
                    AlarmRowView(alarm: alarm)
                        .environmentObject(alarmManager)
                }
                .onDelete(perform: deleteAlarms)
            }
            .navigationTitle("我的闹钟")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddAlarm = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddAlarm) {
                AddAlarmView()
                    .environmentObject(alarmManager)
            }
        }
    }
    
    private func deleteAlarms(offsets: IndexSet) {
        for index in offsets {
            let alarm = alarmManager.alarms[index]
            alarmManager.deleteAlarm(alarm)
        }
    }
}

struct AlarmRowView: View {
    let alarm: Alarm
    @EnvironmentObject var alarmManager: AlarmManager
    
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
                            .foregroundColor(.secondary)
                    }
                }
                
                if !alarm.repeatDays.isEmpty {
                    Text(formatRepeatDays(alarm.repeatDays))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                if let template = alarm.template {
                    HStack {
                        Text(template.icon)
                        Text(template.name)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            Spacer()
            
            Toggle("", isOn: Binding(
                get: { alarm.isEnabled },
                set: { newValue in
                    alarmManager.toggleAlarm(alarm, enabled: newValue)
                }
            ))
            .labelsHidden()
        }
        .padding(.vertical, 4)
        .opacity(alarm.isEnabled ? 1.0 : 0.6)
    }
    
    private func formatRepeatDays(_ days: [Weekday]) -> String {
        if days.count == 7 {
            return "每天"
        } else if days.count == 5 && !days.contains(.saturday) && !days.contains(.sunday) {
            return "工作日"
        } else if days.count == 2 && days.contains(.saturday) && days.contains(.sunday) {
            return "周末"
        } else {
            return days.map { $0.shortName }.joined(separator: " ")
        }
    }
}

#Preview {
    AlarmListView()
        .environmentObject(AlarmManager())
}