## Context

imh 是一个个人工具集合应用，需要本地数据持久化能力来存储用户数据。当前应用处于早期开发阶段，除了基础的 WakelockPlus 功能外，没有任何数据存储机制。

**Constraints:**
- 使用 sqflite 作为数据库解决方案
- 图片存储在应用内部，不依赖云端
- 遵循 Repository 模式进行数据访问层设计
- 使用 setState 模式处理异步数据（暂不引入状态管理库）

## Goals / Non-Goals

**Goals:**
- 建立可扩展的本地数据持久化基础设施
- 实现用户管理功能作为示例和基础
- 提供完整的 CRUD 操作演示
- 实现头像上传和存储功能

**Non-Goals:**
- 云端同步功能
- 复杂的状态管理（Provider/Riverpod 等）
- 数据加密
- 多用户隔离
- 图片压缩处理

## Decisions

### 1. 选择 sqflite 而非 drift/isar

**Rationale:**
- sqflite 生态成熟稳定，社区支持好
- 学习曲线低，直接使用 SQL 灵活性高
- 对于个人工具 APP，不需要复杂的类型安全代码生成
- 用户明确要求使用 sqflite

**Alternatives considered:**
- drift: 类型安全更好，但需要代码生成，学习成本高
- isar: 性能更好，但 NoSQL 不适合关系型数据需求

### 2. Repository 模式封装数据访问

**Rationale:**
- 分离数据访问逻辑和 UI 逻辑
- 便于后续更换数据库实现
- 统一错误处理和日志记录
- 提高代码可测试性

### 3. 图片存储路径方案

**Rationale:**
- 使用 `getApplicationDocumentsDirectory()` 确保应用内部存储
- 头像文件存储在 `avatars/` 子目录
- 数据库存储绝对路径，避免路径拼接错误
- 不删除旧图片文件，简化逻辑

**Trade-off:**
- 优点: 简化实现，避免文件操作的并发问题
- 缺点: 可能产生孤儿文件，可通过定期清理解决

### 4. 使用 setState 而非状态管理库

**Rationale:**
- 项目处于早期阶段，避免过度设计
- setState 足够处理当前简单场景
- 后续可根据复杂度逐步引入

### 5. 数据库表设计

**users 表结构:**
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  nickname TEXT NOT NULL,
  avatar TEXT,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
)
```

**Rationale:**
- 使用自增 ID 作为主键
- 时间戳使用毫秒级 INTEGER 存储（兼容性好）
- avatar 字段可为空（支持无头像用户）

## Risks / Trade-offs

| Risk | Mitigation |
|------|------------|
| 图片文件累积可能导致存储空间浪费 | 后续可实现清理工具或定期清理任务 |
| 无数据加密可能泄露敏感信息 | 当前仅个人使用，后续根据需求添加 |
| 直接使用 SQL 可能存在注入风险 | 使用参数化查询，避免字符串拼接 |
| 异步操作可能导致 UI 卡顿 | 使用 loading 状态和错误提示优化体验 |

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        UI Layer                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                    UsersPage                             │   │
│  │  (FutureBuilder + setState for async handling)           │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Repository Layer                            │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                UserRepository                             │   │
│  │  - create(), getById(), getAll(), update(), delete()    │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Service Layer                              │
│  ┌─────────────────────┐  ┌─────────────────────────────────┐  │
│  │   ImageService      │  │     DatabaseHelper              │  │
│  │  - saveAvatar()     │  │  - Database initialization      │  │
│  │  - deleteAvatar()   │  │  - Version management           │  │
│  └─────────────────────┘  └─────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                       Data Layer                                 │
│  ┌─────────────────────┐  ┌─────────────────────────────────┐  │
│  │    User Model       │  │        sqflite                  │  │
│  │  - toMap()          │  │   (SQLite Database)             │  │
│  │  - fromMap()        │  │                                 │  │
│  └─────────────────────┘  └─────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## Project Structure

```
lib/
├── main.dart
├── database/
│   ├── database_helper.dart       # Database initialization and management
│   └── models/
│       └── user.dart              # User model with toMap/fromMap
├── repositories/
│   └── user_repository.dart       # User data access layer
├── services/
│   └── image_service.dart         # Image storage service
└── pages/
    └── users_page.dart            # User management UI

assets/images/
└── default_avatar.jpeg            # Default avatar placeholder
```

## Migration Plan

**Phase 1: Database Infrastructure**
- Add dependencies (sqflite, path, path_provider, image_picker)
- Create DatabaseHelper with users table
- Test database creation and basic queries

**Phase 2: Model and Repository**
- Implement User model with serialization
- Implement UserRepository with CRUD operations
- Add unit tests for Repository

**Phase 3: Image Service**
- Implement ImageService for avatar management
- Test image selection and storage

**Phase 4: UI Implementation**
- Create UsersPage with FutureBuilder
- Implement add/edit/delete user flows
- Add avatar upload functionality

**Rollback Strategy:**
- All changes are additive (no breaking changes)
- Can safely rollback by reverting commits
- Database file is isolated and can be deleted without affecting app functionality
