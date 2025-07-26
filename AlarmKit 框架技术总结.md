<!--
 * @Author: slw 18071715194@189.cn
 * @Date: 2025-07-24 15:08:02
 * @LastEditors: slw 18071715194@189.cn
 * @LastEditTime: 2025-07-26 22:09:31
 * @FilePath: /iOS Alarm App Design with AlarmKit and Customization/AlarmKit 框架技术总结.md
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->
# AlarmKit 框架技术总结

## 概述
AlarmKit 是 iOS 26 中引入的一个新框架，用于在应用程序中创建和管理自定义闹钟和计时器。它支持一次性闹钟和重复闹钟，并提供倒计时时长和贪睡功能。AlarmKit 能够处理闹钟授权，并为模板和小部件展示提供 UI。它支持传统闹钟、计时器或两者，并提供调度、暂停、恢复和取消闹钟的方法。

## 主要功能

### 1. 闹钟类型
*   **一次性闹钟 (One-time alarms)**：在未来指定时间只提醒一次。
*   **重复闹钟 (Repeating alarms)**：按周循环提醒。
*   **计时器 (Timers)**：倒计时结束后提醒，立即开始。

### 2. 授权机制
*   应用程序需要通过调用 `requestAuthorization()` 方法向 `AlarmManager` 请求授权，才能调度闹钟和创建提醒。如果未提前授权，AlarmKit 会在用户添加第一个闹钟时自动请求授权。
*   在应用的 `Info.plist` 文件中必须包含 `NSAlarmKitUsageDescription` 键，并提供描述性字符串，解释为何需要调度闹钟。此字符串会在系统请求授权时显示给用户。

### 3. 闹钟调度
*   闹钟可以通过倒计时时长 (`Alarm.CountdownDuration`) 和/或调度 (`Alarm.Schedule`) 进行配置。
*   `Alarm.CountdownDuration` 用于设置预提醒倒计时，当倒计时达到 0 时显示提醒。
*   `Alarm.Schedule` 允许设置一次性闹钟或每周重复的闹钟。一次性闹钟的 `repeats` 属性设置为 `.never`，重复闹钟则设置为 `.weekly(_:)` 并指定重复的星期几。

### 4. UI 配置
*   AlarmKit 为三种闹钟状态提供展示：`AlarmPresentation.Alert` (提醒)、`AlarmPresentation.Countdown` (倒计时) 和 `AlarmPresentation.Paused` (暂停)。
*   `Alert` 状态是必需的，`Countdown` 和 `Paused` 状态是可选的。
*   可以配置提醒 UI 中的按钮，例如停止按钮 (`stopButton`) 和辅助按钮 (`secondaryButton`)。辅助按钮的行为可以是倒计时 (`.countdown`) 或打开应用 (`.custom`)。
*   闹钟的 UI 属性（如 `tintColor` 和 `metadata`）封装在 `ActivityAttributes` 中，用于自定义闹钟的外观和携带额外信息。

### 5. 闹钟管理
*   每个闹钟都有一个唯一的标识符 (UUID)，用于跟踪和管理闹钟状态，例如暂停 (`pause(id:)`) 和取消 (`cancel(id:)`)。
*   当用户在提醒 UI 中点击按钮时，`AlarmManager` 会自动处理停止或倒计时功能。
*   应用程序可以通过订阅 `alarmManager.alarmUpdates` 来观察闹钟状态的变化，即使应用未运行，也能获取最新的闹钟状态。

### 6. 小部件扩展
*   AlarmKit 支持小部件扩展，用于在灵动岛 (Dynamic Island)、锁定屏幕 (Lock Screen) 和待机 (StandBy) 模式下自定义非提醒状态的展示。
*   小部件会接收与调度闹钟时提供的相同的 `AlarmAttributes` 结构，包括元数据。

## 关键类和结构
*   **`AlarmManager`**：用于调度、贪睡、取消闹钟的对象。
*   **`Alarm`**：描述闹钟的对象，包括一次性或重复调度。
*   **`AlarmButton`**：定义按钮外观的结构。
*   **`AlarmPresentation`**：描述闹钟 UI 所需内容的结构。
*   **`AlarmPresentationState`**：描述闹钟可变内容的结构。
*   **`AlarmAttributes`**：包含闹钟 UI 所有信息的对象。
*   **`AlarmMetadata`**：包含闹钟信息的元数据对象。

## 注意事项
*   AlarmKit 需要 iOS 26.0+、iPadOS 26.0+ 和 Mac Catalyst 26.0+。
*   此文档基于 Beta 软件信息，可能会有变动。

