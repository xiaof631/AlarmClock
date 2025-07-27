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
  @State private var selectedTemplate: AlarmTemplate?
  @State private var showingAddAlarm = false
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

  var body: some View {
    print(
      "🎨 渲染视图 - 场景: \(scenario.rawValue), 模板数量: \(allTemplates.count), 初始化状态: \(isInitializing), 已初始化: \(hasInitialized), 刷新触发器: \(refreshTrigger)"
    )

    return VStack {
      // 在渲染时检查是否需要初始化
      let _ = {
        if allTemplates.isEmpty && !hasInitialized && !isInitializing {
          print("🔄 渲染时触发初始化")
          Task {
            await initializeTemplatesIfNeeded()
          }
        }
      }()

      if isInitializing {
        VStack(spacing: 16) {
          ProgressView()
            .scaleEffect(1.2)
          Text("正在加载模板数据...")
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else if allTemplates.isEmpty {
        if hasInitialized {
          // 初始化完成但没有数据
          VStack(spacing: 16) {
            Image(systemName: "tray")
              .font(.system(size: 48))
              .foregroundColor(.secondary)
            Text("暂无\(scenario.title)模板")
              .font(.headline)
              .foregroundColor(.secondary)
            Text("请稍后再试或联系开发者")
              .font(.caption)
              .foregroundColor(.secondary)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
          // 还未初始化，显示加载状态
          VStack(spacing: 16) {
            ProgressView()
              .scaleEffect(1.2)
            Text("正在初始化模板数据...")
              .foregroundColor(.secondary)
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
      } else {
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
        .searchable(text: $searchText, prompt: "搜索模板")
      }
    }
    .navigationTitle(scenario.title)
    .navigationBarTitleDisplayMode(.large)
    .onAppear {
      print("📱 二级页面出现 - 应该隐藏 TabBar - 场景: \(scenario.rawValue)")
      tabBarVisibility.hide()
    }
    .onDisappear {
      print("📱 二级页面消失 - 场景: \(scenario.rawValue)")
      tabBarVisibility.show()
    }
    .task {
      print("🚀 Task 触发 - 场景: \(scenario.rawValue)")
      await initializeTemplatesIfNeeded()
    }
    .onAppear {
      print("📱 视图出现 - 场景: \(scenario.rawValue)")
      if allTemplates.isEmpty && !hasInitialized && !isInitializing {
        print("🔄 onAppear 触发初始化")
        Task {
          await initializeTemplatesIfNeeded()
        }
      }
    }
    .onChange(of: allTemplates.count) { oldValue, newValue in
      print("📊 模板数量变化: \(oldValue) -> \(newValue)")
      if newValue == 0 && !hasInitialized && !isInitializing {
        print("🔄 onChange 触发初始化")
        Task {
          await initializeTemplatesIfNeeded()
        }
      }
    }
    .sheet(isPresented: $showingAddAlarm) {
      if let template = selectedTemplate {
        SwiftDataAddAlarmView(template: template)
      }
    }
    .alert("错误", isPresented: $showingError) {
      Button("确定") {}
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

  var body: some View {
    VStack(spacing: 12) {
      Text(scenario.icon)
        .font(.system(size: 40))

      Text(scenario.title)
        .font(.headline)
        .foregroundColor(.primary)

      Text(scenario.description)
        .font(.caption)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .lineLimit(2)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 120)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(Color(.systemGray6))
    )
    .overlay(
      RoundedRectangle(cornerRadius: 16)
        .stroke(Color(.systemGray4), lineWidth: 1)
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
