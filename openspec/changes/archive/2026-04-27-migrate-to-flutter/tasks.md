## 1. 清除 Next.js 项目文件

- [x] 1.1 删除目录: `app/`, `public/`, `.next/`, `node_modules/`
- [x] 1.2 删除配置文件: `package.json`, `package-lock.json`, `next.config.mjs`, `next-env.d.ts`, `postcss.config.mjs`, `tailwind.config.ts`, `tsconfig.json`, `.eslintrc.json`
- [x] 1.3 删除环境变量文件: `.env`, `.env-sample`
- [x] 1.4 删除旧 README.md

## 2. 初始化 Flutter 项目

- [x] 2.1 执行 `flutter create --platforms android,ios --org com.passionzale --project-name imh .` 在项目根目录初始化

## 3. 完善 .gitignore

- [x] 3.1 将 .gitignore 替换为 Flutter 标准模板，包含 Dart/Pub、Android (Gradle)、iOS (CocoaPods)、通用规则

## 4. 验证

- [x] 4.1 确认保留文件完整: `.claude/`、`openspec/`、`LICENSE` 未被修改
- [x] 4.2 执行 `flutter analyze` 确认 0 issues
- [x] 4.3 执行 `flutter build apk --debug` 确认构建成功
