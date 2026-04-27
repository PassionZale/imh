## Why

imh 应用需要本地数据持久化能力来存储用户数据和其他常用功能的数据。当前应用没有任何持久化存储，无法在应用重启后保留用户数据。

## What Changes

- 添加 sqflite 依赖和相关数据库基础设施
- 创建用户管理功能，包括用户表和 CRUD 操作
- 实现头像上传功能（选择图片、保存到应用目录）
- 添加用户列表 UI，演示完整的用户管理功能

## Capabilities

### New Capabilities
- `local-persistence`: 基于 SQLite 的本地数据持久化能力
- `user-management`: 用户数据管理，包括创建、读取、更新、删除用户
- `avatar-storage`: 头像图片存储功能，支持从相册/相机选择并保存到应用目录

### Modified Capabilities
- None

## Impact

**Dependencies:**
- 新增: sqflite, path, path_provider, image_picker

**Code Structure:**
- 新增: `lib/database/` 目录（数据库层）
- 新增: `lib/repositories/` 目录（Repository 层）
- 新增: `lib/services/` 目录（服务层，如 ImageService）
- 新增: `lib/pages/` 目录（UI 页面）
- 新增: `assets/images/` 目录（默认头像资源）

**Database:**
- 创建 `imh.db` 数据库文件
- 创建 `users` 表（id, name, nickname, avatar, created_at, updated_at）
