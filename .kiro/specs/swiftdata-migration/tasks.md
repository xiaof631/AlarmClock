# SwiftData迁移实施任务

- [x] 1. 创建SwiftData数据模型
  - 创建基础的SwiftData模型类，替换现有的Codable结构体
  - 定义模型之间的关系和约束
  - _需求: 1.1, 1.2, 1.3, 1.4, 1.5_

- [x] 1.1 实现Alarm SwiftData模型
  - 将现有的Alarm结构体转换为@Model类
  - 添加@Attribute(.unique)标记ID字段
  - 定义与AlarmRepeat和AlarmTemplate的关系
  - 添加createdAt和updatedAt时间戳字段
  - _需求: 1.1, 1.4_

- [x] 1.2 实现AlarmRepeat SwiftData模型
  - 创建新的AlarmRepeat模型来处理重复天数
  - 定义与Alarm的反向关系
  - 使用weekday整数字段替代枚举数组
  - _需求: 1.1, 1.3_

- [x] 1.3 实现AlarmTemplate SwiftData模型
  - 将TemplateData中的AlarmTemplate转换为@Model类
  - 定义与Alarm的一对多关系
  - 添加适当的索引和约束
  - _需求: 1.1, 1.3_

- [x] 2. 配置SwiftData容器和Schema
  - 设置ModelContainer配置
  - 定义Schema版本管理
  - 配置应用入口点的数据容器
  - _需求: 2.1, 2.2, 2.3, 2.4, 2.5_

- [x] 2.1 创建ModelContainer配置
  - 在AlarmClockApp中初始化ModelContainer
  - 配置Schema包含所有模型类
  - 设置数据库存储位置和配置选项
  - 添加错误处理和容器初始化失败的处理
  - _需求: 2.1, 2.2_

- [x] 2.2 配置SwiftUI应用入口
  - 使用.modelContainer修饰符注入容器到视图层次
  - 确保所有视图都能访问ModelContext
  - 添加应用启动时的数据初始化逻辑
  - _需求: 2.4_

- [x] 3. 实现数据迁移系统
  - 创建从UserDefaults到SwiftData的迁移逻辑
  - 实现数据完整性验证
  - 添加迁移错误处理和回滚机制
  - _需求: 5.1, 5.2, 5.3, 5.4, 5.5_

- [x] 3.1 创建MigrationManager类
  - 实现检测旧UserDefaults数据的逻辑
  - 创建数据转换方法将旧格式转换为新模型
  - 添加迁移进度跟踪和错误报告
  - _需求: 5.1, 5.2_

- [x] 3.2 实现数据转换逻辑
  - 编写convertLegacyAlarm方法转换Alarm数据
  - 处理重复天数从Set<Weekday>到AlarmRepeat关系的转换
  - 转换模板引用从字符串到AlarmTemplate关系
  - 保持数据完整性和一致性
  - _需求: 5.2, 5.5_

- [x] 3.3 添加迁移验证和清理
  - 实现迁移后的数据完整性验证
  - 创建清理旧UserDefaults数据的逻辑
  - 添加迁移失败时的数据保护机制
  - _需求: 5.3, 5.4, 5.5_

- [x] 4. 重构AlarmManager使用SwiftData
  - 更新AlarmManager使用ModelContext进行数据操作
  - 移除UserDefaults相关代码
  - 实现新的CRUD操作方法
  - _需求: 3.1, 3.2, 3.3, 3.4, 3.5, 3.6_

- [x] 4.1 重构AlarmManager初始化和依赖
  - 修改AlarmManager构造函数接受ModelContext
  - 移除@Published属性，依赖SwiftData的自动更新
  - 更新为@Observable类以支持SwiftData集成
  - _需求: 3.1_

- [x] 4.2 实现SwiftData CRUD操作
  - 重写addAlarm方法使用context.insert()
  - 重写updateAlarm方法直接修改模型属性
  - 重写deleteAlarm方法使用context.delete()
  - 添加适当的错误处理和save()调用
  - _需求: 3.2, 3.3, 3.4, 3.5_

- [x] 4.3 更新通知管理逻辑
  - 修改scheduleNotification方法适配新的数据模型
  - 更新cancelNotification方法处理关系数据
  - 确保通知ID与SwiftData模型ID一致
  - _需求: 3.6_

- [x] 5. 更新视图层使用SwiftData
  - 重构所有视图使用@Query和@Environment(\.modelContext)
  - 移除对AlarmManager的@EnvironmentObject依赖
  - 实现自动数据更新和响应
  - _需求: 4.1, 4.2, 4.3, 4.4, 4.5_

- [x] 5.1 重构AlarmListView
  - 使用@Query替代@EnvironmentObject获取闹钟列表
  - 使用@Environment(\.modelContext)进行数据操作
  - 实现直接的删除和切换操作
  - 确保列表自动更新响应数据变化
  - _需求: 4.1, 4.2, 4.4_

- [x] 5.2 重构ScenarioSelectionView和TemplateSelectionView
  - 更新模板数据访问使用SwiftData查询
  - 修改模板选择逻辑适配新的数据关系
  - 确保场景和模板数据的正确显示
  - _需求: 4.1, 4.2_

- [x] 5.3 重构AddAlarmView
  - 使用ModelContext直接创建和保存Alarm实例
  - 更新模板应用逻辑使用关系数据
  - 实现重复天数的AlarmRepeat关系创建
  - 添加数据验证和错误处理
  - _需求: 4.2, 4.4_

- [x] 5.4 实现复杂查询视图
  - 创建按场景筛选的闹钟视图
  - 实现使用FetchDescriptor的高级查询
  - 添加搜索和排序功能
  - _需求: 4.1, 4.3_

- [x] 6. 初始化模板数据到SwiftData
  - 将TemplateData中的静态数据迁移到SwiftData
  - 实现模板数据的初始化和更新逻辑
  - 确保模板数据的版本管理
  - _需求: 2.3, 5.2_

- [x] 6.1 创建模板数据初始化器
  - 编写TemplateDataInitializer类
  - 实现检查和创建默认模板数据的逻辑
  - 添加模板数据版本控制和更新机制
  - _需求: 2.3_

- [x] 6.2 集成模板初始化到应用启动
  - 在应用启动时检查并初始化模板数据
  - 确保模板数据只初始化一次
  - 添加模板数据更新和同步逻辑
  - _需求: 5.2_

- [x] 7. 实现性能优化
  - 添加数据库索引和查询优化
  - 实现后台数据操作
  - 优化内存使用和数据加载
  - _需求: 6.1, 6.2, 6.3, 6.4, 6.5_

- [x] 7.1 添加数据库索引优化
  - 为常用查询字段添加索引
  - 优化关系查询性能
  - 实现查询结果缓存策略
  - _需求: 6.3_

- [x] 7.2 实现后台数据操作
  - 创建后台ModelContext用于耗时操作
  - 实现批量数据操作优化
  - 添加数据操作进度跟踪
  - _需求: 6.4_

- [x] 8. 添加错误处理和调试支持
  - 实现全面的错误处理机制
  - 添加数据操作日志和调试工具
  - 创建数据完整性检查工具
  - _需求: 7.1, 7.2, 7.3, 7.4, 7.5_

- [x] 8.1 创建SwiftDataError错误类型
  - 定义所有可能的SwiftData操作错误
  - 实现用户友好的错误消息
  - 添加错误恢复建议和操作
  - _需求: 7.1, 7.4_

- [x] 8.2 实现数据操作日志系统
  - 添加数据CRUD操作的详细日志
  - 实现性能监控和统计
  - 创建调试模式的数据检查工具
  - _需求: 7.2, 7.3_

- [x] 9. 编写单元测试和集成测试
  - 创建SwiftData模型的单元测试
  - 实现数据迁移的集成测试
  - 添加性能基准测试
  - _需求: 8.1, 8.2, 8.3, 8.4, 8.5_

- [x] 9.1 创建SwiftData测试基础设施
  - 设置内存数据库测试配置
  - 创建测试用的ModelContainer和ModelContext
  - 实现测试数据生成和清理工具
  - _需求: 8.1, 8.2_

- [x] 9.2 编写数据模型单元测试
  - 测试Alarm、AlarmRepeat、AlarmTemplate模型
  - 验证模型关系和约束
  - 测试数据验证和完整性
  - _需求: 8.3_

- [x] 9.3 编写数据迁移测试
  - 创建迁移测试场景和数据
  - 验证迁移的正确性和完整性
  - 测试迁移错误处理和回滚
  - _需求: 8.4_

- [x] 9.4 实现性能基准测试
  - 创建大数据量的性能测试
  - 测试查询和数据操作性能
  - 建立性能基准和回归测试
  - _需求: 8.5_

- [x] 10. 更新应用配置和部署准备
  - 更新最低iOS版本要求到17.0
  - 添加SwiftData相关的应用权限和配置
  - 准备版本发布和用户通知
  - _需求: 2.5, 7.5_

- [x] 10.1 更新项目配置
  - 修改Deployment Target到iOS 17.0
  - 更新Info.plist添加数据存储权限
  - 配置App Store发布信息
  - _需求: 2.5_

- [x] 10.2 添加版本兼容性处理
  - 为不支持SwiftData的设备提供降级方案
  - 实现版本检查和功能可用性检测
  - 添加用户升级提示和说明
  - _需求: 7.5_