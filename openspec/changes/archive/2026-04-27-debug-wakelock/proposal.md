## Why

无线连接安卓手机调试 Flutter APP 时，手机息屏后 Android 进入 Doze 模式，WiFi 连接被系统限制或断开，导致 ADB 调试连接丢失、Hot Reload 失效。开发体验严重受损，需要频繁重新连接设备。

## What Changes

- 在 Debug 模式下启用 Android WakeLock，保持屏幕常亮，防止系统进入 Doze 模式
- 使用 `wakelock_plus` 包实现跨平台（Android/iOS）屏幕常亮
- 仅在 `kDebugMode` 下生效，Release 构建零影响

## Capabilities

### New Capabilities

- `debug-wakelock`: 在 Debug 构建模式下自动保持设备屏幕常亮，防止无线调试时因息屏导致连接断开

### Modified Capabilities

_(无现有 capability 需要修改)_

## Impact

- **依赖变更**: 新增 `wakelock_plus` Flutter 包
- **代码变更**: `lib/main.dart` 中 `main()` 函数添加 WakeLock 启用逻辑
- **平台影响**: Android（主要目标）、iOS（附带回车支持）
- **无 Release 影响**: 所有逻辑被 `kDebugMode` 守卫，Release 构建不包含任何 WakeLock 代码
