## Context

imh 项目当前是一个 Next.js 14 Web 应用（React 18 + TypeScript + Tailwind CSS），运行在 Flutter 3.41.6 (stable channel) 的开发环境中。产品方向已转为纯移动端应用，现有 Web 功能全部废弃。仓库位于 `refactor/flutter` 分支，需要保留 Git 历史、`.claude/`、`openspec/`、`LICENSE`。

## Goals / Non-Goals

**Goals:**
- 完全清除 Next.js 项目代码和 Node.js 依赖体系
- 初始化一个干净的 Flutter 项目，仅支持 Android + iOS
- 确保项目可以通过 `flutter analyze` 和 `flutter build apk --debug`

**Non-Goals:**
- 不迁移任何现有功能或业务逻辑
- 不设置 CI/CD、打包发布流程
- 不引入状态管理、路由、网络请求等框架

## Decisions

### 1. 使用 `flutter create .` 在当前目录初始化

选择在项目根目录直接执行 `flutter create --platforms android,ios --org com.passionzale .` 而非创建子目录。

理由：保持仓库结构简洁，避免嵌套目录。`.` 参数让 Flutter 使用当前目录作为项目根目录。

### 2. 组织标识符: `com.passionzale`

Android 的 applicationId 和 iOS 的 bundle identifier 使用 `com.passionzale.imh`。

### 3. 清除策略: 先删后建

先删除所有旧文件，再执行 `flutter create`。原因：
- `flutter create .` 要求目录中没有冲突文件
- 避免残留文件干扰 Flutter 项目结构

清除清单：
- 目录: `app/`, `public/`, `.next/`, `node_modules/`
- 文件: `package.json`, `package-lock.json`, `next.config.mjs`, `next-env.d.ts`, `postcss.config.mjs`, `tailwind.config.ts`, `tsconfig.json`, `.eslintrc.json`, `.env`, `.env-sample`, `README.md`

### 4. .gitignore 完整替换

用 Flutter 标准模板替换现有 .gitignore，包含：
- Flutter/Dart/Pub 构建产物
- Android (Gradle) 和 iOS (CocoaPods) 忽略规则
- 通用规则 (.DS_Store、*.pem 等)

## Risks / Trade-offs

- **[Git 历史膨胀]** 旧的大型文件（node_modules 曾被提交、package-lock.json 等）会留在历史中 → 可接受，不影响新项目，后续可用 git filter-rewrite 清理
- **[flutter create 覆盖冲突]** 如果当前目录有同名文件（如 README.md），flutter create 会拒绝或覆盖 → 先删除所有冲突文件解决
