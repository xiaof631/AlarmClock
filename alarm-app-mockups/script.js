// iOS闹钟应用交互脚本

// 屏幕切换功能 - 定义为全局函数
window.showScreen = function(screenId) {
    // 隐藏所有屏幕
    const screens = document.querySelectorAll('.screen');
    screens.forEach(screen => {
        screen.classList.remove('active');
    });
    
    // 显示目标屏幕
    const targetScreen = document.getElementById(screenId);
    if (targetScreen) {
        targetScreen.classList.add('active');
    }
    
    console.log('切换到屏幕:', screenId); // 调试信息
}

// 切换开关状态
function toggleSwitch(element) {
    element.classList.toggle('on');
}

// 初始化交互事件
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM加载完成，初始化事件监听器');
    
    // 控制按钮事件监听器
    const controlButtons = document.querySelectorAll('.controls button');
    controlButtons.forEach(button => {
        button.addEventListener('click', function() {
            const screenId = this.getAttribute('data-screen');
            console.log('点击控制按钮，目标屏幕:', screenId);
            showScreen(screenId);
        });
    });
    // 闹钟开关切换
    const alarmToggles = document.querySelectorAll('.alarm-toggle');
    alarmToggles.forEach(toggle => {
        toggle.addEventListener('click', function() {
            toggleSwitch(this);
            
            // 更新闹钟卡片状态
            const alarmCard = this.closest('.alarm-card');
            if (this.classList.contains('on')) {
                alarmCard.classList.add('active');
            } else {
                alarmCard.classList.remove('active');
            }
        });
    });
    
    // 设置开关切换
    const settingToggles = document.querySelectorAll('.toggle-switch');
    settingToggles.forEach(toggle => {
        toggle.addEventListener('click', function() {
            toggleSwitch(this);
        });
    });
    
    // 上午/下午切换
    const amPmButtons = document.querySelectorAll('.am-pm-toggle button');
    amPmButtons.forEach(button => {
        button.addEventListener('click', function() {
            // 移除所有active类
            amPmButtons.forEach(btn => btn.classList.remove('active'));
            // 添加active类到当前按钮
            this.classList.add('active');
        });
    });
    
    // 场景卡片点击效果
    const scenarioCards = document.querySelectorAll('.scenario-card');
    scenarioCards.forEach(card => {
        card.addEventListener('click', function() {
            // 移除所有选中状态
            scenarioCards.forEach(c => c.classList.remove('selected'));
            // 添加选中状态
            this.classList.add('selected');
            
            // 获取场景类型并显示对应模板
            const scenarioType = this.getAttribute('data-scenario');
            showScenarioTemplates(scenarioType);
            
            setTimeout(() => {
                showScreen('scenario-templates');
            }, 300);
        });
    });
    
    // 添加闹钟按钮
    const addBtn = document.querySelector('.add-btn');
    if (addBtn) {
        addBtn.addEventListener('click', function() {
            showScreen('alarm-setup');
        });
    }
    
    // 返回按钮
    const backBtns = document.querySelectorAll('.back-btn');
    backBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            showScreen('alarm-list');
        });
    });
    
    // 保存按钮
    const saveBtn = document.querySelector('.save-btn');
    if (saveBtn) {
        saveBtn.addEventListener('click', function() {
            // 这里可以添加保存逻辑
            showScreen('alarm-list');
        });
    }
    
    // 闹钟响铃界面按钮
    const snoozeBtn = document.querySelector('.snooze-btn');
    const stopBtn = document.querySelector('.stop-btn');
    
    if (snoozeBtn) {
        snoozeBtn.addEventListener('click', function() {
            // 贪睡逻辑
            showScreen('alarm-list');
        });
    }
    
    if (stopBtn) {
        stopBtn.addEventListener('click', function() {
            // 停止闹钟逻辑
            showScreen('alarm-list');
        });
    }
    
    // 时间选择器交互（简化版）
    const timeDisplay = document.querySelector('.time-display');
    if (timeDisplay) {
        timeDisplay.addEventListener('click', function() {
            // 这里可以添加时间选择器的详细交互
            console.log('时间选择器被点击');
        });
    }
    
    // 设置项点击
    const settingItems = document.querySelectorAll('.setting-item');
    settingItems.forEach(item => {
        const chevron = item.querySelector('.chevron');
        if (chevron) {
            item.addEventListener('click', function() {
                // 这里可以添加设置项的详细页面
                console.log('设置项被点击:', item.querySelector('.setting-label').textContent);
            });
        }
    });
});

// 模拟实时时间更新
function updateTime() {
    const now = new Date();
    const timeString = now.toLocaleTimeString('zh-CN', { 
        hour12: false, 
        hour: '2-digit', 
        minute: '2-digit' 
    });
    
    const statusTime = document.querySelector('.status-bar .time');
    if (statusTime) {
        statusTime.textContent = timeString;
    }
}

// 每秒更新时间
setInterval(updateTime, 1000);

// 添加触摸反馈效果
document.addEventListener('touchstart', function(e) {
    if (e.target.classList.contains('scenario-card') || 
        e.target.classList.contains('alarm-card') ||
        e.target.closest('.scenario-card') ||
        e.target.closest('.alarm-card')) {
        e.target.style.transform = 'scale(0.95)';
    }
});

document.addEventListener('touchend', function(e) {
    if (e.target.classList.contains('scenario-card') || 
        e.target.classList.contains('alarm-card') ||
        e.target.closest('.scenario-card') ||
        e.target.closest('.alarm-card')) {
        setTimeout(() => {
            e.target.style.transform = 'scale(1)';
        }, 150);
    }
});

// 键盘导航支持
document.addEventListener('keydown', function(e) {
    switch(e.key) {
        case '1':
            showScreen('alarm-list');
            break;
        case '2':
            showScreen('alarm-setup');
            break;
        case '3':
            showScreen('scenarios');
            break;
        case '4':
            showScreen('alarm-alert');
            break;
        case 'Escape':
            showScreen('alarm-list');
            break;
    }
});

// ==================== 场景模板数据和功能 ====================

// 场景模板数据
const scenarioTemplates = {
    work: {
        title: '工作场景模板',
        icon: '💼',
        templates: [
            {
                name: '会议提醒',
                category: '会议管理',
                icon: '📅',
                desc: '会议开始前15分钟提醒，确保准时参会',
                time: '提前15分钟',
                frequency: '单次',
                defaultTime: '09:00',
                repeat: 'never'
            },
            {
                name: '番茄工作法',
                category: '休息调整',
                icon: '🍅',
                desc: '25分钟专注工作，5分钟休息',
                time: '25分钟',
                frequency: '循环',
                defaultTime: '09:00',
                repeat: 'custom'
            },
            {
                name: '久坐提醒',
                category: '休息调整',
                icon: '🚶',
                desc: '每小时提醒起身活动，保护健康',
                time: '每小时',
                frequency: '重复',
                defaultTime: '09:00',
                repeat: 'hourly'
            },
            {
                name: '喝水提醒',
                category: '休息调整',
                icon: '💧',
                desc: '定时提醒补充水分',
                time: '每2小时',
                frequency: '重复',
                defaultTime: '08:00',
                repeat: 'custom'
            },
            {
                name: '午休提醒',
                category: '休息调整',
                icon: '😴',
                desc: '午休开始和结束时间提醒',
                time: '12:00-13:00',
                frequency: '工作日',
                defaultTime: '12:00',
                repeat: 'weekdays'
            },
            {
                name: '项目截止提醒',
                category: '任务管理',
                icon: '⏰',
                desc: '项目截止日期倒计时提醒',
                time: '提前1天',
                frequency: '单次',
                defaultTime: '09:00',
                repeat: 'never'
            }
        ]
    },
    study: {
        title: '学习场景模板',
        icon: '📚',
        templates: [
            {
                name: '上课提醒',
                category: '课程管理',
                icon: '🎓',
                desc: '提前15分钟提醒准备上课',
                time: '提前15分钟',
                frequency: '按课表',
                defaultTime: '08:45',
                repeat: 'custom'
            },
            {
                name: '考试倒计时',
                category: '考试作业',
                icon: '📝',
                desc: '重要考试倒计时和复习提醒',
                time: '提前7天',
                frequency: '阶段性',
                defaultTime: '20:00',
                repeat: 'custom'
            },
            {
                name: '学习时间',
                category: '自主学习',
                icon: '📖',
                desc: '每日固定学习时间提醒',
                time: '2小时',
                frequency: '每天',
                defaultTime: '19:00',
                repeat: 'daily'
            },
            {
                name: '语言学习打卡',
                category: '自主学习',
                icon: '🗣️',
                desc: '每日单词背诵和口语练习',
                time: '30分钟',
                frequency: '每天',
                defaultTime: '07:30',
                repeat: 'daily'
            },
            {
                name: '图书归还',
                category: '学习资源',
                icon: '📚',
                desc: '图书馆借阅到期提醒',
                time: '提前3天',
                frequency: '单次',
                defaultTime: '10:00',
                repeat: 'never'
            },
            {
                name: '作业提交',
                category: '考试作业',
                icon: '📋',
                desc: '作业截止日期提醒',
                time: '提前1天',
                frequency: '单次',
                defaultTime: '21:00',
                repeat: 'never'
            }
        ]
    },
    health: {
        title: '健康运动模板',
        icon: '❤️',
        templates: [
            {
                name: '喝水提醒',
                category: '日常健康',
                icon: '💧',
                desc: '定时提醒补充水分',
                time: '每2小时',
                frequency: '重复',
                defaultTime: '08:00',
                repeat: 'custom'
            },
            {
                name: '服药提醒',
                category: '药物服用',
                icon: '💊',
                desc: '按时服用处方药物',
                time: '准时',
                frequency: '每天',
                defaultTime: '08:00',
                repeat: 'daily'
            },
            {
                name: '运动时间',
                category: '运动锻炼',
                icon: '🏃',
                desc: '每日运动锻炼提醒',
                time: '1小时',
                frequency: '每天',
                defaultTime: '18:00',
                repeat: 'daily'
            },
            {
                name: '体重测量',
                category: '健康监测',
                icon: '⚖️',
                desc: '定期测量体重记录',
                time: '晨起',
                frequency: '每周',
                defaultTime: '07:00',
                repeat: 'weekly'
            },
            {
                name: '睡眠提醒',
                category: '日常健康',
                icon: '🌙',
                desc: '规律作息睡眠提醒',
                time: '准时',
                frequency: '每天',
                defaultTime: '22:30',
                repeat: 'daily'
            },
            {
                name: 'HIIT训练',
                category: '运动锻炼',
                icon: '💪',
                desc: '高强度间歇训练计时',
                time: '30分钟',
                frequency: '3次/周',
                defaultTime: '17:00',
                repeat: 'custom'
            }
        ]
    },
    family: {
        title: '家庭生活模板',
        icon: '🏠',
        templates: [
            {
                name: '垃圾分类',
                category: '家务管理',
                icon: '🗑️',
                desc: '垃圾投放时间提醒',
                time: '准时',
                frequency: '每周',
                defaultTime: '07:00',
                repeat: 'weekly'
            },
            {
                name: '宠物喂食',
                category: '宠物照料',
                icon: '🐕',
                desc: '按时喂养宠物',
                time: '准时',
                frequency: '每天',
                defaultTime: '07:00',
                repeat: 'daily'
            },
            {
                name: '账单支付',
                category: '家庭财务',
                icon: '💳',
                desc: '水电煤、信用卡账单提醒',
                time: '提前3天',
                frequency: '每月',
                defaultTime: '10:00',
                repeat: 'monthly'
            },
            {
                name: '家电维护',
                category: '家务管理',
                icon: '🔧',
                desc: '定期清洁空调滤网等',
                time: '定期',
                frequency: '每月',
                defaultTime: '10:00',
                repeat: 'monthly'
            },
            {
                name: '儿童睡眠',
                category: '儿童照顾',
                icon: '👶',
                desc: '孩子按时午睡晚睡',
                time: '准时',
                frequency: '每天',
                defaultTime: '21:00',
                repeat: 'daily'
            },
            {
                name: '洗衣提醒',
                category: '家务管理',
                icon: '👕',
                desc: '洗衣和晾晒衣物提醒',
                time: '定时',
                frequency: '2次/周',
                defaultTime: '09:00',
                repeat: 'custom'
            }
        ]
    },
    cooking: {
        title: '厨房烹饪模板',
        icon: '🍳',
        templates: [
            {
                name: '食材解冻',
                category: '食材准备',
                icon: '🧊',
                desc: '提前将冷冻食材解冻',
                time: '提前2小时',
                frequency: '按需',
                defaultTime: '16:00',
                repeat: 'never'
            },
            {
                name: '烘焙计时',
                category: '烘焙活动',
                icon: '🍰',
                desc: '蛋糕面包精确烘烤时间',
                time: '精确计时',
                frequency: '按需',
                defaultTime: '14:00',
                repeat: 'never'
            },
            {
                name: '煲汤提醒',
                category: '烹饪过程',
                icon: '🍲',
                desc: '长时间炖煮提醒',
                time: '2-3小时',
                frequency: '按需',
                defaultTime: '11:00',
                repeat: 'never'
            },
            {
                name: '面团发酵',
                category: '食材准备',
                icon: '🍞',
                desc: '面团发酵时间控制',
                time: '1-2小时',
                frequency: '按需',
                defaultTime: '09:00',
                repeat: 'never'
            },
            {
                name: '烤箱预热',
                category: '烘焙活动',
                icon: '🔥',
                desc: '烘焙前预热烤箱',
                time: '提前15分钟',
                frequency: '按需',
                defaultTime: '13:45',
                repeat: 'never'
            },
            {
                name: '燃气安全',
                category: '厨房安全',
                icon: '⚠️',
                desc: '检查燃气是否关闭',
                time: '离开厨房',
                frequency: '每次',
                defaultTime: '12:00',
                repeat: 'custom'
            }
        ]
    },
    transport: {
        title: '交通出行模板',
        icon: '🚗',
        templates: [
            {
                name: '出门提醒',
                category: '日常通勤',
                icon: '🚪',
                desc: '根据路况提前出门',
                time: '提前30分钟',
                frequency: '工作日',
                defaultTime: '07:30',
                repeat: 'weekdays'
            },
            {
                name: '停车计时',
                category: '日常通勤',
                icon: '🅿️',
                desc: '避免停车超时罚款',
                time: '计时提醒',
                frequency: '按需',
                defaultTime: '09:00',
                repeat: 'never'
            },
            {
                name: '航班提醒',
                category: '长途旅行',
                icon: '✈️',
                desc: '提前到达机场',
                time: '提前2小时',
                frequency: '单次',
                defaultTime: '06:00',
                repeat: 'never'
            },
            {
                name: '车辆保养',
                category: '交通工具维护',
                icon: '🔧',
                desc: '定期车辆保养提醒',
                time: '按里程',
                frequency: '定期',
                defaultTime: '09:00',
                repeat: 'custom'
            },
            {
                name: '证件更新',
                category: '交通工具维护',
                icon: '📄',
                desc: '驾驶证行驶证到期',
                time: '提前1月',
                frequency: '单次',
                defaultTime: '10:00',
                repeat: 'never'
            },
            {
                name: '公交提醒',
                category: '日常通勤',
                icon: '🚌',
                desc: '公交地铁班次提醒',
                time: '提前5分钟',
                frequency: '工作日',
                defaultTime: '08:00',
                repeat: 'weekdays'
            }
        ]
    },
    social: {
        title: '社交活动模板',
        icon: '👥',
        templates: [
            {
                name: '生日提醒',
                category: '人际关系维护',
                icon: '🎂',
                desc: '亲友生日纪念日提醒',
                time: '提前1天',
                frequency: '每年',
                defaultTime: '09:00',
                repeat: 'yearly'
            },
            {
                name: '约会准备',
                category: '社交约会',
                icon: '💐',
                desc: '提前准备着装礼物',
                time: '提前1小时',
                frequency: '单次',
                defaultTime: '18:00',
                repeat: 'never'
            },
            {
                name: '定期联系',
                category: '人际关系维护',
                icon: '📞',
                desc: '定期联系重要朋友',
                time: '定期',
                frequency: '每月',
                defaultTime: '19:00',
                repeat: 'monthly'
            },
            {
                name: '节日问候',
                category: '人际关系维护',
                icon: '🎊',
                desc: '节假日发送问候',
                time: '节日当天',
                frequency: '节日',
                defaultTime: '09:00',
                repeat: 'custom'
            },
            {
                name: '感谢表达',
                category: '社交礼仪',
                icon: '🙏',
                desc: '及时表达感谢',
                time: '当天',
                frequency: '按需',
                defaultTime: '20:00',
                repeat: 'never'
            },
            {
                name: '聚会时长',
                category: '社交约会',
                icon: '⏱️',
                desc: '控制聚会停留时间',
                time: '2-3小时',
                frequency: '按需',
                defaultTime: '19:00',
                repeat: 'never'
            }
        ]
    },
    personal: {
        title: '个人护理模板',
        icon: '💆',
        templates: [
            {
                name: '刷牙计时',
                category: '日常清洁',
                icon: '🦷',
                desc: '2-3分钟刷牙计时',
                time: '3分钟',
                frequency: '每天',
                defaultTime: '07:00',
                repeat: 'daily'
            },
            {
                name: '面膜时间',
                category: '皮肤护理',
                icon: '🧴',
                desc: '敷面膜时间控制',
                time: '15-20分钟',
                frequency: '2次/周',
                defaultTime: '21:00',
                repeat: 'custom'
            },
            {
                name: '理发提醒',
                category: '美容美发',
                icon: '💇',
                desc: '定期理发提醒',
                time: '定期',
                frequency: '每月',
                defaultTime: '14:00',
                repeat: 'monthly'
            },
            {
                name: '护肤等待',
                category: '皮肤护理',
                icon: '✨',
                desc: '护肤步骤间等待时间',
                time: '2-3分钟',
                frequency: '每天',
                defaultTime: '22:00',
                repeat: 'daily'
            },
            {
                name: '美甲干燥',
                category: '美容美发',
                icon: '💅',
                desc: '美甲后干燥时间',
                time: '30分钟',
                frequency: '按需',
                defaultTime: '15:00',
                repeat: 'never'
            },
            {
                name: '洗手计时',
                category: '日常清洁',
                icon: '🧼',
                desc: '20秒有效洗手',
                time: '20秒',
                frequency: '多次',
                defaultTime: '12:00',
                repeat: 'custom'
            }
        ]
    },
    entertainment: {
        title: '休闲娱乐模板',
        icon: '🎮',
        templates: [
            {
                name: '游戏时间控制',
                category: '数字娱乐',
                icon: '🎮',
                desc: '控制游戏时长避免沉迷',
                time: '1小时',
                frequency: '每天',
                defaultTime: '20:00',
                repeat: 'daily'
            },
            {
                name: '户外运动',
                category: '户外活动',
                icon: '🏃',
                desc: '户外跑步骑行提醒',
                time: '1小时',
                frequency: '3次/周',
                defaultTime: '17:00',
                repeat: 'custom'
            },
            {
                name: '演出提醒',
                category: '文化娱乐',
                icon: '🎭',
                desc: '音乐会电影开始提醒',
                time: '提前30分钟',
                frequency: '单次',
                defaultTime: '19:00',
                repeat: 'never'
            },
            {
                name: '阅读时间',
                category: '数字娱乐',
                icon: '📚',
                desc: '每日阅读时间提醒',
                time: '30分钟',
                frequency: '每天',
                defaultTime: '21:30',
                repeat: 'daily'
            },
            {
                name: '设备休息',
                category: '数字娱乐',
                icon: '📱',
                desc: '电子设备使用休息',
                time: '每小时',
                frequency: '重复',
                defaultTime: '09:00',
                repeat: 'hourly'
            },
            {
                name: '日落安全',
                category: '户外活动',
                icon: '🌅',
                desc: '户外活动日落提醒',
                time: '日落前1小时',
                frequency: '按需',
                defaultTime: '17:00',
                repeat: 'never'
            }
        ]
    },
    special: {
        title: '特殊场合模板',
        icon: '🎉',
        templates: [
            {
                name: '节日准备',
                category: '节日庆典',
                icon: '🎄',
                desc: '提前准备节日用品',
                time: '提前1周',
                frequency: '节日',
                defaultTime: '10:00',
                repeat: 'yearly'
            },
            {
                name: '婚礼筹备',
                category: '人生重要时刻',
                icon: '💒',
                desc: '婚礼各环节提醒',
                time: '分阶段',
                frequency: '单次',
                defaultTime: '09:00',
                repeat: 'never'
            },
            {
                name: '周年纪念',
                category: '纪念活动',
                icon: '💕',
                desc: '结婚纪念日提醒',
                time: '提前1天',
                frequency: '每年',
                defaultTime: '09:00',
                repeat: 'yearly'
            },
            {
                name: '礼品准备',
                category: '节日庆典',
                icon: '🎁',
                desc: '为亲友准备礼物',
                time: '提前3天',
                frequency: '按需',
                defaultTime: '14:00',
                repeat: 'never'
            },
            {
                name: '考试备考',
                category: '人生重要时刻',
                icon: '📝',
                desc: '重要考试备考计划',
                time: '分阶段',
                frequency: '单次',
                defaultTime: '19:00',
                repeat: 'custom'
            },
            {
                name: '搬家规划',
                category: '人生重要时刻',
                icon: '📦',
                desc: '搬家各环节提醒',
                time: '分阶段',
                frequency: '单次',
                defaultTime: '09:00',
                repeat: 'never'
            }
        ]
    },
    // 在现有的 scenarioTemplates 对象中添加以下新场景：

    finance: {
        title: '财务管理场景',
        icon: '💰',
        templates: [
            {
                name: '基金定投',
                category: '投资理财',
                icon: '📈',
                desc: '每月定期基金投资提醒',
                time: '每月1日',
                frequency: '每月',
                defaultTime: '09:00',
                repeat: 'monthly'
            },
            {
                name: '理财产品到期',
                category: '投资理财',
                icon: '💎',
                desc: '理财产品到期赎回提醒',
                time: '提前3天',
                frequency: '单次',
                defaultTime: '10:00',
                repeat: 'never'
            },
            {
                name: '消费限额提醒',
                category: '预算控制',
                icon: '💳',
                desc: '每周消费限额控制提醒',
                time: '接近限额',
                frequency: '每周',
                defaultTime: '20:00',
                repeat: 'weekly'
            },
            {
                name: '年度报税',
                category: '税务合规',
                icon: '📋',
                desc: '年度报税截止提醒',
                time: '提前1月',
                frequency: '每年',
                defaultTime: '09:00',
                repeat: 'yearly'
            },
            {
                name: '发票报销',
                category: '税务合规',
                icon: '🧾',
                desc: '发票报销截止提醒',
                time: '提前3天',
                frequency: '每月',
                defaultTime: '16:00',
                repeat: 'monthly'
            },
            {
                name: '投资组合审视',
                category: '投资理财',
                icon: '📊',
                desc: '季度投资组合调整',
                time: '每季度',
                frequency: '季度',
                defaultTime: '14:00',
                repeat: 'quarterly'
            }
        ]
    },
    digital: {
        title: '数字健康场景',
        icon: '📱',
        templates: [
            {
                name: '屏幕时间限制',
                category: '数字排毒',
                icon: '⏰',
                desc: '每日屏幕使用时间提醒',
                time: '达到限制',
                frequency: '每天',
                defaultTime: '21:00',
                repeat: 'daily'
            },
            {
                name: '睡前数字禁用',
                category: '数字排毒',
                icon: '🌙',
                desc: '睡前1小时停用设备',
                time: '睡前1小时',
                frequency: '每天',
                defaultTime: '21:30',
                repeat: 'daily'
            },
            {
                name: '内容发布计划',
                category: '内容创作',
                icon: '📝',
                desc: '按计划发布内容提醒',
                time: '按计划',
                frequency: '定期',
                defaultTime: '10:00',
                repeat: 'custom'
            },
            {
                name: '密码更换',
                category: '网络安全',
                icon: '🔐',
                desc: '定期更换重要密码',
                time: '每3个月',
                frequency: '季度',
                defaultTime: '15:00',
                repeat: 'quarterly'
            },
            {
                name: '数据备份',
                category: '网络安全',
                icon: '💾',
                desc: '重要数据定期备份',
                time: '每周',
                frequency: '每周',
                defaultTime: '20:00',
                repeat: 'weekly'
            },
            {
                name: '社交互动回复',
                category: '内容创作',
                icon: '💬',
                desc: '回复评论和私信提醒',
                time: '每天',
                frequency: '每天',
                defaultTime: '18:00',
                repeat: 'daily'
            }
        ]
    },
    hobby: {
        title: '兴趣爱好场景',
        icon: '🎨',
        templates: [
            {
                name: '每日阅读',
                category: '阅读计划',
                icon: '📖',
                desc: '每日阅读目标提醒',
                time: '30分钟',
                frequency: '每天',
                defaultTime: '21:00',
                repeat: 'daily'
            },
            {
                name: '乐器练习',
                category: '音乐学习',
                icon: '🎹',
                desc: '每日乐器练习时间',
                time: '45分钟',
                frequency: '每天',
                defaultTime: '19:00',
                repeat: 'daily'
            },
            {
                name: '植物浇水',
                category: '园艺养护',
                icon: '🌱',
                desc: '植物浇水施肥提醒',
                time: '定期',
                frequency: '2次/周',
                defaultTime: '08:00',
                repeat: 'custom'
            },
            {
                name: '摄影创作',
                category: '艺术创作',
                icon: '📷',
                desc: '摄影灵感捕捉提醒',
                time: '黄金时段',
                frequency: '每天',
                defaultTime: '17:30',
                repeat: 'daily'
            },
            {
                name: '志愿服务',
                category: '社会参与',
                icon: '🤝',
                desc: '志愿服务活动提醒',
                time: '按安排',
                frequency: '每月',
                defaultTime: '09:00',
                repeat: 'monthly'
            },
            {
                name: '读书会活动',
                category: '阅读计划',
                icon: '👥',
                desc: '读书会聚会提醒',
                time: '提前1天',
                frequency: '每月',
                defaultTime: '19:00',
                repeat: 'monthly'
            }
        ]
    },
    community: {
        title: '社区邻里场景',
        icon: '🏘️',
        templates: [
            {
                name: '社区会议',
                category: '社区活动',
                icon: '🏛️',
                desc: '业主大会等社区会议',
                time: '提前1天',
                frequency: '按通知',
                defaultTime: '19:00',
                repeat: 'custom'
            },
            {
                name: '邻里互助',
                category: '邻里关系',
                icon: '🤝',
                desc: '帮助邻居代收快递',
                time: '按需',
                frequency: '不定期',
                defaultTime: '18:00',
                repeat: 'never'
            },
            {
                name: '垃圾分类投放',
                category: '环保行动',
                icon: '♻️',
                desc: '特定垃圾投放日提醒',
                time: '投放日',
                frequency: '每周',
                defaultTime: '07:00',
                repeat: 'weekly'
            },
            {
                name: '公共设施维护',
                category: '社区活动',
                icon: '🔧',
                desc: '参与社区设施维护',
                time: '按安排',
                frequency: '不定期',
                defaultTime: '09:00',
                repeat: 'custom'
            },
            {
                name: '宠物看护',
                category: '邻里关系',
                icon: '🐕',
                desc: '帮助邻居照看宠物',
                time: '按约定',
                frequency: '按需',
                defaultTime: '08:00',
                repeat: 'never'
            },
            {
                name: '社区活动参与',
                category: '社区活动',
                icon: '🎉',
                desc: '社区聚会活动提醒',
                time: '提前2小时',
                frequency: '不定期',
                defaultTime: '14:00',
                repeat: 'custom'
            }
        ]
    },
    safety: {
        title: '安全防护场景',
        icon: '🛡️',
        templates: [
            {
                name: '门窗安全检查',
                category: '安全检查',
                icon: '🚪',
                desc: '睡前门窗关闭检查',
                time: '睡前',
                frequency: '每天',
                defaultTime: '22:00',
                repeat: 'daily'
            },
            {
                name: '电器断电检查',
                category: '安全检查',
                icon: '🔌',
                desc: '出门前电器断电检查',
                time: '出门前',
                frequency: '每天',
                defaultTime: '08:00',
                repeat: 'daily'
            },
            {
                name: '消防设备检查',
                category: '安全检查',
                icon: '🧯',
                desc: '烟雾报警器等设备检查',
                time: '定期',
                frequency: '每月',
                defaultTime: '10:00',
                repeat: 'monthly'
            },
            {
                name: '紧急联系人沟通',
                category: '紧急联系',
                icon: '📞',
                desc: '与紧急联系人定期沟通',
                time: '定期',
                frequency: '每月',
                defaultTime: '19:00',
                repeat: 'monthly'
            },
            {
                name: '极端天气预警',
                category: '天气安全',
                icon: '⛈️',
                desc: '极端天气防护提醒',
                time: '预警时',
                frequency: '按需',
                defaultTime: '07:00',
                repeat: 'never'
            },
            {
                name: '应急演练',
                category: '安全训练',
                icon: '🚨',
                desc: '参加应急演练提醒',
                time: '按安排',
                frequency: '不定期',
                defaultTime: '14:00',
                repeat: 'custom'
            }
        ]
    },
    growth: {
        title: '个人成长场景',
        icon: '🌟',
        templates: [
            {
                name: '每日反思',
                category: '自我反思',
                icon: '📔',
                desc: '记录当天感受和成长',
                time: '睡前',
                frequency: '每天',
                defaultTime: '22:30',
                repeat: 'daily'
            },
            {
                name: '每周总结',
                category: '自我反思',
                icon: '📊',
                desc: '每周工作生活总结',
                time: '周日晚',
                frequency: '每周',
                defaultTime: '20:00',
                repeat: 'weekly'
            },
            {
                name: '目标回顾',
                category: '目标管理',
                icon: '🎯',
                desc: '月度目标完成回顾',
                time: '月末',
                frequency: '每月',
                defaultTime: '19:00',
                repeat: 'monthly'
            },
            {
                name: '感恩练习',
                category: '心理健康',
                icon: '🙏',
                desc: '记录每日感恩事项',
                time: '晚间',
                frequency: '每天',
                defaultTime: '21:30',
                repeat: 'daily'
            },
            {
                name: '冥想练习',
                category: '心理健康',
                icon: '🧘',
                desc: '每日冥想正念练习',
                time: '15分钟',
                frequency: '每天',
                defaultTime: '07:30',
                repeat: 'daily'
            },
            {
                name: '年度计划制定',
                category: '目标管理',
                icon: '📅',
                desc: '制定年度目标计划',
                time: '年初',
                frequency: '每年',
                defaultTime: '10:00',
                repeat: 'yearly'
            }
        ]
    }
};

// 显示场景模板函数
function showScenarioTemplates(scenarioType) {
    const scenario = scenarioTemplates[scenarioType];
    if (!scenario) return;
    
    // 更新标题
    const titleElement = document.getElementById('scenario-title');
    if (titleElement) {
        titleElement.textContent = scenario.title;
    }
    
    // 生成模板列表
    const templatesList = document.getElementById('templates-list');
    if (!templatesList) return;
    
    templatesList.innerHTML = '';
    
    scenario.templates.forEach(template => {
        const templateCard = document.createElement('div');
        templateCard.className = 'template-card';
        templateCard.innerHTML = `
            <div class="template-header">
                <div class="template-icon">${template.icon}</div>
                <div class="template-info">
                    <div class="template-name">${template.name}</div>
                    <div class="template-category">${template.category}</div>
                </div>
            </div>
            <div class="template-desc">${template.desc}</div>
            <div class="template-details">
                <div class="template-time">${template.time}</div>
                <div class="template-frequency">${template.frequency}</div>
            </div>
        `;
        
        // 添加点击事件
        templateCard.addEventListener('click', function() {
            selectTemplate(template);
        });
        
        templatesList.appendChild(templateCard);
    });
}

// 选择模板函数
function selectTemplate(template) {
    console.log('选择模板:', template.name);
    
    // 预填充闹钟设置
    const timeDisplay = document.querySelector('.time-display');
    if (timeDisplay) {
        timeDisplay.textContent = template.defaultTime;
    }
    
    // 设置标签
    const labelSetting = document.querySelector('.setting-item .setting-value');
    if (labelSetting) {
        labelSetting.textContent = template.name;
    }
    
    // 跳转到闹钟设置界面
    setTimeout(() => {
        showScreen('alarm-setup');
    }, 200);
}

// 模板返回按钮处理
document.addEventListener('DOMContentLoaded', function() {
    // 为模板页面的返回按钮添加特殊处理
    const templateBackBtn = document.querySelector('#scenario-templates .back-btn');
    if (templateBackBtn) {
        templateBackBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            showScreen('scenarios');
        });
    }
});

console.log('场景模板系统已加载');
