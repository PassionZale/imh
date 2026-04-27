# debug-wakelock Specification

## Purpose
TBD - created by archiving change debug-wakelock. Update Purpose after archive.
## Requirements
### Requirement: Debug 模式下自动启用屏幕常亮
当 APP 以 Debug 模式运行时，系统 SHALL 自动启用 WakeLock 保持屏幕常亮，防止设备息屏。

#### Scenario: Debug 构建启动时启用 WakeLock
- **WHEN** APP 以 Debug 模式 (`flutter run`) 启动
- **THEN** 设备屏幕保持常亮，不会因超时而自动息屏

#### Scenario: Release 构建不启用 WakeLock
- **WHEN** APP 以 Release 模式 (`flutter build` / `flutter run --release`) 构建
- **THEN** WakeLock 代码被编译器 tree-shake 移除，不产生任何运行时行为

### Requirement: WakeLock 在 APP 启动最早期生效
WakeLock SHALL 在 `main()` 函数中、`runApp()` 调用之前启用，确保从 APP 启动的第一刻起屏幕就保持常亮。

#### Scenario: 初始化时序
- **WHEN** APP 的 `main()` 函数开始执行
- **THEN** WakeLock 在 `runApp()` 之前被启用，覆盖整个 APP 生命周期

