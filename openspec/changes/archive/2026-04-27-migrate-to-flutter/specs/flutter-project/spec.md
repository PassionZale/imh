## ADDED Requirements

### Requirement: Flutter 项目结构
项目 SHALL 使用 `flutter create` 生成的标准目录结构，包含 `lib/`、`android/`、`ios/`、`test/` 目录和 `pubspec.yaml` 配置文件。

#### Scenario: 项目目录结构完整
- **WHEN** 查看 项目根目录
- **THEN** 存在 `lib/main.dart`、`android/`、`ios/`、`test/`、`pubspec.yaml`

### Requirement: 仅支持移动端平台
项目 SHALL 仅配置 Android 和 iOS 两个平台，不包含 Web、macOS、Windows、Linux 平台支持。

#### Scenario: 平台目录仅包含 Android 和 iOS
- **WHEN** 查看 项目根目录
- **THEN** 存在 `android/` 和 `ios/` 目录，不存在 `web/`、`macos/`、`windows/`、`linux/` 目录

### Requirement: 组织标识符
项目 SHALL 使用 `com.passionzale` 作为组织标识符，Android applicationId 为 `com.passionzale.imh`，iOS bundle identifier 为 `com.passionzale.imh`。

#### Scenario: Android 包名正确
- **WHEN** 查看 `android/app/build.gradle` 或 `build.gradle.kts`
- **THEN** applicationId 为 `com.passionzale.imh`

#### Scenario: iOS bundle identifier 正确
- **WHEN** 查看 ios/Runner/Info.plist 或项目配置
- **THEN** bundle identifier 为 `com.passionzale.imh`

### Requirement: 旧代码完全清除
项目中 SHALL 不存在任何 Next.js 相关文件，包括但不限于 `app/`、`node_modules/`、`public/`、`package.json`、`next.config.mjs`、`tailwind.config.ts`、`tsconfig.json`。

#### Scenario: 无 Next.js 残留文件
- **WHEN** 在项目根目录执行文件检查
- **THEN** 以下文件/目录均不存在: `app/`, `node_modules/`, `public/`, `.next/`, `package.json`, `package-lock.json`, `next.config.mjs`, `next-env.d.ts`, `postcss.config.mjs`, `tailwind.config.ts`, `tsconfig.json`, `.eslintrc.json`, `.env`, `.env-sample`

### Requirement: 保留文件完整
以下文件和目录 SHALL 在迁移过程中保持不变: `.claude/`、`openspec/`、`LICENSE`。

#### Scenario: 保留文件未被修改
- **WHEN** 迁移完成后检查保留文件
- **THEN** `.claude/` 目录、`openspec/` 目录、`LICENSE` 文件内容与迁移前一致

### Requirement: Flutter 项目可分析
项目 SHALL 能通过 `flutter analyze` 检查，无错误和警告。

#### Scenario: 分析通过
- **WHEN** 执行 `flutter analyze`
- **THEN** 输出显示 0 issues found

### Requirement: Flutter 项目可构建
项目 SHALL 能成功构建 Android debug APK。

#### Scenario: Android debug 构建成功
- **WHEN** 执行 `flutter build apk --debug`
- **THEN** 构建成功完成，生成 debug APK 文件
