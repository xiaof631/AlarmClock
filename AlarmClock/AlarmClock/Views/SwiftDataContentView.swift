//
//  SwiftDataContentView.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import SwiftUI
import SwiftData

struct SwiftDataContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            SwiftDataAlarmListView()
                .tabItem {
                    Image(systemName: "alarm")
                    Text("闹钟")
                }
                .tag(0)
            
            SwiftDataScenarioSelectionView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("场景")
                }
                .tag(1)
            
            SwiftDataStatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("统计")
                }
                .tag(2)
            
            PerformanceMonitorView()
                .tabItem {
                    Image(systemName: "speedometer")
                    Text("性能")
                }
                .tag(3)
            
            #if DEBUG
            DebugConsoleView()
                .tabItem {
                    Image(systemName: "terminal")
                    Text("调试")
                }
                .tag(4)
            #endif
            
            VersionCompatibilityView()
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("兼容性")
                }
                .tag(5)
        }
        .accentColor(.blue)
    }
}

struct SwiftDataStatisticsView: View {
    @Query private var allAlarms: [Alarm]
    @Query private var enabledAlarms: [Alarm]
    @Query private var allTemplates: [AlarmTemplate]
    
    init() {
        _enabledAlarms = Query(filter: #Predicate { $0.isEnabled == true })
    }
    
    var alarmsByScenario: [String: Int] {
        let scenarios = allAlarms.compactMap { $0.template?.scenario }
        return Dictionary(grouping: scenarios) { $0 }.mapValues { $0.count }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section("闹钟统计") {
                    StatisticRow(title: "总闹钟数", value: "\(allAlarms.count)")
                    StatisticRow(title: "已启用", value: "\(enabledAlarms.count)")
                    StatisticRow(title: "已禁用", value: "\(allAlarms.count - enabledAlarms.count)")
                }
                
                Section("场景分布") {
                    ForEach(alarmsByScenario.keys.sorted(), id: \.self) { scenario in
                        if let scenarioType = ScenarioType(rawValue: scenario),
                           let count = alarmsByScenario[scenario] {
                            HStack {
                                Text(scenarioType.icon)
                                Text(scenarioType.title)
                                Spacer()
                                Text("\(count)")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                Section("模板信息") {
                    StatisticRow(title: "可用模板", value: "\(allTemplates.count)")
                }
                
                Section("按场景查看闹钟") {
                    ForEach(ScenarioType.allCases, id: \.self) { scenario in
                        NavigationLink(destination: ScenarioAlarmsView(scenario: scenario)) {
                            HStack {
                                Text(scenario.icon)
                                Text(scenario.title)
                                Spacer()
                                Text("\(alarmsCount(for: scenario))")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("统计")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func alarmsCount(for scenario: ScenarioType) -> Int {
        return allAlarms.filter { $0.template?.scenario == scenario.rawValue }.count
    }
}

struct StatisticRow: View {
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

struct ScenarioAlarmsView: View {
    let scenario: ScenarioType
    
    @Query private var alarms: [Alarm]
    
    init(scenario: ScenarioType) {
        self.scenario = scenario
        // 简化查询，不使用复杂的可选链式调用
        _alarms = Query(sort: [SortDescriptor(\.time)])
    }
    
    var body: some View {
        List {
            ForEach(filteredAlarms) { alarm in
                SwiftDataAlarmRowView(alarm: alarm)
            }
        }
        .navigationTitle(scenario.title)
        .navigationBarTitleDisplayMode(.large)
    }
    
    private var filteredAlarms: [Alarm] {
        alarms.filter { alarm in
            alarm.template?.scenario == scenario.rawValue
        }
    }
}

#Preview {
    SwiftDataContentViewPreview()
}

struct SwiftDataContentViewPreview: View {
    var body: some View {
        if let container = try? ModelContainer(for: Alarm.self, AlarmRepeat.self, AlarmTemplate.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true)) {
            SwiftDataContentView()
                .modelContainer(container)
        } else {
            Text("Preview Error: Failed to create container")
        }
    }
}