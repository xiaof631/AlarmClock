//
//  ScenarioSelectionView.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import SwiftUI

struct ScenarioSelectionView: View {
    @EnvironmentObject var alarmManager: AlarmManager
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
                TemplateSelectionView(scenario: scenario)
                    .environmentObject(alarmManager)
            }
        }
    }
}

//struct ScenarioCard: View {
//    let scenario: ScenarioType
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            VStack(spacing: 12) {
//                Text(scenario.icon)
//                    .font(.system(size: 40))
//                
//                Text(scenario.title)
//                    .font(.headline)
//                    .foregroundColor(.primary)
//                
//                Text(scenario.description)
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                    .multilineTextAlignment(.center)
//                    .lineLimit(2)
//            }
//            .frame(maxWidth: .infinity)
//            .frame(height: 120)
//            .background(
//                RoundedRectangle(cornerRadius: 16)
//                    .fill(Color(.systemGray6))
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 16)
//                    .stroke(Color(.systemGray4), lineWidth: 1)
//            )
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}

#Preview {
    ScenarioSelectionView()
        .environmentObject(AlarmManager())
}
