## Why

imh 项目当前是一个基于 Next.js 的 Web 应用，产品方向已调整为纯移动端应用。需要将技术栈从 Next.js (React/TypeScript/Tailwind) 完全迁移到 Flutter，以实现跨平台移动端开发。现有功能全部废弃，从零开始。

## What Changes

- **BREAKING** 移除所有 Next.js Web 应用代码（app/、node_modules/、public/、配置文件等）
- **BREAKING** 移除 Node.js 依赖体系（package.json、package-lock.json）
- **BREAKING** 移除 TypeScript/ESLint/PostCSS/Tailwind 配置
- 移除环境变量文件（.env、.env-sample）
- 使用 `flutter create` 初始化 Flutter 项目（仅 Android + iOS 平台）
- 替换 .gitignore 为 Flutter 项目版本
- 保留 .claude/、openspec/、LICENSE 不变

## Capabilities

### New Capabilities
- `flutter-project`: Flutter 项目基础结构和配置，包含 Android/iOS 平台支持、Dart 代码结构、依赖管理

### Modified Capabilities
(无现有 specs 需要修改)

## Impact

- **删除的代码**: 整个 Next.js 应用（页面、组件、API 路由、数据库层、类型定义）
- **删除的依赖**: 所有 Node.js 依赖（React、Next.js、Tailwind CSS、高德地图 JS API、LowDB 等）
- **新增的依赖**: Flutter SDK 3.41.6+、Dart SDK
- **新增的文件**: Flutter 标准项目结构（lib/、android/、ios/、test/、pubspec.yaml 等）
- **保留不变**: .claude/、openspec/、LICENSE、.git 历史
