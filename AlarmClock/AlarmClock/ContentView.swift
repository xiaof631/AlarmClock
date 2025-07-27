//
//  ContentView.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var alarmManager = AlarmManager()
    @StateObject private var themeManager = ThemeManager()
    @State private var selectedTab = 0
    
    var body: some View {
        ThemeAwareView { theme in
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
            .accentColor(theme.accentColor)
            .background(theme.primaryBackground)
        }
        .environmentObject(themeManager)
        .preferredColorScheme(themeManager.currentTheme.colorScheme)
    }
}

#Preview {
    ContentView()
}
