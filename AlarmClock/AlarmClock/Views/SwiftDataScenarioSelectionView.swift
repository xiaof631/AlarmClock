//
//  SwiftDataScenarioSelectionView.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import SwiftData
import SwiftUI

struct SwiftDataScenarioSelectionView: View {
  @Environment(\.modelContext) private var modelContext
  @EnvironmentObject var tabBarVisibility: TabBarVisibility
  @EnvironmentObject private var themeManager: ThemeManager

  let columns = [
    GridItem(.flexible()),
    GridItem(.flexible()),
  ]

  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns: columns, spacing: 16) {
          ForEach(ScenarioType.allCases, id: \.self) { scenario in
            NavigationLink(
              destination: SwiftDataTemplateSelectionView(scenario: scenario)
                .environmentObject(tabBarVisibility)
            ) {
              ScenarioCardContent(scenario: scenario)
            }
            .buttonStyle(PlainButtonStyle())
          }
        }
        .padding()
      }
      .navigationTitle("生活场景")
      .navigationBarTitleDisplayMode(.large)
    }
    .onAppear {
      print("📱 一级页面出现 - 应该显示 TabBar")
      tabBarVisibility.show()
    }
    .onDisappear {
      print("📱 一级页面消失")
    }
    .task {
      // 在主视图中预先初始化所有模板数据
      print("🌟 主视图启动，预先初始化模板数据")
      do {
        try await TemplateDataInitializer.initializeTemplates(in: modelContext)
        print("✅ 主视图模板数据预初始化完成")
      } catch {
        print("❌ 主视图模板数据预初始化失败: \(error)")
      }
    }
  }
}

struct SwiftDataTemplateSelectionView: View {
  let scenario: ScenarioType
  @Environment(\.modelContext) private var modelContext
  @EnvironmentObject var tabBarVisibility: TabBarVisibility
  @EnvironmentObject private var themeManager: ThemeManager

  @State private var searchText = ""
  @State private var errorMessage: String?
  @State private var showingError = false
  @State private var isInitializing = false
  @State private var hasInitialized = false
  @State private var refreshTrigger = 0

  @Query private var allTemplates: [AlarmTemplate]

  init(scenario: ScenarioType) {
    print("🏗️ 初始化 SwiftDataTemplateSelectionView - 场景: \(scenario.rawValue)")
    self.scenario = scenario
    let predicate = #Predicate<AlarmTemplate> { template in
      template.scenario == scenario.rawValue
    }
    _allTemplates = Query(
      filter: predicate, sort: [SortDescriptor(\.category), SortDescriptor(\.name)])
  }

  var filteredTemplates: [AlarmTemplate] {
    if searchText.isEmpty {
      return allTemplates
    } else {
      return allTemplates.filter { template in
        template.name.localizedCaseInsensitiveContains(searchText)
          || template.templateDescription.localizedCaseInsensitiveContains(searchText)
          || template.category.localizedCaseInsensitiveContains(searchText)
      }
    }
  }

  var groupedTemplates: [String: [AlarmTemplate]] {
    Dictionary(grouping: filteredTemplates) { $0.category }
  }

  @MainActor
  private func initializeTemplatesIfNeeded() async {
    print("🔍 开始检查模板初始化 - 场景: \(scenario.rawValue)")
    print("📊 当前模板数量: \(allTemplates.count)")
    print("🔄 初始化状态: isInitializing=\(isInitializing), hasInitialized=\(hasInitialized)")

    // 如果已经有模板数据，直接返回
    if !allTemplates.isEmpty {
      print("✅ 已有模板数据，无需初始化")
      hasInitialized = true
      return
    }

    // 如果正在初始化，避免重复初始化
    if isInitializing {
      print("⏳ 正在初始化中，跳过")
      return
    }

    print("🚀 开始初始化模板数据")
    isInitializing = true

    do {
      // 尝试初始化模板数据
      try await TemplateDataInitializer.initializeTemplates(in: modelContext)
      print("✅ 模板数据初始化完成")

      // 等待更长时间让 SwiftData 更新查询结果
      for i in 1...10 {
        try await Task.sleep(nanoseconds: 100_000_000)  // 0.1秒
        print("📊 等待第\(i)次，当前模板数量: \(allTemplates.count)")
        if !allTemplates.isEmpty {
          break
        }
      }

      hasInitialized = true
      refreshTrigger += 1  // 强制刷新视图
    } catch {
      print("❌ 模板数据初始化失败: \(error)")
      errorMessage = "模板数据初始化失败: \(error.localizedDescription)"
      showingError = true
      hasInitialized = true
    }

    isInitializing = false
    refreshTrigger += 1  // 强制刷新视图
    print("🏁 初始化流程结束，最终模板数量: \(allTemplates.count)")
  }

  // 分解复杂视图为计算属性
  @ViewBuilder
  private var contentView: some View {
    if isInitializing {
      loadingView
    } else if allTemplates.isEmpty {
      emptyStateView
    } else {
      templateListView
    }
  }
  
  @ViewBuilder
  private var loadingView: some View {
    VStack(spacing: 16) {
      ProgressView()
        .scaleEffect(1.2)
      Text("正在加载模板数据...")
        .themedForeground(.secondaryText)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
  
  @ViewBuilder
  private var emptyStateView: some View {
    if hasInitialized {
      VStack(spacing: 16) {
        Image(systemName: "tray")
          .font(.system(size: 48))
          .themedForeground(.secondaryText)
        Text("暂无\(scenario.title)模板")
          .font(.headline)
          .themedForeground(.secondaryText)
        Text("请稍后再试或联系开发者")
          .font(.caption)
          .themedForeground(.secondaryText)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    } else {
      VStack(spacing: 16) {
        ProgressView()
          .scaleEffect(1.2)
        Text("正在初始化模板数据...")
          .themedForeground(.secondaryText)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
  
  @ViewBuilder
  private var templateListView: some View {
    List {
      ForEach(groupedTemplates.keys.sorted(), id: \.self) { category in
        Section(header: Text(category)) {
          ForEach(groupedTemplates[category] ?? []) { template in
            NavigationLink(
              destination: SwiftDataAddAlarmView(template: template)
            ) {
              SwiftDataTemplateRowView(template: template)
            }
          }
        }
      }
    }
    .searchable(text: $searchText, prompt: "搜索模板")
  }

  var body: some View {
    let _ = print(
      "🎨 渲染视图 - 场景: \(scenario.rawValue), 模板数量: \(allTemplates.count), 初始化状态: \(isInitializing), 已初始化: \(hasInitialized), 刷新触发器: \(refreshTrigger)"
    )
    
    let _ = checkInitializationNeeded()
    
    return contentView
      .navigationTitle(scenario.title)
      .navigationBarTitleDisplayMode(.large)
      .onAppear(perform: handleViewAppear)
      .onDisappear(perform: handleViewDisappear)
      .task { await handleTask() }
      .onChange(of: allTemplates.count) { (oldValue: Int, newValue: Int) in
         handleTemplateCountChange(oldValue: oldValue, newValue: newValue)
       }
      .alert("错误", isPresented: $showingError) {
        Button("确定") {}
      } message: {
        Text(errorMessage ?? "未知错误")
      }
  }
  
  // 分解方法
  private func checkInitializationNeeded() {
    if allTemplates.isEmpty && !hasInitialized && !isInitializing {
      print("🔄 渲染时触发初始化")
      Task {
        await initializeTemplatesIfNeeded()
      }
    }
  }
  
  private func handleViewAppear() {
    print("📱 二级页面出现 - 应该隐藏 TabBar - 场景: \(scenario.rawValue)")
    tabBarVisibility.hide()
    
    if allTemplates.isEmpty && !hasInitialized && !isInitializing {
      print("🔄 onAppear 触发初始化")
      Task {
        await initializeTemplatesIfNeeded()
      }
    }
  }
  
  private func handleViewDisappear() {
    print("📱 二级页面消失 - 场景: \(scenario.rawValue)")
    tabBarVisibility.show()
  }
  
  private func handleTask() async {
    print("🚀 Task 触发 - 场景: \(scenario.rawValue)")
    await initializeTemplatesIfNeeded()
  }
  
  private func handleTemplateCountChange(oldValue: Int, newValue: Int) {
    print("📊 模板数量变化: \(oldValue) -> \(newValue)")
    if newValue == 0 && !hasInitialized && !isInitializing {
      print("🔄 onChange 触发初始化")
      Task {
        await initializeTemplatesIfNeeded()
      }
    }
  }
}

struct SwiftDataTemplateRowView: View {
  let template: AlarmTemplate

  var body: some View {
    HStack(spacing: 12) {
      templateIcon
      templateInfo
      Spacer()
    }
    .padding(.vertical, 4)
  }
  
  private var templateIcon: some View {
    Text(template.icon)
      .font(.title2)
      .frame(width: 40, height: 40)
      .background(Color(.systemGray6))
      .clipShape(Circle())
  }
  
  private var templateInfo: some View {
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
  }
  

}

struct ScenarioCard: View {
  let scenario: ScenarioType
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      ScenarioCardContent(scenario: scenario)
    }
    .buttonStyle(PlainButtonStyle())
  }
}

struct ScenarioCardContent: View {
  let scenario: ScenarioType
  @EnvironmentObject private var themeManager: ThemeManager

  var body: some View {
    VStack(spacing: 12) {
      Text(scenario.icon)
        .font(.system(size: 40))

      Text(scenario.title)
        .font(.headline)
        .themedForeground(.primaryText)

      Text(scenario.description)
        .font(.caption)
        .themedForeground(.secondaryText)
        .multilineTextAlignment(.center)
        .lineLimit(2)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 120)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(ThemeColorProvider.getColor(for: .cardBackground, theme: themeManager.currentTheme))
    )
    .overlay(
      RoundedRectangle(cornerRadius: 16)
        .stroke(ThemeColorProvider.getColor(for: .separatorColor, theme: themeManager.currentTheme), lineWidth: 1)
    )
  }
}

#Preview {
  SwiftDataScenarioSelectionViewPreview()
}



struct SwiftDataScenarioSelectionViewPreview: View {
  @State private var isTabBarHidden = false
  
  var body: some View {
    if let container = try? ModelContainer(
      for: Alarm.self, AlarmRepeat.self, AlarmTemplate.self,
      configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    {
      SwiftDataScenarioSelectionView()
        .modelContainer(container)
        .environmentObject(TabBarVisibility(isHidden: $isTabBarHidden))
    } else {
      Text("Preview Error: Failed to create ModelContainer")
    }
  }
}
