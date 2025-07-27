//
//  TemplateData.swift
//  AlarmClock
//
//  Created by user on 25/7/25.
//

import Foundation

// MARK: - 模板数据管理
class TemplateData {
  static let shared = TemplateData()

  private init() {}

  // MARK: - 工作场景模板
  static let workTemplates: [LegacyAlarmTemplate] = [
    // 会议管理
    LegacyAlarmTemplate(
      name: "会议提醒",
      category: "会议管理",
      icon: "📅",
      description: "支持设置会议开始前15分钟、30分钟、1小时等多种提前提醒",
      time: "提前15分钟",
      frequency: "单次",
      defaultTime: "09:00",
      repeatType: "none",
      scenario: .work
    ),
    LegacyAlarmTemplate(
      name: "会议进行中计时",
      category: "会议管理",
      icon: "⏱️",
      description: "提供会议计时功能，帮助控制会议时长",
      time: "会议期间",
      frequency: "计时",
      defaultTime: "09:00",
      repeatType: "timer",
      scenario: .work
    ),
    LegacyAlarmTemplate(
      name: "会议结束提醒",
      category: "会议管理",
      icon: "⏰",
      description: "在会议预定结束时间前5分钟提醒",
      time: "结束前5分钟",
      frequency: "单次",
      defaultTime: "10:55",
      repeatType: "none",
      scenario: .work
    ),
    LegacyAlarmTemplate(
      name: "定期会议设置",
      category: "会议管理",
      icon: "🔄",
      description: "支持按周、月、自定义周期设置重复会议提醒",
      time: "按周期",
      frequency: "重复",
      defaultTime: "09:00",
      repeatType: "weekly",
      scenario: .work
    ),
    LegacyAlarmTemplate(
      name: "跨时区会议",
      category: "会议管理",
      icon: "🌍",
      description: "提供时区转换功能，方便与不同地区同事协调",
      time: "自定义",
      frequency: "单次",
      defaultTime: "09:00",
      repeatType: "none",
      scenario: .work
    ),

    // 工作任务管理
    LegacyAlarmTemplate(
      name: "项目截止日期倒计时",
      category: "工作任务管理",
      icon: "📋",
      description: "为项目或关键任务设置截止日期，并在临近时提供倒计时提醒",
      time: "自定义",
      frequency: "倒计时",
      defaultTime: "17:00",
      repeatType: "countdown",
      scenario: .work
    ),
    LegacyAlarmTemplate(
      name: "阶段性目标提醒",
      category: "工作任务管理",
      icon: "🎯",
      description: "将大型项目分解为多个阶段性目标，并为每个阶段设置提醒",
      time: "分阶段",
      frequency: "阶段性",
      defaultTime: "09:00",
      repeatType: "custom",
      scenario: .work
    ),
    LegacyAlarmTemplate(
      name: "任务优先级排序",
      category: "工作任务管理",
      icon: "📊",
      description: "支持任务按重要性、紧急性进行排序，确保优先处理关键工作",
      time: "每日",
      frequency: "每日",
      defaultTime: "08:30",
      repeatType: "daily",
      scenario: .work
    ),
    LegacyAlarmTemplate(
      name: "待办事项定时提醒",
      category: "工作任务管理",
      icon: "✅",
      description: "为日常待办事项设置具体时间提醒，避免遗漏",
      time: "自定义",
      frequency: "自定义",
      defaultTime: "09:30",
      repeatType: "custom",
      scenario: .work
    ),
    LegacyAlarmTemplate(
      name: "工作日程时间块",
      category: "工作任务管理",
      icon: "📅",
      description: "支持将工作内容以时间块形式规划到日程中",
      time: "时间块",
      frequency: "按需",
      defaultTime: "09:00",
      repeatType: "custom",
      scenario: .work
    ),

    // 休息调整
    LegacyAlarmTemplate(
      name: "番茄工作法",
      category: "休息调整",
      icon: "🍅",
      description: "内置25分钟工作、5分钟休息的番茄钟，支持自定义时长",
      time: "25分钟",
      frequency: "循环",
      defaultTime: "09:00",
      repeatType: "interval",
      scenario: .work
    ),
    LegacyAlarmTemplate(
      name: "久坐提醒",
      category: "休息调整",
      icon: "🚶",
      description: "根据用户设置的间隔时间（如每小时），提醒用户起身活动",
      time: "每小时",
      frequency: "每小时",
      defaultTime: "10:00",
      repeatType: "hourly",
      scenario: .work
    ),
    LegacyAlarmTemplate(
      name: "用眼过度提醒",
      category: "休息调整",
      icon: "👁️",
      description: "遵循20-20-20法则（每20分钟看20英尺外20秒）",
      time: "每20分钟",
      frequency: "每20分钟",
      defaultTime: "09:20",
      repeatType: "interval",
      scenario: .work
    ),
    LegacyAlarmTemplate(
      name: "喝水提醒",
      category: "休息调整",
      icon: "💧",
      description: "定时提醒用户补充水分",
      time: "每2小时",
      frequency: "每2小时",
      defaultTime: "10:00",
      repeatType: "interval",
      scenario: .work
    ),
    LegacyAlarmTemplate(
      name: "午休提醒",
      category: "休息调整",
      icon: "😴",
      description: "设置午休开始和结束时间提醒",
      time: "12:00-13:00",
      frequency: "工作日",
      defaultTime: "12:00",
      repeatType: "weekdays",
      scenario: .work
    ),

    // 沟通协作
    LegacyAlarmTemplate(
      name: "同事客户约定提醒",
      category: "沟通协作",
      icon: "🤝",
      description: "为与同事或客户的约定设置提醒，如电话会议、面谈",
      time: "自定义",
      frequency: "单次",
      defaultTime: "14:00",
      repeatType: "none",
      scenario: .work
    ),
    LegacyAlarmTemplate(
      name: "邮件跟进提醒",
      category: "沟通协作",
      icon: "📧",
      description: "对重要邮件设置延时提醒，确保及时跟进回复",
      time: "延时",
      frequency: "延时",
      defaultTime: "09:00",
      repeatType: "custom",
      scenario: .work
    ),
    LegacyAlarmTemplate(
      name: "团队协作任务进度",
      category: "沟通协作",
      icon: "👥",
      description: "与团队项目管理工具集成，提醒任务进度更新或逾期",
      time: "按进度",
      frequency: "按需",
      defaultTime: "16:00",
      repeatType: "custom",
      scenario: .work
    ),

    // 行政事务
    LegacyAlarmTemplate(
      name: "报销审批截止提醒",
      category: "行政事务",
      icon: "💰",
      description: "提醒用户提交报销单据或处理审批",
      time: "截止前",
      frequency: "每月",
      defaultTime: "16:00",
      repeatType: "monthly",
      scenario: .work
    ),
    LegacyAlarmTemplate(
      name: "工资单确认提醒",
      category: "行政事务",
      icon: "💵",
      description: "提醒用户查收和确认工资单",
      time: "每月",
      frequency: "每月",
      defaultTime: "10:00",
      repeatType: "monthly",
      scenario: .work
    ),
    LegacyAlarmTemplate(
      name: "年假培训申请截止",
      category: "行政事务",
      icon: "📝",
      description: "提醒用户在截止日期前提交相关申请",
      time: "截止前",
      frequency: "按需",
      defaultTime: "15:00",
      repeatType: "custom",
      scenario: .work
    ),
  ]

  // MARK: - 学习场景模板
  static let studyTemplates: [LegacyAlarmTemplate] = [
    // 课程管理
    LegacyAlarmTemplate(
      name: "上课提醒",
      category: "课程管理",
      icon: "🎓",
      description: "提前10-15分钟提醒用户准备上课",
      time: "提前10分钟",
      frequency: "按课表",
      defaultTime: "08:50",
      repeatType: "weekly",
      scenario: .study
    ),
    LegacyAlarmTemplate(
      name: "课程转换提醒",
      category: "课程管理",
      icon: "🔄",
      description: "在多节课程之间提供间隔提醒，方便切换",
      time: "课间",
      frequency: "按课表",
      defaultTime: "10:00",
      repeatType: "weekly",
      scenario: .study
    ),
    LegacyAlarmTemplate(
      name: "线上课程开始提醒",
      category: "课程管理",
      icon: "💻",
      description: "针对在线学习平台课程的开始时间提醒",
      time: "提前5分钟",
      frequency: "按课表",
      defaultTime: "14:25",
      repeatType: "custom",
      scenario: .study
    ),
    LegacyAlarmTemplate(
      name: "选课报名截止",
      category: "课程管理",
      icon: "📋",
      description: "提醒用户在截止日期前完成选课或活动报名",
      time: "截止前1天",
      frequency: "单次",
      defaultTime: "20:00",
      repeatType: "none",
      scenario: .study
    ),

    // 考试作业
    LegacyAlarmTemplate(
      name: "考试日期倒计时",
      category: "考试作业",
      icon: "⏳",
      description: "为重要考试设置倒计时，并提供阶段性复习提醒",
      time: "考前1周",
      frequency: "倒计时",
      defaultTime: "19:00",
      repeatType: "countdown",
      scenario: .study
    ),
    LegacyAlarmTemplate(
      name: "作业提交截止提醒",
      category: "考试作业",
      icon: "📝",
      description: "提醒用户按时提交作业或项目",
      time: "截止前1天",
      frequency: "单次",
      defaultTime: "20:00",
      repeatType: "none",
      scenario: .study
    ),
    LegacyAlarmTemplate(
      name: "论文写作阶段提醒",
      category: "考试作业",
      icon: "📄",
      description: "将论文写作分解为多个阶段（如选题、开题、初稿、修改）",
      time: "分阶段",
      frequency: "阶段性",
      defaultTime: "09:00",
      repeatType: "custom",
      scenario: .study
    ),
    LegacyAlarmTemplate(
      name: "复习时间分配",
      category: "考试作业",
      icon: "📊",
      description: "根据考试科目和难度，提醒用户合理分配复习时间",
      time: "每日",
      frequency: "每日",
      defaultTime: "19:00",
      repeatType: "daily",
      scenario: .study
    ),

    // 自主学习
    LegacyAlarmTemplate(
      name: "自定义学习时间",
      category: "自主学习",
      icon: "📖",
      description: "用户可设置每日/每周固定学习时间，并提供提醒",
      time: "自定义",
      frequency: "自定义",
      defaultTime: "19:30",
      repeatType: "custom",
      scenario: .study
    ),
    LegacyAlarmTemplate(
      name: "学习休息交替",
      category: "自主学习",
      icon: "⏰",
      description: "结合专注时钟，提醒用户在学习过程中进行适当休息",
      time: "25分钟",
      frequency: "循环",
      defaultTime: "19:00",
      repeatType: "interval",
      scenario: .study
    ),
    LegacyAlarmTemplate(
      name: "阅读计划进度",
      category: "自主学习",
      icon: "📚",
      description: "为阅读书籍或文献设置进度目标，并提醒用户按计划推进",
      time: "每日",
      frequency: "每日",
      defaultTime: "21:00",
      repeatType: "daily",
      scenario: .study
    ),
    LegacyAlarmTemplate(
      name: "技能培训练习",
      category: "自主学习",
      icon: "🛠️",
      description: "提醒用户进行编程、乐器、绘画等技能的日常练习",
      time: "每日",
      frequency: "每日",
      defaultTime: "20:00",
      repeatType: "daily",
      scenario: .study
    ),
    LegacyAlarmTemplate(
      name: "语言学习打卡",
      category: "自主学习",
      icon: "🗣️",
      description: "每日提醒用户进行单词背诵、听力练习或口语训练",
      time: "每日",
      frequency: "每日",
      defaultTime: "07:30",
      repeatType: "daily",
      scenario: .study
    ),

    // 学习资源
    LegacyAlarmTemplate(
      name: "图书馆借阅到期",
      category: "学习资源",
      icon: "📚",
      description: "提醒用户归还或续借图书",
      time: "到期前3天",
      frequency: "单次",
      defaultTime: "10:00",
      repeatType: "none",
      scenario: .study
    ),
    LegacyAlarmTemplate(
      name: "在线课程有效期",
      category: "学习资源",
      icon: "💻",
      description: "提醒用户在课程有效期内完成学习",
      time: "到期前1周",
      frequency: "单次",
      defaultTime: "20:00",
      repeatType: "none",
      scenario: .study
    ),
    LegacyAlarmTemplate(
      name: "软件订阅更新",
      category: "学习资源",
      icon: "💿",
      description: "提醒学习软件或工具的订阅到期",
      time: "到期前3天",
      frequency: "单次",
      defaultTime: "15:00",
      repeatType: "none",
      scenario: .study
    ),
  ]

  // MARK: - 健康场景模板
  static let healthTemplates: [LegacyAlarmTemplate] = [
    // 日常健康
    LegacyAlarmTemplate(
      name: "定时喝水提醒",
      category: "日常健康",
      icon: "💧",
      description: "根据用户设置的频率提醒喝水",
      time: "每2小时",
      frequency: "每2小时",
      defaultTime: "08:00",
      repeatType: "interval",
      scenario: .health
    ),
    LegacyAlarmTemplate(
      name: "规律作息提醒",
      category: "日常健康",
      icon: "🛏️",
      description: "提醒用户按时睡觉和起床",
      time: "每日",
      frequency: "每日",
      defaultTime: "22:00",
      repeatType: "daily",
      scenario: .health
    ),
    LegacyAlarmTemplate(
      name: "站立活动提醒",
      category: "日常健康",
      icon: "🚶",
      description: "与久坐提醒类似，鼓励用户定时起身活动",
      time: "每小时",
      frequency: "每小时",
      defaultTime: "09:00",
      repeatType: "hourly",
      scenario: .health
    ),
    LegacyAlarmTemplate(
      name: "体重测量提醒",
      category: "日常健康",
      icon: "⚖️",
      description: "定期提醒用户测量体重，记录健康数据",
      time: "每周",
      frequency: "每周",
      defaultTime: "07:00",
      repeatType: "weekly",
      scenario: .health
    ),
    LegacyAlarmTemplate(
      name: "保健品服用提醒",
      category: "日常健康",
      icon: "🍊",
      description: "提醒用户按时服用保健品",
      time: "每日",
      frequency: "每日",
      defaultTime: "08:30",
      repeatType: "daily",
      scenario: .health
    ),

    // 药物服用
    LegacyAlarmTemplate(
      name: "处方药定时提醒",
      category: "药物服用",
      icon: "💊",
      description: "为处方药设置精确的服用时间提醒",
      time: "准时",
      frequency: "每日",
      defaultTime: "08:00",
      repeatType: "multiple",
      scenario: .health
    ),
    LegacyAlarmTemplate(
      name: "长期用药周期",
      category: "药物服用",
      icon: "📅",
      description: "针对需要长期服用的药物，设置周期性提醒",
      time: "周期性",
      frequency: "长期",
      defaultTime: "08:00",
      repeatType: "daily",
      scenario: .health
    ),
    LegacyAlarmTemplate(
      name: "药物间隔时间",
      category: "药物服用",
      icon: "⏰",
      description: "提醒用户两次服药之间的间隔",
      time: "间隔",
      frequency: "按需",
      defaultTime: "12:00",
      repeatType: "interval",
      scenario: .health
    ),
    LegacyAlarmTemplate(
      name: "药品有效期",
      category: "药物服用",
      icon: "📋",
      description: "提醒用户检查药品有效期，避免使用过期药物",
      time: "到期前1月",
      frequency: "单次",
      defaultTime: "10:00",
      repeatType: "none",
      scenario: .health
    ),

    // 运动锻炼
    LegacyAlarmTemplate(
      name: "日常锻炼提醒",
      category: "运动锻炼",
      icon: "🏃",
      description: "提醒用户进行每日或每周的运动",
      time: "每日",
      frequency: "每日",
      defaultTime: "18:00",
      repeatType: "daily",
      scenario: .health
    ),
    LegacyAlarmTemplate(
      name: "间歇训练计时",
      category: "运动锻炼",
      icon: "⏱️",
      description: "为高强度间歇训练（HIIT）提供精确的训练和休息计时",
      time: "计时",
      frequency: "训练时",
      defaultTime: "17:00",
      repeatType: "timer",
      scenario: .health
    ),
    LegacyAlarmTemplate(
      name: "运动时长控制",
      category: "运动锻炼",
      icon: "⏰",
      description: "提醒用户达到或超过预设运动时长",
      time: "目标时长",
      frequency: "运动时",
      defaultTime: "18:00",
      repeatType: "timer",
      scenario: .health
    ),
    LegacyAlarmTemplate(
      name: "运动后恢复",
      category: "运动锻炼",
      icon: "🧘",
      description: "提醒用户进行拉伸、放松或补充营养",
      time: "运动后",
      frequency: "运动后",
      defaultTime: "19:00",
      repeatType: "custom",
      scenario: .health
    ),
    LegacyAlarmTemplate(
      name: "运动计划周期",
      category: "运动锻炼",
      icon: "📅",
      description: "提醒用户开始新的运动计划周期",
      time: "周期性",
      frequency: "按计划",
      defaultTime: "06:00",
      repeatType: "weekly",
      scenario: .health
    ),

    // 健康监测
    LegacyAlarmTemplate(
      name: "体检预约提醒",
      category: "健康监测",
      icon: "🏥",
      description: "提醒用户进行年度体检或专科检查",
      time: "每年",
      frequency: "每年",
      defaultTime: "09:00",
      repeatType: "yearly",
      scenario: .health
    ),
    LegacyAlarmTemplate(
      name: "生理周期跟踪",
      category: "健康监测",
      icon: "📅",
      description: "女性用户可记录生理周期，并获得相关提醒",
      time: "周期性",
      frequency: "月经周期",
      defaultTime: "08:00",
      repeatType: "custom",
      scenario: .health
    ),
    LegacyAlarmTemplate(
      name: "血糖血压测量",
      category: "健康监测",
      icon: "🩺",
      description: "提醒患有慢性病的用户定时测量血糖或血压",
      time: "每日",
      frequency: "每日",
      defaultTime: "07:00",
      repeatType: "daily",
      scenario: .health
    ),
  ]

  // MARK: - 家庭场景模板
  static let familyTemplates: [LegacyAlarmTemplate] = [
    // 家务管理
    LegacyAlarmTemplate(
      name: "定期打扫提醒",
      category: "家务管理",
      icon: "🧹",
      description: "提醒用户进行房间清洁、衣物整理等家务",
      time: "每周",
      frequency: "每周",
      defaultTime: "10:00",
      repeatType: "weekly",
      scenario: .family
    ),
    LegacyAlarmTemplate(
      name: "垃圾处理提醒",
      category: "家务管理",
      icon: "�️",
      description: "根据社区垃圾分类和投放时间，提醒用户处理垃圾",
      time: "投放日",
      frequency: "按社区规定",
      defaultTime: "07:00",
      repeatType: "weekly",
      scenario: .family
    ),
    LegacyAlarmTemplate(
      name: "洗衣晾晒提醒",
      category: "家务管理",
      icon: "👕",
      description: "提醒用户清洗衣物或收取晾晒的衣物",
      time: "每周2次",
      frequency: "每周",
      defaultTime: "09:00",
      repeatType: "weekly",
      scenario: .family
    ),
    LegacyAlarmTemplate(
      name: "家电维护提醒",
      category: "家务管理",
      icon: "🔧",
      description: "提醒用户定期清洁空调滤网、冰箱除霜等",
      time: "每月",
      frequency: "每月",
      defaultTime: "10:00",
      repeatType: "monthly",
      scenario: .family
    ),
    LegacyAlarmTemplate(
      name: "家居用品更换",
      category: "家务管理",
      icon: "🧽",
      description: "提醒用户更换牙刷、滤水器滤芯等消耗品",
      time: "定期",
      frequency: "按需",
      defaultTime: "15:00",
      repeatType: "custom",
      scenario: .family
    ),

    // 儿童照顾
    LegacyAlarmTemplate(
      name: "婴儿喂养提醒",
      category: "儿童照顾",
      icon: "🍼",
      description: "为新生儿设置喂奶、换尿布时间提醒",
      time: "每3小时",
      frequency: "每日",
      defaultTime: "06:00",
      repeatType: "interval",
      scenario: .family
    ),
    LegacyAlarmTemplate(
      name: "儿童睡眠提醒",
      category: "儿童照顾",
      icon: "😴",
      description: "提醒孩子按时午睡或晚睡",
      time: "每日",
      frequency: "每日",
      defaultTime: "21:00",
      repeatType: "daily",
      scenario: .family
    ),
    LegacyAlarmTemplate(
      name: "疫苗接种提醒",
      category: "儿童照顾",
      icon: "💉",
      description: "提醒孩子按时接种疫苗",
      time: "按时间表",
      frequency: "单次",
      defaultTime: "09:00",
      repeatType: "none",
      scenario: .family
    ),
    LegacyAlarmTemplate(
      name: "成长检查提醒",
      category: "儿童照顾",
      icon: "📏",
      description: "提醒孩子进行定期体检或牙科检查",
      time: "定期",
      frequency: "按需",
      defaultTime: "14:00",
      repeatType: "custom",
      scenario: .family
    ),

    // 宠物照料
    LegacyAlarmTemplate(
      name: "宠物喂食提醒",
      category: "宠物照料",
      icon: "🐕",
      description: "提醒用户按时喂养宠物",
      time: "每日2次",
      frequency: "每日",
      defaultTime: "08:00",
      repeatType: "multiple",
      scenario: .family
    ),
    LegacyAlarmTemplate(
      name: "宠物洗澡美容",
      category: "宠物照料",
      icon: "🛁",
      description: "提醒用户为宠物洗澡或预约美容",
      time: "每月",
      frequency: "每月",
      defaultTime: "14:00",
      repeatType: "monthly",
      scenario: .family
    ),
    LegacyAlarmTemplate(
      name: "宠物疫苗体检",
      category: "宠物照料",
      icon: "💉",
      description: "提醒用户带宠物接种疫苗或进行体检",
      time: "每年",
      frequency: "每年",
      defaultTime: "10:00",
      repeatType: "yearly",
      scenario: .family
    ),
    LegacyAlarmTemplate(
      name: "宠物药物提醒",
      category: "宠物照料",
      icon: "💊",
      description: "提醒用户按时给宠物喂药",
      time: "按医嘱",
      frequency: "按需",
      defaultTime: "08:00",
      repeatType: "custom",
      scenario: .family
    ),

    // 家庭财务
    LegacyAlarmTemplate(
      name: "账单支付提醒",
      category: "家庭财务",
      icon: "💳",
      description: "提醒用户支付水电煤、信用卡等账单",
      time: "到期前3天",
      frequency: "每月",
      defaultTime: "10:00",
      repeatType: "monthly",
      scenario: .family
    ),
    LegacyAlarmTemplate(
      name: "保险缴费提醒",
      category: "家庭财务",
      icon: "🛡️",
      description: "提醒用户缴纳各类保险费用",
      time: "到期前1周",
      frequency: "按保险周期",
      defaultTime: "09:00",
      repeatType: "custom",
      scenario: .family
    ),
    LegacyAlarmTemplate(
      name: "贷款还款提醒",
      category: "家庭财务",
      icon: "🏠",
      description: "提醒用户按时偿还房贷、车贷等",
      time: "还款日前1天",
      frequency: "每月",
      defaultTime: "20:00",
      repeatType: "monthly",
      scenario: .family
    ),
    LegacyAlarmTemplate(
      name: "税务申报提醒",
      category: "家庭财务",
      icon: "📊",
      description: "提醒用户进行年度税务申报",
      time: "申报期前1月",
      frequency: "每年",
      defaultTime: "10:00",
      repeatType: "yearly",
      scenario: .family
    ),
  ]

  // MARK: - 烹饪场景模板
  static let cookingTemplates: [LegacyAlarmTemplate] = [
    // 食材准备
    LegacyAlarmTemplate(
      name: "食材解冻提醒",
      category: "食材准备",
      icon: "🧊",
      description: "提醒用户提前将冷冻食材取出解冻",
      time: "提前2小时",
      frequency: "单次",
      defaultTime: "16:00",
      repeatType: "none",
      scenario: .cooking
    ),
    LegacyAlarmTemplate(
      name: "腌制时间控制",
      category: "食材准备",
      icon: "🥩",
      description: "为肉类腌制等设置计时，确保入味",
      time: "30分钟-2小时",
      frequency: "计时",
      defaultTime: "15:00",
      repeatType: "timer",
      scenario: .cooking
    ),
    LegacyAlarmTemplate(
      name: "面团发酵提醒",
      category: "食材准备",
      icon: "🍞",
      description: "为烘焙中的面团发酵设置计时",
      time: "1-2小时",
      frequency: "计时",
      defaultTime: "10:00",
      repeatType: "timer",
      scenario: .cooking
    ),
    LegacyAlarmTemplate(
      name: "干货浸泡提醒",
      category: "食材准备",
      icon: "🍄",
      description: "提醒用户提前浸泡干香菇、木耳等",
      time: "提前1小时",
      frequency: "单次",
      defaultTime: "16:00",
      repeatType: "none",
      scenario: .cooking
    ),

    // 烹饪过程
    LegacyAlarmTemplate(
      name: "食材烹饪时间",
      category: "烹饪过程",
      icon: "🍳",
      description: "为不同食材（如鸡蛋、牛排）设置精确烹饪时间",
      time: "精确计时",
      frequency: "计时",
      defaultTime: "18:00",
      repeatType: "timer",
      scenario: .cooking
    ),
    LegacyAlarmTemplate(
      name: "煮制时间提醒",
      category: "烹饪过程",
      icon: "🍚",
      description: "提醒用户煮面、煮饭等所需时间",
      time: "15-30分钟",
      frequency: "计时",
      defaultTime: "17:30",
      repeatType: "timer",
      scenario: .cooking
    ),
    LegacyAlarmTemplate(
      name: "翻炒间隔提醒",
      category: "烹饪过程",
      icon: "🥢",
      description: "提醒用户在烹饪过程中定时翻炒",
      time: "每2-3分钟",
      frequency: "间隔",
      defaultTime: "18:00",
      repeatType: "interval",
      scenario: .cooking
    ),
    LegacyAlarmTemplate(
      name: "蒸制时间控制",
      category: "烹饪过程",
      icon: "🥟",
      description: "为蒸鱼、蒸蛋等设置蒸制时间",
      time: "10-20分钟",
      frequency: "计时",
      defaultTime: "18:30",
      repeatType: "timer",
      scenario: .cooking
    ),
    LegacyAlarmTemplate(
      name: "慢炖长时间提醒",
      category: "烹饪过程",
      icon: "🍲",
      description: "为煲汤、炖肉等长时间烹饪设置提醒",
      time: "2-4小时",
      frequency: "计时",
      defaultTime: "15:00",
      repeatType: "timer",
      scenario: .cooking
    ),

    // 烘焙活动
    LegacyAlarmTemplate(
      name: "烤箱预热提醒",
      category: "烘焙活动",
      icon: "🔥",
      description: "提醒用户提前预热烤箱",
      time: "提前15分钟",
      frequency: "单次",
      defaultTime: "13:45",
      repeatType: "none",
      scenario: .cooking
    ),
    LegacyAlarmTemplate(
      name: "烘焙精确计时",
      category: "烘焙活动",
      icon: "🧁",
      description: "为蛋糕、面包等烘焙品设置精确的烘烤时间",
      time: "精确计时",
      frequency: "计时",
      defaultTime: "14:00",
      repeatType: "timer",
      scenario: .cooking
    ),
    LegacyAlarmTemplate(
      name: "分阶段烘焙提醒",
      category: "烘焙活动",
      icon: "📋",
      description: "提醒用户在烘焙过程中进行分阶段操作（如加料、翻面）",
      time: "分阶段",
      frequency: "阶段性",
      defaultTime: "14:30",
      repeatType: "custom",
      scenario: .cooking
    ),
    LegacyAlarmTemplate(
      name: "冷却脱模提醒",
      category: "烘焙活动",
      icon: "❄️",
      description: "提醒用户在烘焙品冷却后脱模",
      time: "冷却后",
      frequency: "单次",
      defaultTime: "15:30",
      repeatType: "none",
      scenario: .cooking
    ),

    // 厨房安全
    LegacyAlarmTemplate(
      name: "燃气使用监控",
      category: "厨房安全",
      icon: "🔥",
      description: "提醒用户检查燃气是否关闭",
      time: "离开厨房",
      frequency: "每次",
      defaultTime: "19:00",
      repeatType: "custom",
      scenario: .cooking
    ),
    LegacyAlarmTemplate(
      name: "压力锅减压提醒",
      category: "厨房安全",
      icon: "⚠️",
      description: "提醒用户在压力锅烹饪结束后进行减压",
      time: "烹饪结束",
      frequency: "使用时",
      defaultTime: "18:00",
      repeatType: "custom",
      scenario: .cooking
    ),
    LegacyAlarmTemplate(
      name: "油温控制提醒",
      category: "厨房安全",
      icon: "🌡️",
      description: "提醒用户注意油温，避免过热",
      time: "加热时",
      frequency: "使用时",
      defaultTime: "18:00",
      repeatType: "custom",
      scenario: .cooking
    ),
  ]

  // MARK: - 出行场景模板
  static let transportTemplates: [LegacyAlarmTemplate] = [
    // 日常通勤
    LegacyAlarmTemplate(
      name: "出门时间提醒",
      category: "日常通勤",
      icon: "�",
      description: "根据通勤距离和交通状况，提醒用户提前出门",
      time: "提前30分钟",
      frequency: "工作日",
      defaultTime: "08:00",
      repeatType: "weekdays",
      scenario: .transport
    ),
    LegacyAlarmTemplate(
      name: "公共交通班次",
      category: "日常通勤",
      icon: "🚌",
      description: "提醒用户即将到来的公交、地铁班次",
      time: "班次前5分钟",
      frequency: "工作日",
      defaultTime: "08:15",
      repeatType: "weekdays",
      scenario: .transport
    ),
    LegacyAlarmTemplate(
      name: "共享交通时间",
      category: "日常通勤",
      icon: "🚲",
      description: "提醒用户共享单车、共享汽车的使用时长，避免超时计费",
      time: "使用时计时",
      frequency: "使用时",
      defaultTime: "08:00",
      repeatType: "timer",
      scenario: .transport
    ),
    LegacyAlarmTemplate(
      name: "错峰出行提醒",
      category: "日常通勤",
      icon: "📊",
      description: "根据交通大数据，提醒用户避开高峰期出行",
      time: "高峰期前",
      frequency: "工作日",
      defaultTime: "07:30",
      repeatType: "weekdays",
      scenario: .transport
    ),
    LegacyAlarmTemplate(
      name: "停车计时提醒",
      category: "日常通勤",
      icon: "🅿️",
      description: "提醒用户停车时长，避免超时罚款",
      time: "停车时计时",
      frequency: "停车时",
      defaultTime: "09:00",
      repeatType: "timer",
      scenario: .transport
    ),

    // 长途旅行
    LegacyAlarmTemplate(
      name: "航班火车提前到达",
      category: "长途旅行",
      icon: "✈️",
      description: "提醒用户提前抵达机场或火车站",
      time: "提前2小时",
      frequency: "单次",
      defaultTime: "06:00",
      repeatType: "none",
      scenario: .transport
    ),
    LegacyAlarmTemplate(
      name: "转乘衔接提醒",
      category: "长途旅行",
      icon: "🔄",
      description: "提醒用户换乘时间，确保顺利衔接",
      time: "转乘前30分钟",
      frequency: "单次",
      defaultTime: "12:00",
      repeatType: "none",
      scenario: .transport
    ),
    LegacyAlarmTemplate(
      name: "酒店入住退房",
      category: "长途旅行",
      icon: "🏨",
      description: "提醒用户酒店入住和退房时间",
      time: "入住/退房时间",
      frequency: "单次",
      defaultTime: "14:00",
      repeatType: "none",
      scenario: .transport
    ),
    LegacyAlarmTemplate(
      name: "景点游览时间",
      category: "长途旅行",
      icon: "🏛️",
      description: "为景点游览设置预估时间，提醒用户合理安排行程",
      time: "游览时间",
      frequency: "单次",
      defaultTime: "10:00",
      repeatType: "none",
      scenario: .transport
    ),

    // 交通工具维护
    LegacyAlarmTemplate(
      name: "汽车保养周期",
      category: "交通工具维护",
      icon: "🔧",
      description: "提醒用户进行车辆定期保养",
      time: "每5000公里",
      frequency: "按里程",
      defaultTime: "10:00",
      repeatType: "custom",
      scenario: .transport
    ),
    LegacyAlarmTemplate(
      name: "证件更新提醒",
      category: "交通工具维护",
      icon: "📄",
      description: "提醒用户驾驶证、行驶证等证件的到期更新",
      time: "到期前1月",
      frequency: "单次",
      defaultTime: "09:00",
      repeatType: "none",
      scenario: .transport
    ),
    LegacyAlarmTemplate(
      name: "保险到期提醒",
      category: "交通工具维护",
      icon: "🛡️",
      description: "提醒用户车险、旅游险等保险的续费",
      time: "到期前1周",
      frequency: "单次",
      defaultTime: "10:00",
      repeatType: "none",
      scenario: .transport
    ),
    LegacyAlarmTemplate(
      name: "年检时间提醒",
      category: "交通工具维护",
      icon: "📋",
      description: "提醒用户车辆年检时间",
      time: "年检前1月",
      frequency: "每年",
      defaultTime: "09:00",
      repeatType: "yearly",
      scenario: .transport
    ),
  ]

  // MARK: - 社交场景模板
  static let socialTemplates: [LegacyAlarmTemplate] = [
    // 社交约会
    LegacyAlarmTemplate(
      name: "社交准备提醒",
      category: "社交约会",
      icon: "�",
      description: "提醒用户提前准备赴约（如着装、礼物）",
      time: "提前1小时",
      frequency: "单次",
      defaultTime: "18:00",
      repeatType: "none",
      scenario: .social
    ),
    LegacyAlarmTemplate(
      name: "准时赴约提醒",
      category: "社交约会",
      icon: "⏰",
      description: "提醒用户准时抵达约会地点",
      time: "提前30分钟",
      frequency: "单次",
      defaultTime: "19:00",
      repeatType: "none",
      scenario: .social
    ),
    LegacyAlarmTemplate(
      name: "活动时长控制",
      category: "社交约会",
      icon: "⏱️",
      description: "为社交活动设置预估时长，提醒用户合理安排时间",
      time: "活动时长",
      frequency: "单次",
      defaultTime: "19:00",
      repeatType: "timer",
      scenario: .social
    ),
    LegacyAlarmTemplate(
      name: "多场活动衔接",
      category: "社交约会",
      icon: "🔄",
      description: "提醒用户在多场活动之间的时间安排",
      time: "活动间隔",
      frequency: "单次",
      defaultTime: "20:00",
      repeatType: "none",
      scenario: .social
    ),

    // 人际关系维护
    LegacyAlarmTemplate(
      name: "生日纪念日提醒",
      category: "人际关系维护",
      icon: "🎂",
      description: "提醒用户亲友的生日、纪念日，并建议提前准备礼物或祝福",
      time: "提前1天",
      frequency: "每年",
      defaultTime: "10:00",
      repeatType: "yearly",
      scenario: .social
    ),
    LegacyAlarmTemplate(
      name: "定期联系提醒",
      category: "人际关系维护",
      icon: "📞",
      description: "提醒用户定期联系重要亲友或业务伙伴",
      time: "每月",
      frequency: "每月",
      defaultTime: "20:00",
      repeatType: "monthly",
      scenario: .social
    ),
    LegacyAlarmTemplate(
      name: "节日问候提醒",
      category: "人际关系维护",
      icon: "🎊",
      description: "提醒用户在节假日发送问候",
      time: "节日当天",
      frequency: "节日",
      defaultTime: "09:00",
      repeatType: "yearly",
      scenario: .social
    ),
    LegacyAlarmTemplate(
      name: "回访回复提醒",
      category: "人际关系维护",
      icon: "💬",
      description: "提醒用户对未回复的信息或电话进行回访",
      time: "1天后",
      frequency: "单次",
      defaultTime: "10:00",
      repeatType: "none",
      scenario: .social
    ),

    // 社交礼仪
    LegacyAlarmTemplate(
      name: "回复邀请提醒",
      category: "社交礼仪",
      icon: "📧",
      description: "提醒用户及时回复活动邀请",
      time: "收到后1天",
      frequency: "单次",
      defaultTime: "10:00",
      repeatType: "none",
      scenario: .social
    ),
    LegacyAlarmTemplate(
      name: "感谢表达提醒",
      category: "社交礼仪",
      icon: "🙏",
      description: "提醒用户在接受帮助或礼物后表达感谢",
      time: "当天",
      frequency: "单次",
      defaultTime: "20:00",
      repeatType: "none",
      scenario: .social
    ),
    LegacyAlarmTemplate(
      name: "停留时间控制",
      category: "社交礼仪",
      icon: "⏰",
      description: "提醒用户在拜访或聚会中注意停留时间",
      time: "2-3小时",
      frequency: "单次",
      defaultTime: "19:00",
      repeatType: "timer",
      scenario: .social
    ),
  ]

  // MARK: - 个人护理场景模板
  static let personalTemplates: [LegacyAlarmTemplate] = [
    // 日常清洁
    LegacyAlarmTemplate(
      name: "刷牙时间控制",
      category: "日常清洁",
      icon: "🥩",
      description: "提供2-3分钟的刷牙计时，确保清洁到位",
      time: "3分钟",
      frequency: "每日",
      defaultTime: "07:00",
      repeatType: "timer",
      scenario: .personal
    ),
    LegacyAlarmTemplate(
      name: "淋浴时间提醒",
      category: "日常清洁",
      icon: "🚿",
      description: "提醒用户控制淋浴时长，节约用水",
      time: "10分钟",
      frequency: "每日",
      defaultTime: "07:30",
      repeatType: "timer",
      scenario: .personal
    ),
    LegacyAlarmTemplate(
      name: "洗手时间控制",
      category: "日常清洁",
      icon: "🧼",
      description: "提供20秒的洗手计时，确保有效清洁",
      time: "20秒",
      frequency: "多次",
      defaultTime: "12:00",
      repeatType: "timer",
      scenario: .personal
    ),
    LegacyAlarmTemplate(
      name: "护理流程提醒",
      category: "日常清洁",
      icon: "🧴",
      description: "提醒用户按步骤完成日常清洁和护理",
      time: "每日2次",
      frequency: "每日",
      defaultTime: "07:00",
      repeatType: "multiple",
      scenario: .personal
    ),
    LegacyAlarmTemplate(
      name: "卫生用品更换",
      category: "日常清洁",
      icon: "🧽",
      description: "提醒用户更换牙刷、毛巾、隐形眼镜等",
      time: "定期",
      frequency: "按需",
      defaultTime: "20:00",
      repeatType: "custom",
      scenario: .personal
    ),

    // 皮肤护理
    LegacyAlarmTemplate(
      name: "护肤步骤等待",
      category: "皮肤护理",
      icon: "⏰",
      description: "提醒用户在不同护肤步骤之间等待吸收时间",
      time: "2-3分钟",
      frequency: "每日",
      defaultTime: "22:00",
      repeatType: "timer",
      scenario: .personal
    ),
    LegacyAlarmTemplate(
      name: "面膜时间控制",
      category: "皮肤护理",
      icon: "🧖",
      description: "为敷面膜设置计时，避免超时",
      time: "15-20分钟",
      frequency: "每周2次",
      defaultTime: "21:00",
      repeatType: "timer",
      scenario: .personal
    ),
    LegacyAlarmTemplate(
      name: "防晒重新涂抹",
      category: "皮肤护理",
      icon: "☀️",
      description: "提醒用户在户外活动时定时重新涂抹防晒霜",
      time: "每2小时",
      frequency: "户外时",
      defaultTime: "10:00",
      repeatType: "interval",
      scenario: .personal
    ),
    LegacyAlarmTemplate(
      name: "季节性护肤品",
      category: "皮肤护理",
      icon: "🍂",
      description: "提醒用户根据季节更换护肤品",
      time: "换季时",
      frequency: "季节性",
      defaultTime: "10:00",
      repeatType: "custom",
      scenario: .personal
    ),
    LegacyAlarmTemplate(
      name: "特殊护理周期",
      category: "皮肤护理",
      icon: "✨",
      description: "提醒用户进行定期去角质、深层清洁等特殊护理",
      time: "每周",
      frequency: "每周",
      defaultTime: "20:00",
      repeatType: "weekly",
      scenario: .personal
    ),

    // 美容美发
    LegacyAlarmTemplate(
      name: "发型护理时间",
      category: "美容美发",
      icon: "💇",
      description: "为发膜、染发等设置停留时间",
      time: "30分钟",
      frequency: "按需",
      defaultTime: "15:00",
      repeatType: "timer",
      scenario: .personal
    ),
    LegacyAlarmTemplate(
      name: "美甲干燥时间",
      category: "美容美发",
      icon: "💅",
      description: "提醒用户美甲后的干燥时间",
      time: "30分钟",
      frequency: "按需",
      defaultTime: "15:00",
      repeatType: "timer",
      scenario: .personal
    ),
    LegacyAlarmTemplate(
      name: "美容院预约提醒",
      category: "美容美发",
      icon: "💆",
      description: "提醒用户美容、美发预约时间",
      time: "预约前1天",
      frequency: "单次",
      defaultTime: "20:00",
      repeatType: "none",
      scenario: .personal
    ),
    LegacyAlarmTemplate(
      name: "理发提醒",
      category: "美容美发",
      icon: "✂️",
      description: "根据用户习惯，提醒用户定期理发",
      time: "每月",
      frequency: "每月",
      defaultTime: "15:00",
      repeatType: "monthly",
      scenario: .personal
    ),
  ]

  // MARK: - 娱乐场景模板
  static let entertainmentTemplates: [LegacyAlarmTemplate] = [
    // 数字娱乐
    LegacyAlarmTemplate(
      name: "游戏时间控制",
      category: "数字娱乐",
      icon: "🎮",
      description: "提醒用户控制游戏时长，避免沉迷",
      time: "1小时",
      frequency: "每天",
      defaultTime: "20:00",
      repeatType: "timer",
      scenario: .entertainment
    ),
    LegacyAlarmTemplate(
      name: "社交媒体使用限制",
      category: "数字娱乐",
      icon: "�",
      description: "提醒用户控制社交媒体浏览时间",
      time: "30分钟",
      frequency: "每天",
      defaultTime: "21:00",
      repeatType: "timer",
      scenario: .entertainment
    ),
    LegacyAlarmTemplate(
      name: "视频观看时间",
      category: "数字娱乐",
      icon: "📺",
      description: "提醒用户控制观看视频的时长",
      time: "2小时",
      frequency: "每天",
      defaultTime: "21:00",
      repeatType: "timer",
      scenario: .entertainment
    ),
    LegacyAlarmTemplate(
      name: "电子阅读提醒",
      category: "数字娱乐",
      icon: "📚",
      description: "提醒用户进行电子书阅读，并控制阅读时长",
      time: "30分钟",
      frequency: "每天",
      defaultTime: "21:30",
      repeatType: "timer",
      scenario: .entertainment
    ),
    LegacyAlarmTemplate(
      name: "设备使用休息",
      category: "数字娱乐",
      icon: "📱",
      description: "提醒用户在使用电子设备一段时间后进行休息",
      time: "每小时",
      frequency: "重复",
      defaultTime: "09:00",
      repeatType: "hourly",
      scenario: .entertainment
    ),

    // 户外活动
    LegacyAlarmTemplate(
      name: "户外运动时间",
      category: "户外活动",
      icon: "🏃",
      description: "提醒用户进行户外跑步、骑行等运动",
      time: "1小时",
      frequency: "3次/周",
      defaultTime: "17:00",
      repeatType: "weekly",
      scenario: .entertainment
    ),
    LegacyAlarmTemplate(
      name: "防晒重新应用",
      category: "户外活动",
      icon: "☀️",
      description: "在户外活动时提醒用户重新涂抹防晒",
      time: "每2小时",
      frequency: "户外时",
      defaultTime: "10:00",
      repeatType: "interval",
      scenario: .entertainment
    ),
    LegacyAlarmTemplate(
      name: "天气变化提醒",
      category: "户外活动",
      icon: "🌦️",
      description: "根据天气预报，提醒用户注意天气变化，携带雨具或增减衣物",
      time: "出门前",
      frequency: "按需",
      defaultTime: "08:00",
      repeatType: "custom",
      scenario: .entertainment
    ),
    LegacyAlarmTemplate(
      name: "日落安全提醒",
      category: "户外活动",
      icon: "🌅",
      description: "提醒用户在户外活动时注意日落时间，确保安全返回",
      time: "日落前1小时",
      frequency: "按需",
      defaultTime: "17:00",
      repeatType: "custom",
      scenario: .entertainment
    ),
    LegacyAlarmTemplate(
      name: "装备租借时间",
      category: "户外活动",
      icon: "⛷️",
      description: "提醒用户归还租借的户外装备",
      time: "租借时长",
      frequency: "租借时",
      defaultTime: "16:00",
      repeatType: "timer",
      scenario: .entertainment
    ),

    // 文化娱乐
    LegacyAlarmTemplate(
      name: "演出开始提醒",
      category: "文化娱乐",
      icon: "🎭",
      description: "提醒用户音乐会、电影、戏剧等演出开始时间",
      time: "提前30分钟",
      frequency: "单次",
      defaultTime: "19:00",
      repeatType: "none",
      scenario: .entertainment
    ),
    LegacyAlarmTemplate(
      name: "展览开放时间",
      category: "文化娱乐",
      icon: "🏛️",
      description: "提醒用户博物馆、艺术展等开放和闭馆时间",
      time: "开放时间",
      frequency: "单次",
      defaultTime: "09:00",
      repeatType: "none",
      scenario: .entertainment
    ),
    LegacyAlarmTemplate(
      name: "借阅归还提醒",
      category: "文化娱乐",
      icon: "📚",
      description: "提醒用户归还图书馆或租赁店的音像制品、书籍",
      time: "到期前1天",
      frequency: "单次",
      defaultTime: "20:00",
      repeatType: "none",
      scenario: .entertainment
    ),
    LegacyAlarmTemplate(
      name: "入场时间提醒",
      category: "文化娱乐",
      icon: "🎫",
      description: "提醒用户提前抵达活动现场进行入场",
      time: "提前30分钟",
      frequency: "单次",
      defaultTime: "19:30",
      repeatType: "none",
      scenario: .entertainment
    ),
    LegacyAlarmTemplate(
      name: "限时活动结束",
      category: "文化娱乐",
      icon: "⏰",
      description: "提醒用户限时优惠、限时展览等活动的结束时间",
      time: "结束前1天",
      frequency: "单次",
      defaultTime: "20:00",
      repeatType: "none",
      scenario: .entertainment
    ),
  ]

  // MARK: - 特殊场景模板
  static let specialTemplates: [LegacyAlarmTemplate] = [
    // 节日庆典
    LegacyAlarmTemplate(
      name: "节日准备提醒",
      category: "节日庆典",
      icon: "🎄",
      description: "提醒用户提前准备节日用品、装饰或食物",
      time: "提前1周",
      frequency: "每年",
      defaultTime: "10:00",
      repeatType: "yearly",
      scenario: .special
    ),
    LegacyAlarmTemplate(
      name: "特定活动提醒",
      category: "节日庆典",
      icon: "🥩",
      description: "提醒用户参加节日期间的特定活动（如家庭聚餐、派对）",
      time: "活动前1天",
      frequency: "节日",
      defaultTime: "20:00",
      repeatType: "yearly",
      scenario: .special
    ),
    LegacyAlarmTemplate(
      name: "礼品准备提醒",
      category: "节日庆典",
      icon: "🎁",
      description: "提醒用户为亲友准备节日礼物",
      time: "提前3天",
      frequency: "每年",
      defaultTime: "15:00",
      repeatType: "yearly",
      scenario: .special
    ),
    LegacyAlarmTemplate(
      name: "特殊活动预约",
      category: "节日庆典",
      icon: "📞",
      description: "提醒用户预约节日期间的餐厅、景点或服务",
      time: "提前1周",
      frequency: "节日",
      defaultTime: "10:00",
      repeatType: "yearly",
      scenario: .special
    ),
    LegacyAlarmTemplate(
      name: "后续整理提醒",
      category: "节日庆典",
      icon: "🧹",
      description: "提醒用户在节日结束后进行清理和整理",
      time: "节日后1天",
      frequency: "节日",
      defaultTime: "10:00",
      repeatType: "yearly",
      scenario: .special
    ),

    // 人生重要时刻
    LegacyAlarmTemplate(
      name: "婚礼筹备提醒",
      category: "人生重要时刻",
      icon: "💒",
      description: "为婚礼筹备的各个环节设置提醒（如选婚纱、订场地）",
      time: "分阶段",
      frequency: "单次",
      defaultTime: "09:00",
      repeatType: "custom",
      scenario: .special
    ),
    LegacyAlarmTemplate(
      name: "典礼准备提醒",
      category: "人生重要时刻",
      icon: "🎓",
      description: "提醒用户毕业典礼、颁奖典礼等重要仪式的准备",
      time: "提前1周",
      frequency: "单次",
      defaultTime: "10:00",
      repeatType: "none",
      scenario: .special
    ),
    LegacyAlarmTemplate(
      name: "搬家时间规划",
      category: "人生重要时刻",
      icon: "📦",
      description: "为搬家过程中的打包、运输、入住等环节设置提醒",
      time: "分阶段",
      frequency: "单次",
      defaultTime: "09:00",
      repeatType: "custom",
      scenario: .special
    ),
    LegacyAlarmTemplate(
      name: "工作交接提醒",
      category: "人生重要时刻",
      icon: "💼",
      description: "提醒用户在离职或调岗前完成工作交接",
      time: "离职前1周",
      frequency: "单次",
      defaultTime: "09:00",
      repeatType: "none",
      scenario: .special
    ),
    LegacyAlarmTemplate(
      name: "考试备考规划",
      category: "人生重要时刻",
      icon: "📝",
      description: "为重要的职业资格考试、升学考试等设置详细的备考计划和提醒",
      time: "分阶段",
      frequency: "单次",
      defaultTime: "19:00",
      repeatType: "custom",
      scenario: .special
    ),

    // 纪念活动
    LegacyAlarmTemplate(
      name: "周年纪念提醒",
      category: "纪念活动",
      icon: "💕",
      description: "提醒用户结婚纪念日、相识纪念日等",
      time: "纪念日当天",
      frequency: "每年",
      defaultTime: "09:00",
      repeatType: "yearly",
      scenario: .special
    ),
    LegacyAlarmTemplate(
      name: "追思活动提醒",
      category: "纪念活动",
      icon: "🌹",
      description: "提醒用户参加亲友的追思会或祭扫活动",
      time: "活动当天",
      frequency: "每年",
      defaultTime: "10:00",
      repeatType: "yearly",
      scenario: .special
    ),
    LegacyAlarmTemplate(
      name: "历史事件纪念",
      category: "纪念活动",
      icon: "📅",
      description: "提醒用户重要历史事件的纪念日",
      time: "纪念日当天",
      frequency: "每年",
      defaultTime: "10:00",
      repeatType: "yearly",
      scenario: .special
    ),
    LegacyAlarmTemplate(
      name: "个人成就纪念",
      category: "纪念活动",
      icon: "🏆",
      description: "提醒用户职业里程碑、个人突破等值得纪念的时刻",
      time: "纪念日当天",
      frequency: "每年",
      defaultTime: "12:00",
      repeatType: "yearly",
      scenario: .special
    ),
    LegacyAlarmTemplate(
      name: "纪念品准备",
      category: "纪念活动",
      icon: "🎁",
      description: "提醒用户准备纪念品或礼物",
      time: "提前3天",
      frequency: "按需",
      defaultTime: "15:00",
      repeatType: "none",
      scenario: .special
    ),
  ]

  // MARK: - 扩展场景模板

  // MARK: - 财务管理模板
  static let financeTemplates: [LegacyAlarmTemplate] = [
    // 投资理财提醒
    LegacyAlarmTemplate(
      name: "基金定投提醒",
      category: "投资理财提醒",
      icon: "📈",
      description: "提醒用户每月/每周进行基金定投，培养长期投资习惯",
      time: "每月1日",
      frequency: "每月",
      defaultTime: "09:00",
      repeatType: "monthly",
      scenario: .finance
    ),
    LegacyAlarmTemplate(
      name: "股票关注提醒",
      category: "投资理财提醒",
      icon: "📊",
      description: "当关注的股票达到预设价格（高点/低点）时提醒用户",
      time: "价格触发",
      frequency: "实时",
      defaultTime: "09:30",
      repeatType: "custom",
      scenario: .finance
    ),
    LegacyAlarmTemplate(
      name: "理财产品到期提醒",
      category: "投资理财提醒",
      icon: "💎",
      description: "提醒用户理财产品即将到期，以便及时赎回或续投",
      time: "到期前3天",
      frequency: "单次",
      defaultTime: "10:00",
      repeatType: "none",
      scenario: .finance
    ),
    LegacyAlarmTemplate(
      name: "投资组合定期审视",
      category: "投资理财提醒",
      icon: "🔍",
      description: "提醒用户定期（如每季度）审视自己的投资组合，进行调整",
      time: "每季度",
      frequency: "每季度",
      defaultTime: "14:00",
      repeatType: "quarterly",
      scenario: .finance
    ),

    // 预算控制提醒
    LegacyAlarmTemplate(
      name: "每日每周消费限额提醒",
      category: "预算控制提醒",
      icon: "💳",
      description: "当用户消费接近或达到预设限额时提醒，帮助控制开支",
      time: "接近限额",
      frequency: "实时",
      defaultTime: "20:00",
      repeatType: "custom",
      scenario: .finance
    ),
    LegacyAlarmTemplate(
      name: "大额支出计划提醒",
      category: "预算控制提醒",
      icon: "💰",
      description: "提醒用户即将到来的大额支出（如房租、车贷、学费），确保资金充足",
      time: "支出前3天",
      frequency: "每月",
      defaultTime: "20:00",
      repeatType: "monthly",
      scenario: .finance
    ),

    // 税务与合规提醒
    LegacyAlarmTemplate(
      name: "发票报销截止提醒",
      category: "税务与合规提醒",
      icon: "🧾",
      description: "提醒用户提交发票进行报销",
      time: "截止前3天",
      frequency: "每月",
      defaultTime: "16:00",
      repeatType: "monthly",
      scenario: .finance
    ),
    LegacyAlarmTemplate(
      name: "年度报税提醒",
      category: "税务与合规提醒",
      icon: "📋",
      description: "提醒用户年度报税的截止日期",
      time: "截止前1月",
      frequency: "每年",
      defaultTime: "09:00",
      repeatType: "yearly",
      scenario: .finance
    ),
    LegacyAlarmTemplate(
      name: "证件年审提醒",
      category: "税务与合规提醒",
      icon: "📄",
      description: "提醒用户各类重要证件（如身份证、护照、驾驶证）的年审或换证日期",
      time: "到期前1月",
      frequency: "单次",
      defaultTime: "10:00",
      repeatType: "none",
      scenario: .finance
    ),
  ]

  // MARK: - 数字健康模板
  static let digitalTemplates: [LegacyAlarmTemplate] = [
    // 数字排毒提醒
    LegacyAlarmTemplate(
      name: "屏幕使用时间限制",
      category: "数字排毒提醒",
      icon: "⏰",
      description: "提醒用户已达到预设的屏幕使用时间，建议休息或停止使用",
      time: "达到限制",
      frequency: "每天",
      defaultTime: "21:00",
      repeatType: "timer",
      scenario: .digital
    ),
    LegacyAlarmTemplate(
      name: "社交应用使用时长",
      category: "数字排毒提醒",
      icon: "📱",
      description: "针对特定社交应用设置使用时长限制，超时提醒",
      time: "超时提醒",
      frequency: "每天",
      defaultTime: "20:00",
      repeatType: "timer",
      scenario: .digital
    ),
    LegacyAlarmTemplate(
      name: "睡前数字设备禁用",
      category: "数字排毒提醒",
      icon: "🌙",
      description: "提醒用户在睡前一定时间（如睡前1小时）停止使用所有数字设备",
      time: "睡前1小时",
      frequency: "每天",
      defaultTime: "21:30",
      repeatType: "daily",
      scenario: .digital
    ),

    // 内容创作提醒
    LegacyAlarmTemplate(
      name: "发布计划提醒",
      category: "内容创作提醒",
      icon: "📝",
      description: "提醒内容创作者按计划发布文章、视频或播客",
      time: "按计划",
      frequency: "定期",
      defaultTime: "10:00",
      repeatType: "custom",
      scenario: .digital
    ),
    LegacyAlarmTemplate(
      name: "素材收集提醒",
      category: "内容创作提醒",
      icon: "📸",
      description: "提醒用户收集特定主题的素材或灵感",
      time: "每周",
      frequency: "每周",
      defaultTime: "15:00",
      repeatType: "weekly",
      scenario: .digital
    ),
    LegacyAlarmTemplate(
      name: "互动回复提醒",
      category: "内容创作提醒",
      icon: "💬",
      description: "提醒用户回复社交媒体评论或私信",
      time: "每天",
      frequency: "每天",
      defaultTime: "18:00",
      repeatType: "daily",
      scenario: .digital
    ),

    // 网络安全提醒
    LegacyAlarmTemplate(
      name: "密码定期更换",
      category: "网络安全提醒",
      icon: "🔐",
      description: "提醒用户定期更换重要账户密码",
      time: "每3个月",
      frequency: "每季度",
      defaultTime: "15:00",
      repeatType: "quarterly",
      scenario: .digital
    ),
    LegacyAlarmTemplate(
      name: "软件更新提醒",
      category: "网络安全提醒",
      icon: "🔄",
      description: "提醒用户更新操作系统和应用程序，以修复安全漏洞",
      time: "有更新时",
      frequency: "按需",
      defaultTime: "20:00",
      repeatType: "custom",
      scenario: .digital
    ),
    LegacyAlarmTemplate(
      name: "数据备份提醒",
      category: "网络安全提醒",
      icon: "💾",
      description: "提醒用户定期备份重要数据",
      time: "每周",
      frequency: "每周",
      defaultTime: "20:00",
      repeatType: "weekly",
      scenario: .digital
    ),
  ]

  // MARK: - 兴趣爱好模板
  static let hobbyTemplates: [LegacyAlarmTemplate] = [
    // 阅读计划提醒
    LegacyAlarmTemplate(
      name: "每日阅读打卡",
      category: "阅读计划提醒",
      icon: "📖",
      description: "提醒用户完成每日阅读目标（如阅读页数或时长）",
      time: "30分钟",
      frequency: "每天",
      defaultTime: "21:00",
      repeatType: "daily",
      scenario: .hobby
    ),
    LegacyAlarmTemplate(
      name: "书籍借阅归还",
      category: "阅读计划提醒",
      icon: "📚",
      description: "提醒用户图书馆书籍的借阅和归还日期",
      time: "到期前3天",
      frequency: "单次",
      defaultTime: "20:00",
      repeatType: "none",
      scenario: .hobby
    ),
    LegacyAlarmTemplate(
      name: "读书会活动提醒",
      category: "阅读计划提醒",
      icon: "👥",
      description: "提醒用户参加读书会或相关活动",
      time: "提前1天",
      frequency: "每月",
      defaultTime: "19:00",
      repeatType: "monthly",
      scenario: .hobby
    ),

    // 乐器练习提醒
    LegacyAlarmTemplate(
      name: "每日练习时长",
      category: "乐器练习提醒",
      icon: "🎹",
      description: "提醒用户完成每日乐器练习时长",
      time: "45分钟",
      frequency: "每天",
      defaultTime: "19:00",
      repeatType: "daily",
      scenario: .hobby
    ),
    LegacyAlarmTemplate(
      name: "曲目学习进度",
      category: "乐器练习提醒",
      icon: "🎵",
      description: "提醒用户学习新曲目或复习旧曲目",
      time: "每周",
      frequency: "每周",
      defaultTime: "20:00",
      repeatType: "weekly",
      scenario: .hobby
    ),

    // 园艺养护提醒
    LegacyAlarmTemplate(
      name: "植物浇水施肥",
      category: "园艺养护提醒",
      icon: "🌱",
      description: "提醒用户为植物浇水、施肥或修剪",
      time: "定期",
      frequency: "2次/周",
      defaultTime: "08:00",
      repeatType: "custom",
      scenario: .hobby
    ),
    LegacyAlarmTemplate(
      name: "换盆病虫害检查",
      category: "园艺养护提醒",
      icon: "🪴",
      description: "提醒用户定期检查植物健康状况",
      time: "每月",
      frequency: "每月",
      defaultTime: "10:00",
      repeatType: "monthly",
      scenario: .hobby
    ),

    // 摄影绘画创作提醒
    LegacyAlarmTemplate(
      name: "灵感捕捉",
      category: "摄影绘画创作提醒",
      icon: "📷",
      description: "提醒用户在特定时间或地点捕捉灵感",
      time: "黄金时段",
      frequency: "每天",
      defaultTime: "17:30",
      repeatType: "daily",
      scenario: .hobby
    ),
    LegacyAlarmTemplate(
      name: "作品整理分享",
      category: "摄影绘画创作提醒",
      icon: "🎨",
      description: "提醒用户整理作品或分享到社交平台",
      time: "每周",
      frequency: "每周",
      defaultTime: "20:00",
      repeatType: "weekly",
      scenario: .hobby
    ),

    // 志愿服务提醒
    LegacyAlarmTemplate(
      name: "服务时间提醒",
      category: "志愿服务提醒",
      icon: "🤝",
      description: "提醒用户参加志愿服务活动",
      time: "按安排",
      frequency: "每月",
      defaultTime: "09:00",
      repeatType: "monthly",
      scenario: .hobby
    ),
    LegacyAlarmTemplate(
      name: "捐赠提醒",
      category: "志愿服务提醒",
      icon: "💝",
      description: "提醒用户定期进行慈善捐赠",
      time: "每季度",
      frequency: "每季度",
      defaultTime: "10:00",
      repeatType: "quarterly",
      scenario: .hobby
    ),
  ]

  // MARK: - 社区邻里模板
  static let communityTemplates: [LegacyAlarmTemplate] = [
    // 社区活动提醒
    LegacyAlarmTemplate(
      name: "社区会议活动",
      category: "社区活动提醒",
      icon: "🏛️",
      description: "提醒用户参加社区业主大会、邻里聚会等",
      time: "提前1天",
      frequency: "按通知",
      defaultTime: "19:00",
      repeatType: "custom",
      scenario: .community
    ),
    LegacyAlarmTemplate(
      name: "公共设施维护",
      category: "社区活动提醒",
      icon: "🔧",
      description: "提醒用户参与社区公共设施的维护或报修",
      time: "按需",
      frequency: "不定期",
      defaultTime: "09:00",
      repeatType: "custom",
      scenario: .community
    ),

    // 邻里互助提醒
    LegacyAlarmTemplate(
      name: "代收快递包裹",
      category: "邻里互助提醒",
      icon: "📦",
      description: "提醒用户帮助邻居代收快递",
      time: "按需",
      frequency: "不定期",
      defaultTime: "18:00",
      repeatType: "custom",
      scenario: .community
    ),
    LegacyAlarmTemplate(
      name: "宠物看护",
      category: "邻里互助提醒",
      icon: "🐕",
      description: "提醒用户帮助邻居看护宠物",
      time: "按约定",
      frequency: "按需",
      defaultTime: "08:00",
      repeatType: "custom",
      scenario: .community
    ),

    // 垃圾分类提醒
    LegacyAlarmTemplate(
      name: "特定垃圾投放日",
      category: "垃圾分类提醒",
      icon: "♻️",
      description: "根据社区规定，提醒用户特定垃圾（如大件垃圾、有害垃圾）的投放日期",
      time: "投放日",
      frequency: "每周",
      defaultTime: "07:00",
      repeatType: "weekly",
      scenario: .community
    ),
  ]

  // MARK: - 安全防护模板
  static let safetyTemplates: [LegacyAlarmTemplate] = [
    // 安全检查提醒
    LegacyAlarmTemplate(
      name: "门窗关闭检查",
      category: "安全检查提醒",
      icon: "🚪",
      description: "提醒用户睡前或出门前检查门窗是否关闭",
      time: "睡前/出门前",
      frequency: "每天",
      defaultTime: "22:00",
      repeatType: "daily",
      scenario: .safety
    ),
    LegacyAlarmTemplate(
      name: "电器断电检查",
      category: "安全检查提醒",
      icon: "🔌",
      description: "提醒用户离家前检查电器是否断电",
      time: "出门前",
      frequency: "每天",
      defaultTime: "08:00",
      repeatType: "daily",
      scenario: .safety
    ),
    LegacyAlarmTemplate(
      name: "消防设备检查",
      category: "安全检查提醒",
      icon: "🧯",
      description: "提醒用户定期检查烟雾报警器、灭火器等消防设备",
      time: "每月",
      frequency: "每月",
      defaultTime: "10:00",
      repeatType: "monthly",
      scenario: .safety
    ),

    // 紧急联系人提醒
    LegacyAlarmTemplate(
      name: "定期联系紧急联系人",
      category: "紧急联系人提醒",
      icon: "📞",
      description: "提醒用户定期与紧急联系人沟通，确保信息畅通",
      time: "每月",
      frequency: "每月",
      defaultTime: "19:00",
      repeatType: "monthly",
      scenario: .safety
    ),

    // 天气预警提醒
    LegacyAlarmTemplate(
      name: "极端天气预警",
      category: "天气预警提醒",
      icon: "⛈️",
      description: "结合天气预报，提醒用户即将到来的极端天气（如暴雨、高温、寒潮），并建议采取防护措施",
      time: "预警时",
      frequency: "按需",
      defaultTime: "07:00",
      repeatType: "custom",
      scenario: .safety
    ),
    LegacyAlarmTemplate(
      name: "自然灾害演练",
      category: "天气预警提醒",
      icon: "🚨",
      description: "提醒用户参加社区或学校组织的自然灾害演练",
      time: "演练前1天",
      frequency: "按安排",
      defaultTime: "14:00",
      repeatType: "custom",
      scenario: .safety
    ),
  ]

  // MARK: - 个人成长模板
  static let growthTemplates: [LegacyAlarmTemplate] = [
    // 日记周记提醒
    LegacyAlarmTemplate(
      name: "每日反思",
      category: "日记周记提醒",
      icon: "📔",
      description: "提醒用户记录当天的感受、学习和成长",
      time: "睡前",
      frequency: "每天",
      defaultTime: "22:30",
      repeatType: "daily",
      scenario: .growth
    ),
    LegacyAlarmTemplate(
      name: "每周总结",
      category: "日记周记提醒",
      icon: "📊",
      description: "提醒用户进行每周的工作和生活总结",
      time: "周日晚",
      frequency: "每周",
      defaultTime: "20:00",
      repeatType: "weekly",
      scenario: .growth
    ),

    // 目标回顾提醒
    LegacyAlarmTemplate(
      name: "月度季度目标回顾",
      category: "目标回顾提醒",
      icon: "🎯",
      description: "提醒用户回顾月度/季度目标完成情况，并进行调整",
      time: "月末",
      frequency: "每月",
      defaultTime: "20:00",
      repeatType: "monthly",
      scenario: .growth
    ),
    LegacyAlarmTemplate(
      name: "年度计划制定",
      category: "目标回顾提醒",
      icon: "📅",
      description: "提醒用户制定年度计划和目标",
      time: "年初",
      frequency: "每年",
      defaultTime: "10:00",
      repeatType: "yearly",
      scenario: .growth
    ),

    // 感恩练习
    LegacyAlarmTemplate(
      name: "每日感恩",
      category: "感恩练习",
      icon: "🙏",
      description: "提醒用户记录当天值得感恩的事情",
      time: "晚间",
      frequency: "每天",
      defaultTime: "21:30",
      repeatType: "daily",
      scenario: .growth
    ),

    // 冥想正念提醒
    LegacyAlarmTemplate(
      name: "每日冥想",
      category: "冥想正念提醒",
      icon: "🧘",
      description: "提醒用户进行冥想或正念练习，帮助放松身心",
      time: "15分钟",
      frequency: "每天",
      defaultTime: "06:30",
      repeatType: "daily",
      scenario: .growth
    ),
  ]

  // MARK: - 获取模板方法

  /// 根据场景类型获取对应的模板列表
  static func getTemplates(for scenario: ScenarioType) -> [LegacyAlarmTemplate] {
    switch scenario {
    case .work:
      return workTemplates
    case .study:
      return studyTemplates
    case .health:
      return healthTemplates
    case .family:
      return familyTemplates
    case .cooking:
      return cookingTemplates
    case .transport:
      return transportTemplates
    case .social:
      return socialTemplates
    case .personal:
      return personalTemplates
    case .entertainment:
      return entertainmentTemplates
    case .special:
      return specialTemplates
    case .finance:
      return financeTemplates
    case .digital:
      return digitalTemplates
    case .hobby:
      return hobbyTemplates
    case .community:
      return communityTemplates
    case .safety:
      return safetyTemplates
    case .growth:
      return growthTemplates
    }
  }

  /// 获取所有模板
  static func getAllTemplates() -> [LegacyAlarmTemplate] {
    return workTemplates + studyTemplates + healthTemplates + familyTemplates + cookingTemplates
      + transportTemplates + socialTemplates + personalTemplates + entertainmentTemplates
      + specialTemplates + financeTemplates + digitalTemplates + hobbyTemplates + communityTemplates
      + safetyTemplates + growthTemplates
  }

  /// 根据分类获取模板
  static func getTemplates(for category: String) -> [LegacyAlarmTemplate] {
    return getAllTemplates().filter { $0.category == category }
  }

  /// 搜索模板
  static func searchTemplates(keyword: String) -> [LegacyAlarmTemplate] {
    let lowercaseKeyword = keyword.lowercased()
    return getAllTemplates().filter { template in
      template.name.lowercased().contains(lowercaseKeyword)
        || template.description.lowercased().contains(lowercaseKeyword)
        || template.category.lowercased().contains(lowercaseKeyword)
    }
  }
}
