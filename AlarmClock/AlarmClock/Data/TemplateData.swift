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
            description: "提前15分钟提醒准备会议",
            time: "提前15分钟",
            frequency: "单次",
            defaultTime: "09:00",
            repeatType: "none",
            scenario: .work
        ),
        LegacyAlarmTemplate(
            name: "会议结束提醒",
            category: "会议管理",
            icon: "⏰",
            description: "会议结束前5分钟提醒总结",
            time: "结束前5分钟",
            frequency: "单次",
            defaultTime: "10:55",
            repeatType: "none",
            scenario: .work
        ),
        
        // 工作任务
        LegacyAlarmTemplate(
            name: "项目截止提醒",
            category: "工作任务",
            icon: "📋",
            description: "重要项目截止日期倒计时",
            time: "自定义",
            frequency: "单次",
            defaultTime: "17:00",
            repeatType: "none",
            scenario: .work
        ),
        LegacyAlarmTemplate(
            name: "待办事项",
            category: "工作任务",
            icon: "✅",
            description: "日常待办事项定时提醒",
            time: "每日",
            frequency: "每日",
            defaultTime: "09:30",
            repeatType: "daily",
            scenario: .work
        ),
        
        // 休息调整
        LegacyAlarmTemplate(
            name: "番茄工作法",
            category: "休息调整",
            icon: "🍅",
            description: "25分钟工作，5分钟休息",
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
            description: "每小时提醒起身活动",
            time: "每小时",
            frequency: "每小时",
            defaultTime: "10:00",
            repeatType: "hourly",
            scenario: .work
        ),
        LegacyAlarmTemplate(
            name: "喝水提醒",
            category: "休息调整",
            icon: "💧",
            description: "定时提醒补充水分",
            time: "每2小时",
            frequency: "每2小时",
            defaultTime: "10:00",
            repeatType: "interval",
            scenario: .work
        ),
        LegacyAlarmTemplate(
            name: "护眼提醒",
            category: "休息调整",
            icon: "👁️",
            description: "20-20-20法则护眼",
            time: "每20分钟",
            frequency: "每20分钟",
            defaultTime: "09:20",
            repeatType: "interval",
            scenario: .work
        ),
        
        // 沟通协作
        LegacyAlarmTemplate(
            name: "客户约定",
            category: "沟通协作",
            icon: "🤝",
            description: "与客户的重要约定提醒",
            time: "自定义",
            frequency: "单次",
            defaultTime: "14:00",
            repeatType: "none",
            scenario: .work
        ),
        LegacyAlarmTemplate(
            name: "邮件跟进",
            category: "沟通协作",
            icon: "📧",
            description: "重要邮件延时跟进提醒",
            time: "1天后",
            frequency: "延时",
            defaultTime: "09:00",
            repeatType: "none",
            scenario: .work
        ),
        
        // 行政事务
        LegacyAlarmTemplate(
            name: "报销截止",
            category: "行政事务",
            icon: "💰",
            description: "月度报销截止日期提醒",
            time: "每月25日",
            frequency: "每月",
            defaultTime: "16:00",
            repeatType: "monthly",
            scenario: .work
        )
    ]
    
    // MARK: - 学习场景模板
    static let studyTemplates: [LegacyAlarmTemplate] = [
        // 课程管理
        LegacyAlarmTemplate(
            name: "上课提醒",
            category: "课程管理",
            icon: "🎓",
            description: "课程开始前10分钟提醒",
            time: "提前10分钟",
            frequency: "按课表",
            defaultTime: "08:50",
            repeatType: "weekly",
            scenario: .study
        ),
        LegacyAlarmTemplate(
            name: "课间休息",
            category: "课程管理",
            icon: "☕",
            description: "课间休息时间提醒",
            time: "课间",
            frequency: "按课表",
            defaultTime: "10:00",
            repeatType: "weekly",
            scenario: .study
        ),
        
        // 考试作业
        LegacyAlarmTemplate(
            name: "作业截止",
            category: "考试作业",
            icon: "📝",
            description: "作业提交截止日期提醒",
            time: "截止前1天",
            frequency: "单次",
            defaultTime: "20:00",
            repeatType: "none",
            scenario: .study
        ),
        LegacyAlarmTemplate(
            name: "考试倒计时",
            category: "考试作业",
            icon: "⏳",
            description: "重要考试倒计时提醒",
            time: "考前1周",
            frequency: "倒计时",
            defaultTime: "19:00",
            repeatType: "countdown",
            scenario: .study
        ),
        
        // 自主学习
        LegacyAlarmTemplate(
            name: "学习计划",
            category: "自主学习",
            icon: "📖",
            description: "每日学习计划执行提醒",
            time: "每日",
            frequency: "每日",
            defaultTime: "19:30",
            repeatType: "daily",
            scenario: .study
        ),
        LegacyAlarmTemplate(
            name: "复习提醒",
            category: "自主学习",
            icon: "🔄",
            description: "定期复习知识点提醒",
            time: "每周",
            frequency: "每周",
            defaultTime: "20:00",
            repeatType: "weekly",
            scenario: .study
        )
    ]   
 
    // MARK: - 健康场景模板
    static let healthTemplates: [LegacyAlarmTemplate] = [
        // 日常健康
        LegacyAlarmTemplate(
            name: "晨间锻炼",
            category: "日常健康",
            icon: "🏃",
            description: "每日晨间运动提醒",
            time: "每日",
            frequency: "每日",
            defaultTime: "06:30",
            repeatType: "daily",
            scenario: .health
        ),
        LegacyAlarmTemplate(
            name: "睡前准备",
            category: "日常健康",
            icon: "🛏️",
            description: "睡前放松准备提醒",
            time: "每晚",
            frequency: "每日",
            defaultTime: "22:00",
            repeatType: "daily",
            scenario: .health
        ),
        
        // 药物提醒
        LegacyAlarmTemplate(
            name: "服药提醒",
            category: "药物提醒",
            icon: "💊",
            description: "按时服药提醒",
            time: "每日3次",
            frequency: "每日",
            defaultTime: "08:00",
            repeatType: "multiple",
            scenario: .health
        ),
        LegacyAlarmTemplate(
            name: "维生素补充",
            category: "药物提醒",
            icon: "🍊",
            description: "每日维生素补充提醒",
            time: "每日",
            frequency: "每日",
            defaultTime: "08:30",
            repeatType: "daily",
            scenario: .health
        ),
        
        // 运动锻炼
        LegacyAlarmTemplate(
            name: "健身房时间",
            category: "运动锻炼",
            icon: "💪",
            description: "健身房锻炼时间提醒",
            time: "每周3次",
            frequency: "每周",
            defaultTime: "18:00",
            repeatType: "weekly",
            scenario: .health
        ),
        LegacyAlarmTemplate(
            name: "瑜伽练习",
            category: "运动锻炼",
            icon: "🧘",
            description: "瑜伽冥想练习提醒",
            time: "每日",
            frequency: "每日",
            defaultTime: "07:00",
            repeatType: "daily",
            scenario: .health
        )
    ]
    
    // MARK: - 家庭场景模板
    static let familyTemplates: [LegacyAlarmTemplate] = [
        // 家务管理
        LegacyAlarmTemplate(
            name: "打扫卫生",
            category: "家务管理",
            icon: "🧹",
            description: "每周大扫除提醒",
            time: "每周",
            frequency: "每周",
            defaultTime: "10:00",
            repeatType: "weekly",
            scenario: .family
        ),
        LegacyAlarmTemplate(
            name: "洗衣服",
            category: "家务管理",
            icon: "👕",
            description: "洗衣服时间提醒",
            time: "每周2次",
            frequency: "每周",
            defaultTime: "09:00",
            repeatType: "weekly",
            scenario: .family
        ),
        
        // 儿童照顾
        LegacyAlarmTemplate(
            name: "接送孩子",
            category: "儿童照顾",
            icon: "🚌",
            description: "接送孩子上下学提醒",
            time: "工作日",
            frequency: "工作日",
            defaultTime: "07:30",
            repeatType: "weekdays",
            scenario: .family
        ),
        LegacyAlarmTemplate(
            name: "孩子作业",
            category: "儿童照顾",
            icon: "📚",
            description: "督促孩子完成作业",
            time: "每日",
            frequency: "每日",
            defaultTime: "19:00",
            repeatType: "daily",
            scenario: .family
        ),
        
        // 宠物护理
        LegacyAlarmTemplate(
            name: "宠物喂食",
            category: "宠物护理",
            icon: "🐕",
            description: "宠物定时喂食提醒",
            time: "每日2次",
            frequency: "每日",
            defaultTime: "08:00",
            repeatType: "multiple",
            scenario: .family
        ),
        LegacyAlarmTemplate(
            name: "遛狗时间",
            category: "宠物护理",
            icon: "🦮",
            description: "每日遛狗时间提醒",
            time: "每日",
            frequency: "每日",
            defaultTime: "18:30",
            repeatType: "daily",
            scenario: .family
        )
    ]
    
    // MARK: - 烹饪场景模板
    static let cookingTemplates: [LegacyAlarmTemplate] = [
        // 食材准备
        LegacyAlarmTemplate(
            name: "买菜提醒",
            category: "食材准备",
            icon: "🛒",
            description: "每周买菜时间提醒",
            time: "每周",
            frequency: "每周",
            defaultTime: "09:00",
            repeatType: "weekly",
            scenario: .cooking
        ),
        LegacyAlarmTemplate(
            name: "食材解冻",
            category: "食材准备",
            icon: "🧊",
            description: "提前解冻食材提醒",
            time: "提前2小时",
            frequency: "单次",
            defaultTime: "16:00",
            repeatType: "none",
            scenario: .cooking
        ),
        
        // 烹饪计时
        LegacyAlarmTemplate(
            name: "煮饭时间",
            category: "烹饪计时",
            icon: "🍚",
            description: "煮饭时间计时提醒",
            time: "30分钟",
            frequency: "计时",
            defaultTime: "17:30",
            repeatType: "timer",
            scenario: .cooking
        ),
        LegacyAlarmTemplate(
            name: "炖汤提醒",
            category: "烹饪计时",
            icon: "🍲",
            description: "炖汤时间计时提醒",
            time: "2小时",
            frequency: "计时",
            defaultTime: "15:00",
            repeatType: "timer",
            scenario: .cooking
        ),
        
        // 烘焙活动
        LegacyAlarmTemplate(
            name: "烘焙计时",
            category: "烘焙活动",
            icon: "🧁",
            description: "烘焙时间精确计时",
            time: "自定义",
            frequency: "计时",
            defaultTime: "14:00",
            repeatType: "timer",
            scenario: .cooking
        ),
        LegacyAlarmTemplate(
            name: "发酵提醒",
            category: "烘焙活动",
            icon: "🍞",
            description: "面团发酵时间提醒",
            time: "1小时",
            frequency: "计时",
            defaultTime: "10:00",
            repeatType: "timer",
            scenario: .cooking
        )
    ]    

    // MARK: - 出行场景模板
    static let transportTemplates: [LegacyAlarmTemplate] = [
        // 日常通勤
        LegacyAlarmTemplate(
            name: "上班出门",
            category: "日常通勤",
            icon: "🚇",
            description: "上班出门时间提醒",
            time: "工作日",
            frequency: "工作日",
            defaultTime: "08:00",
            repeatType: "weekdays",
            scenario: .transport
        ),
        LegacyAlarmTemplate(
            name: "下班提醒",
            category: "日常通勤",
            icon: "🏠",
            description: "下班时间提醒",
            time: "工作日",
            frequency: "工作日",
            defaultTime: "17:30",
            repeatType: "weekdays",
            scenario: .transport
        ),
        
        // 长途旅行
        LegacyAlarmTemplate(
            name: "航班提醒",
            category: "长途旅行",
            icon: "✈️",
            description: "航班起飞前2小时提醒",
            time: "提前2小时",
            frequency: "单次",
            defaultTime: "06:00",
            repeatType: "none",
            scenario: .transport
        ),
        LegacyAlarmTemplate(
            name: "火车提醒",
            category: "长途旅行",
            icon: "🚄",
            description: "火车发车前1小时提醒",
            time: "提前1小时",
            frequency: "单次",
            defaultTime: "08:00",
            repeatType: "none",
            scenario: .transport
        ),
        
        // 车辆维护
        LegacyAlarmTemplate(
            name: "保养提醒",
            category: "车辆维护",
            icon: "🔧",
            description: "车辆定期保养提醒",
            time: "每3个月",
            frequency: "每季度",
            defaultTime: "10:00",
            repeatType: "quarterly",
            scenario: .transport
        ),
        LegacyAlarmTemplate(
            name: "年检提醒",
            category: "车辆维护",
            icon: "📋",
            description: "车辆年检时间提醒",
            time: "每年",
            frequency: "每年",
            defaultTime: "09:00",
            repeatType: "yearly",
            scenario: .transport
        )
    ]
    
    // MARK: - 社交场景模板
    static let socialTemplates: [LegacyAlarmTemplate] = [
        // 社交约会
        LegacyAlarmTemplate(
            name: "约会提醒",
            category: "社交约会",
            icon: "💕",
            description: "约会时间提前提醒",
            time: "提前30分钟",
            frequency: "单次",
            defaultTime: "19:00",
            repeatType: "none",
            scenario: .social
        ),
        LegacyAlarmTemplate(
            name: "聚会准备",
            category: "社交约会",
            icon: "🎉",
            description: "聚会准备时间提醒",
            time: "提前1小时",
            frequency: "单次",
            defaultTime: "18:00",
            repeatType: "none",
            scenario: .social
        ),
        
        // 人际维护
        LegacyAlarmTemplate(
            name: "生日提醒",
            category: "人际维护",
            icon: "🎂",
            description: "朋友生日提前提醒",
            time: "提前1天",
            frequency: "每年",
            defaultTime: "10:00",
            repeatType: "yearly",
            scenario: .social
        ),
        LegacyAlarmTemplate(
            name: "联系朋友",
            category: "人际维护",
            icon: "📞",
            description: "定期联系朋友提醒",
            time: "每月",
            frequency: "每月",
            defaultTime: "20:00",
            repeatType: "monthly",
            scenario: .social
        ),
        
        // 社交礼仪
        LegacyAlarmTemplate(
            name: "感谢信",
            category: "社交礼仪",
            icon: "💌",
            description: "发送感谢信提醒",
            time: "事后1天",
            frequency: "单次",
            defaultTime: "10:00",
            repeatType: "none",
            scenario: .social
        ),
        LegacyAlarmTemplate(
            name: "回访提醒",
            category: "社交礼仪",
            icon: "🔄",
            description: "客户回访时间提醒",
            time: "1周后",
            frequency: "单次",
            defaultTime: "14:00",
            repeatType: "none",
            scenario: .social
        )
    ]
    
    // MARK: - 个人护理场景模板
    static let personalTemplates: [LegacyAlarmTemplate] = [
        // 日常清洁
        LegacyAlarmTemplate(
            name: "洗脸护肤",
            category: "日常清洁",
            icon: "🧴",
            description: "早晚洗脸护肤提醒",
            time: "每日2次",
            frequency: "每日",
            defaultTime: "07:00",
            repeatType: "multiple",
            scenario: .personal
        ),
        LegacyAlarmTemplate(
            name: "刷牙提醒",
            category: "日常清洁",
            icon: "🦷",
            description: "餐后刷牙提醒",
            time: "餐后",
            frequency: "每日",
            defaultTime: "08:30",
            repeatType: "multiple",
            scenario: .personal
        ),
        
        // 皮肤护理
        LegacyAlarmTemplate(
            name: "面膜时间",
            category: "皮肤护理",
            icon: "🧖",
            description: "每周面膜护理提醒",
            time: "每周2次",
            frequency: "每周",
            defaultTime: "20:00",
            repeatType: "weekly",
            scenario: .personal
        ),
        LegacyAlarmTemplate(
            name: "防晒提醒",
            category: "皮肤护理",
            icon: "☀️",
            description: "出门前防晒提醒",
            time: "出门前",
            frequency: "每日",
            defaultTime: "08:00",
            repeatType: "daily",
            scenario: .personal
        ),
        
        // 美容美发
        LegacyAlarmTemplate(
            name: "理发预约",
            category: "美容美发",
            icon: "💇",
            description: "定期理发预约提醒",
            time: "每月",
            frequency: "每月",
            defaultTime: "15:00",
            repeatType: "monthly",
            scenario: .personal
        ),
        LegacyAlarmTemplate(
            name: "美甲护理",
            category: "美容美发",
            icon: "💅",
            description: "美甲护理时间提醒",
            time: "每2周",
            frequency: "每2周",
            defaultTime: "14:00",
            repeatType: "biweekly",
            scenario: .personal
        )
    ]
    
    // MARK: - 娱乐场景模板
    static let entertainmentTemplates: [LegacyAlarmTemplate] = [
        // 数字娱乐
        LegacyAlarmTemplate(
            name: "游戏时间",
            category: "数字娱乐",
            icon: "🎮",
            description: "游戏时间控制提醒",
            time: "1小时后",
            frequency: "计时",
            defaultTime: "20:00",
            repeatType: "timer",
            scenario: .entertainment
        ),
        LegacyAlarmTemplate(
            name: "追剧时间",
            category: "数字娱乐",
            icon: "📺",
            description: "追剧时间控制提醒",
            time: "2小时后",
            frequency: "计时",
            defaultTime: "21:00",
            repeatType: "timer",
            scenario: .entertainment
        ),
        
        // 户外活动
        LegacyAlarmTemplate(
            name: "户外运动",
            category: "户外活动",
            icon: "🏃",
            description: "户外运动时间提醒",
            time: "每周",
            frequency: "每周",
            defaultTime: "16:00",
            repeatType: "weekly",
            scenario: .entertainment
        ),
        LegacyAlarmTemplate(
            name: "公园散步",
            category: "户外活动",
            icon: "🌳",
            description: "公园散步时间提醒",
            time: "每日",
            frequency: "每日",
            defaultTime: "18:00",
            repeatType: "daily",
            scenario: .entertainment
        ),
        
        // 文化娱乐
        LegacyAlarmTemplate(
            name: "电影时间",
            category: "文化娱乐",
            icon: "🎬",
            description: "电影开场前提醒",
            time: "提前30分钟",
            frequency: "单次",
            defaultTime: "19:30",
            repeatType: "none",
            scenario: .entertainment
        ),
        LegacyAlarmTemplate(
            name: "音乐会",
            category: "文化娱乐",
            icon: "🎵",
            description: "音乐会开始前提醒",
            time: "提前1小时",
            frequency: "单次",
            defaultTime: "19:00",
            repeatType: "none",
            scenario: .entertainment
        )
    ]
    
    // MARK: - 特殊场景模板
    static let specialTemplates: [LegacyAlarmTemplate] = [
        // 节日庆典
        LegacyAlarmTemplate(
            name: "节日准备",
            category: "节日庆典",
            icon: "🎄",
            description: "节日庆典准备提醒",
            time: "提前1周",
            frequency: "每年",
            defaultTime: "10:00",
            repeatType: "yearly",
            scenario: .special
        ),
        LegacyAlarmTemplate(
            name: "礼物准备",
            category: "节日庆典",
            icon: "🎁",
            description: "节日礼物准备提醒",
            time: "提前3天",
            frequency: "每年",
            defaultTime: "15:00",
            repeatType: "yearly",
            scenario: .special
        ),
        
        // 重要时刻
        LegacyAlarmTemplate(
            name: "纪念日",
            category: "重要时刻",
            icon: "💖",
            description: "重要纪念日提醒",
            time: "当天",
            frequency: "每年",
            defaultTime: "09:00",
            repeatType: "yearly",
            scenario: .special
        ),
        LegacyAlarmTemplate(
            name: "里程碑",
            category: "重要时刻",
            icon: "🏆",
            description: "人生里程碑提醒",
            time: "当天",
            frequency: "单次",
            defaultTime: "12:00",
            repeatType: "none",
            scenario: .special
        ),
        
        // 纪念活动
        LegacyAlarmTemplate(
            name: "祭祀活动",
            category: "纪念活动",
            icon: "🕯️",
            description: "祭祀纪念活动提醒",
            time: "每年",
            frequency: "每年",
            defaultTime: "10:00",
            repeatType: "yearly",
            scenario: .special
        ),
        LegacyAlarmTemplate(
            name: "追思时刻",
            category: "纪念活动",
            icon: "🌹",
            description: "追思纪念时刻提醒",
            time: "每年",
            frequency: "每年",
            defaultTime: "14:00",
            repeatType: "yearly",
            scenario: .special
        )
    ]
    
    // MARK: - 扩展场景模板
    
    // 财务管理模板
    static let financeTemplates: [LegacyAlarmTemplate] = [
        LegacyAlarmTemplate(
            name: "投资检查",
            category: "投资理财",
            icon: "📈",
            description: "定期投资组合检查",
            time: "每月",
            frequency: "每月",
            defaultTime: "09:00",
            repeatType: "monthly",
            scenario: .finance
        ),
        LegacyAlarmTemplate(
            name: "预算回顾",
            category: "预算控制",
            icon: "💳",
            description: "月度预算执行回顾",
            time: "每月末",
            frequency: "每月",
            defaultTime: "20:00",
            repeatType: "monthly",
            scenario: .finance
        ),
        LegacyAlarmTemplate(
            name: "税务准备",
            category: "税务合规",
            icon: "📊",
            description: "年度税务申报准备",
            time: "每年3月",
            frequency: "每年",
            defaultTime: "10:00",
            repeatType: "yearly",
            scenario: .finance
        )
    ]
    
    // 数字健康模板
    static let digitalTemplates: [LegacyAlarmTemplate] = [
        LegacyAlarmTemplate(
            name: "屏幕休息",
            category: "屏幕时间",
            icon: "📱",
            description: "屏幕使用时间控制",
            time: "每2小时",
            frequency: "每2小时",
            defaultTime: "10:00",
            repeatType: "interval",
            scenario: .digital
        ),
        LegacyAlarmTemplate(
            name: "创作时间",
            category: "内容创作",
            icon: "✍️",
            description: "内容创作专注时间",
            time: "每日",
            frequency: "每日",
            defaultTime: "14:00",
            repeatType: "daily",
            scenario: .digital
        ),
        LegacyAlarmTemplate(
            name: "密码更新",
            category: "网络安全",
            icon: "🔐",
            description: "定期密码更新提醒",
            time: "每3个月",
            frequency: "每季度",
            defaultTime: "15:00",
            repeatType: "quarterly",
            scenario: .digital
        )
    ]    

    // 兴趣爱好模板
    static let hobbyTemplates: [LegacyAlarmTemplate] = [
        LegacyAlarmTemplate(
            name: "阅读时间",
            category: "阅读计划",
            icon: "📖",
            description: "每日阅读时间提醒",
            time: "每日",
            frequency: "每日",
            defaultTime: "21:00",
            repeatType: "daily",
            scenario: .hobby
        ),
        LegacyAlarmTemplate(
            name: "乐器练习",
            category: "乐器练习",
            icon: "🎹",
            description: "乐器练习时间提醒",
            time: "每日",
            frequency: "每日",
            defaultTime: "19:00",
            repeatType: "daily",
            scenario: .hobby
        ),
        LegacyAlarmTemplate(
            name: "园艺浇水",
            category: "园艺创作",
            icon: "🌱",
            description: "植物浇水护理提醒",
            time: "每2天",
            frequency: "每2天",
            defaultTime: "08:00",
            repeatType: "interval",
            scenario: .hobby
        )
    ]
    
    // 社区邻里模板
    static let communityTemplates: [LegacyAlarmTemplate] = [
        LegacyAlarmTemplate(
            name: "社区活动",
            category: "社区活动",
            icon: "🏘️",
            description: "社区活动参与提醒",
            time: "每月",
            frequency: "每月",
            defaultTime: "15:00",
            repeatType: "monthly",
            scenario: .community
        ),
        LegacyAlarmTemplate(
            name: "邻里互助",
            category: "邻里互助",
            icon: "🤝",
            description: "邻里互助活动提醒",
            time: "每周",
            frequency: "每周",
            defaultTime: "10:00",
            repeatType: "weekly",
            scenario: .community
        ),
        LegacyAlarmTemplate(
            name: "环保行动",
            category: "环保行动",
            icon: "♻️",
            description: "环保活动参与提醒",
            time: "每月",
            frequency: "每月",
            defaultTime: "09:00",
            repeatType: "monthly",
            scenario: .community
        )
    ]
    
    // 安全防护模板
    static let safetyTemplates: [LegacyAlarmTemplate] = [
        LegacyAlarmTemplate(
            name: "安全检查",
            category: "安全检查",
            icon: "🔍",
            description: "家庭安全设备检查",
            time: "每月",
            frequency: "每月",
            defaultTime: "10:00",
            repeatType: "monthly",
            scenario: .safety
        ),
        LegacyAlarmTemplate(
            name: "紧急联系",
            category: "紧急联系",
            icon: "🚨",
            description: "紧急联系人信息更新",
            time: "每6个月",
            frequency: "每半年",
            defaultTime: "14:00",
            repeatType: "biannual",
            scenario: .safety
        ),
        LegacyAlarmTemplate(
            name: "天气预警",
            category: "天气预警",
            icon: "🌪️",
            description: "恶劣天气预警提醒",
            time: "实时",
            frequency: "实时",
            defaultTime: "07:00",
            repeatType: "realtime",
            scenario: .safety
        )
    ]
    
    // 个人成长模板
    static let growthTemplates: [LegacyAlarmTemplate] = [
        LegacyAlarmTemplate(
            name: "自我反思",
            category: "自我反思",
            icon: "🤔",
            description: "每日自我反思时间",
            time: "每日",
            frequency: "每日",
            defaultTime: "22:30",
            repeatType: "daily",
            scenario: .growth
        ),
        LegacyAlarmTemplate(
            name: "目标回顾",
            category: "目标管理",
            icon: "🎯",
            description: "月度目标进度回顾",
            time: "每月",
            frequency: "每月",
            defaultTime: "20:00",
            repeatType: "monthly",
            scenario: .growth
        ),
        LegacyAlarmTemplate(
            name: "冥想练习",
            category: "心理健康",
            icon: "🧘",
            description: "每日冥想练习提醒",
            time: "每日",
            frequency: "每日",
            defaultTime: "06:00",
            repeatType: "daily",
            scenario: .growth
        )
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
        return workTemplates + studyTemplates + healthTemplates + familyTemplates +
               cookingTemplates + transportTemplates + socialTemplates + personalTemplates +
               entertainmentTemplates + specialTemplates + financeTemplates + digitalTemplates +
               hobbyTemplates + communityTemplates + safetyTemplates + growthTemplates
    }
    
    /// 根据分类获取模板
    static func getTemplates(for category: String) -> [LegacyAlarmTemplate] {
        return getAllTemplates().filter { $0.category == category }
    }
    
    /// 搜索模板
    static func searchTemplates(keyword: String) -> [LegacyAlarmTemplate] {
        let lowercaseKeyword = keyword.lowercased()
        return getAllTemplates().filter { template in
            template.name.lowercased().contains(lowercaseKeyword) ||
            template.description.lowercased().contains(lowercaseKeyword) ||
            template.category.lowercased().contains(lowercaseKeyword)
        }
    }
}