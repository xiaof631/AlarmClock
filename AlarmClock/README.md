# AlarmClock - iOS 闹钟应用

基于SwiftUI开发的iOS闹钟应用，支持16个生活场景和96+个闹钟模板。

## 项目结构

```
AlarmClock/
├── AlarmClock/
│   ├── Models/
│   │   └── AlarmModel.swift          # 数据模型
│   ├── ViewModels/
│   │   └── AlarmManager.swift        # 视图模型
│   ├── Views/
│   │   ├── AlarmListView.swift       # 闹钟列表视图
│   │   ├── ScenarioSelectionView.swift # 场景选择视图
│   │   ├── TemplateSelectionView.swift # 模板选择视图
│   │   └── AddAlarmView.swift        # 添加闹钟视图
│   ├── Data/
│   │   └── TemplateData.swift        # 模板数据
│   ├── ContentView.swift             # 主视图
│   └── AlarmClockApp.swift          # 应用入口
```

## 功能特性

### ✅ 已完成功能

1. **数据模型**
   - 闹钟数据结构 (Alarm)
   - 星期枚举 (Weekday)
   - 场景类型 (ScenarioType)
   - 闹钟模板 (AlarmTemplate)

2. **16个生活场景**
   - 💼 工作场景 - 会议管理、任务提醒、休息调整
   - 📚 学习场景 - 课程管理、考试作业、自主学习
   - ❤️ 健康运动 - 日常健康、药物提醒、运动锻炼
   - 🏠 家庭生活 - 家务管理、儿童照顾、宠物护理
   - 🍳 厨房烹饪 - 食材准备、烹饪计时、烘焙活动
   - 🚗 交通出行 - 日常通勤、长途旅行、车辆维护
   - 👥 社交活动 - 社交约会、人际维护、社交礼仪
   - 💆 个人护理 - 日常清洁、皮肤护理、美容美发
   - 🎮 休闲娱乐 - 数字娱乐、户外活动、文化娱乐
   - 🎉 特殊场合 - 节日庆典、重要时刻、纪念活动
   - 💰 财务管理 - 投资理财、预算控制、税务合规
   - 📱 数字健康 - 屏幕时间、内容创作、网络安全
   - 🎨 兴趣爱好 - 阅读计划、乐器练习、园艺创作
   - 🏘️ 社区邻里 - 社区活动、邻里互助、环保行动
   - 🛡️ 安全防护 - 安全检查、紧急联系、天气预警
   - 🌟 个人成长 - 自我反思、目标管理、心理健康

3. **96+个闹钟模板**
   - 每个场景包含6-11个精心设计的模板
   - 涵盖各种重复类型：单次、每日、每周、每月等
   - 预设合理的默认时间和标签

4. **用户界面**
   - TabView主界面，包含闹钟列表和场景选择
   - 闹钟列表支持开关切换、删除操作
   - 场景选择采用网格布局，直观展示各场景
   - 模板选择按分类组织，支持搜索功能
   - 添加闹钟界面支持时间选择、重复设置等

5. **数据管理**
   - 使用UserDefaults进行数据持久化
   - ObservableObject模式实现数据绑定
   - 支持闹钟的增删改查操作

6. **通知系统**
   - 集成iOS本地通知
   - 支持单次和重复闹钟
   - 自动权限请求和管理

## 技术栈

- **开发语言**: Swift
- **UI框架**: SwiftUI
- **架构模式**: MVVM
- **数据持久化**: UserDefaults
- **通知系统**: UserNotifications Framework
- **最低支持版本**: iOS 18.5

## 编译状态

✅ 项目编译成功，可以在iOS模拟器上运行

## 使用说明

1. 打开应用后，可以看到两个主要标签页：
   - **闹钟**: 显示所有已创建的闹钟
   - **场景**: 选择生活场景和模板

2. 添加闹钟：
   - 在闹钟页面点击"+"按钮直接添加
   - 或在场景页面选择场景→选择模板→自动填充信息

3. 管理闹钟：
   - 滑动删除不需要的闹钟
   - 使用开关快速启用/禁用闹钟

## 下一步开发建议

1. **UI优化**
   - 添加深色模式适配
   - 优化动画效果
   - 添加haptic反馈

2. **功能扩展**
   - 支持自定义铃声
   - 添加稍后提醒功能
   - 支持闹钟分组管理

3. **数据同步**
   - 集成iCloud同步
   - 支持数据导入导出

4. **智能功能**
   - 基于位置的智能提醒
   - 天气相关的闹钟调整
   - 使用习惯分析和建议