## Context

Flutter 无线调试依赖 ADB TCP 连接，手机息屏后 Android Doze 模式会限流 WiFi、冻结后台进程，导致调试连接断开。项目是新建 Flutter 项目（从 Next.js 迁移），当前使用默认模板代码。

## Goals / Non-Goals

**Goals:**
- Debug 模式下保持设备屏幕常亮，防止无线调试连接因息屏断开
- 零 Release 影响，所有 WakeLock 逻辑仅在 Debug 构建中存在
- 最小化代码改动

**Non-Goals:**
- 不处理 Release 模式下的屏幕常亮需求（如视频播放场景）
- 不处理系统级电池优化设置（用户需自行配置）
- 不实现自动重连机制

## Decisions

### 1. 使用 `wakelock_plus` 而非 `wakelock`

**选择**: `wakelock_plus`
**替代方案**: 原版 `wakelock`（已停止维护）
**理由**: `wakelock_plus` 是社区公认的继任者，积极维护，API 稳定，支持 Android + iOS。

### 2. WakeLock 在 `main()` 中启用

**选择**: 在 `main()` 函数顶部、`runApp()` 之前调用
**替代方案**: 在某个 Widget 的 `initState` 中启用
**理由**: 最早起效，不依赖 Widget 生命周期，不会因页面切换而丢失 WakeLock。全局生效，无需管理 dispose。

### 3. 使用 `kDebugMode` 守卫

**选择**: `if (kDebugMode)` 条件守卫
**替代方案**: 使用 `--dart-define` 自定义编译标志
**理由**: `kDebugMode` 是 Flutter 内置的编译时常量，编译器在 Release 模式下会 tree-shake 掉整个 if 块，零运行时开销。

## Risks / Trade-offs

- **[耗电]** → Debug only，可接受
- **[烧屏风险]** → 开发调试时屏幕内容变化频繁，风险极低
- **[包体积]** → `wakelock_plus` 体积很小（~10KB），影响可忽略
