//
//  ContentView.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var alarmManager = AlarmManager()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            AlarmListView()
                .environmentObject(alarmManager)
                .tabItem {
                    Image(systemName: "alarm")
                    Text("闹钟")
                }
                .tag(0)
            
            ScenarioSelectionView()
                .environmentObject(alarmManager)
                .tabItem {
                    Image(systemName: "list.bullet.rectangle")
                    Text("场景")
                }
                .tag(1)
        }
        .accentColor(.blue)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
