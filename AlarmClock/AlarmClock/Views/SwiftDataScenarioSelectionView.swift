//
//  SwiftDataScenarioSelectionView.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import SwiftUI
import SwiftData

struct SwiftDataScenarioSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedScenario: ScenarioType?
    @State private var showingTemplates = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(ScenarioType.allCases, id: \.self) { scenario in
                        ScenarioCard(scenario: scenario) {
                            selectedScenario = scenario
                            showingTemplates = true
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("生活场景")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingTemplates) {
            if let scenario = selectedScenario {
                SwiftDataTemplateSelectionView(scenario: scenario)
            }
        }
    }
}

struct SwiftDataTemplateSelectionView: View {
    let scenario: ScenarioType
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTemplate: AlarmTemplate?
    @State private var showingAddAlarm = false
    @State private var searchText = ""
    @State private var errorMessage: String?
    @State private var showingError = false
    
    @Query private var allTemplates: [AlarmTemplate]
    
    init(scenario: ScenarioType) {
        self.scenario = scenario
        let predicate = #Predicate<AlarmTemplate> { template in
            template.scenario == scenario.rawValue
        }
        _allTemplates = Query(filter: predicate, sort: [SortDescriptor(\.category), SortDescriptor(\.name)])
    }
    
    var filteredTemplates: [AlarmTemplate] {
        if searchText.isEmpty {
            return allTemplates
        } else {
            return allTemplates.filter { template in
                template.name.localizedCaseInsensitiveContains(searchText) ||
                template.templateDescription.localizedCaseInsensitiveContains(searchText) ||
                template.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var groupedTemplates: [String: [AlarmTemplate]] {
        Dictionary(grouping: filteredTemplates) { $0.category }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedTemplates.keys.sorted(), id: \.self) { category in
                    Section(header: Text(category)) {
                        ForEach(groupedTemplates[category] ?? []) { template in
                            SwiftDataTemplateRowView(template: template) {
                                selectedTemplate = template
                                showingAddAlarm = true
                            }
                        }
                    }
                }
            }
            .navigationTitle(scenario.title)
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "搜索模板")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddAlarm) {
            if let template = selectedTemplate {
                SwiftDataAddAlarmView(template: template)
                    .onDisappear {
                        dismiss()
                    }
            }
        }
        .alert("错误", isPresented: $showingError) {
            Button("确定") { }
        } message: {
            Text(errorMessage ?? "未知错误")
        }
    }
}

struct SwiftDataTemplateRowView: View {
    let template: AlarmTemplate
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(template.icon)
                    .font(.title2)
                    .frame(width: 40, height: 40)
                    .background(Color(.systemGray6))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(template.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(template.templateDescription)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack {
                        Label(template.time, systemImage: "clock")
                        Label(template.frequency, systemImage: "repeat")
                    }
                    .font(.caption2)
                    .foregroundColor(.blue)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Alarm.self, AlarmRepeat.self, AlarmTemplate.self, configurations: config)
        
        return SwiftDataScenarioSelectionView()
            .modelContainer(container)
    } catch {
        return Text("Preview Error: \(error.localizedDescription)")
    }
}