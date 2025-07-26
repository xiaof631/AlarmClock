//
//  TemplateSelectionView.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import SwiftUI

struct TemplateSelectionView: View {
    let scenario: ScenarioType
    @EnvironmentObject var alarmManager: AlarmManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTemplate: LegacyAlarmTemplate?
    @State private var showingAddAlarm = false
    @State private var searchText = ""
    
    var templates: [LegacyAlarmTemplate] {
        let allTemplates = TemplateData.getTemplates(for: scenario)
        if searchText.isEmpty {
            return allTemplates
        } else {
            return allTemplates.filter { template in
                template.name.localizedCaseInsensitiveContains(searchText) ||
                template.description.localizedCaseInsensitiveContains(searchText) ||
                template.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var groupedTemplates: [String: [LegacyAlarmTemplate]] {
        Dictionary(grouping: templates) { $0.category }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(groupedTemplates.keys.sorted(), id: \.self) { category in
                    Section(header: Text(category)) {
                        ForEach(groupedTemplates[category] ?? []) { template in
                            TemplateRowView(template: template) {
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
                AddAlarmView(template: template)
                    .environmentObject(alarmManager)
                    .onDisappear {
                        dismiss()
                    }
            }
        }
    }
}

struct TemplateRowView: View {
    let template: LegacyAlarmTemplate
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
                    
                    Text(template.description)
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
    TemplateSelectionView(scenario: .work)
        .environmentObject(AlarmManager())
}