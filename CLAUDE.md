# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

IMH (I'm Here) is a Flutter mobile app for daily check-in tracking and car fuel consumption management. Features include calendar-based check-in, fuel record tracking with charts, AI-powered fuel receipt OCR, and light/dark theme support. UI is in Chinese.

## Commands

```bash
# Dependencies
flutter pub get

# Run app (debug)
flutter run

# Format code
dart format .

# Analyze code (lint)
flutter analyze

# Run tests
flutter test

# Run single test file
flutter test test/path/to/test.dart

# Build release APK (requires `cider` for version management)
./scripts/build.sh patch     # bump patch + build
./scripts/build.sh minor     # bump minor + build
./scripts/build.sh major     # bump major + build
./scripts/build.sh release   # build without version bump
```

## Architecture

Entry point: `lib/main.dart` — initializes three singleton services then launches `MaterialApp`.

**State Management**: Uses `ListenableBuilder` with `ChangeNotifier` (no external state library). Services are singletons accessed via `*.instance`.

**Data Flow**: `Pages → Repositories → Database (sqflite)`

```
lib/
├── main.dart
├── components/        # Reusable UI widgets (card, cell, empty state, img_preview)
├── database/
│   ├── database_helper.dart   # SQLite init & migrations
│   └── models/               # Data models: User, Car, CheckInTask, CheckInRecord, CarFuelRecord
├── pages/
│   ├── tabs/         # Main tab screens (Home, Settings)
│   ├── home/         # Home page sub-sections
│   └── settings/     # Settings & car management pages
├── repositories/     # One repository per model — all database CRUD operations
├── services/         # App-wide singletons
│   ├── current_user_service.dart  # Auth state
│   ├── theme_service.dart         # Theme mode persistence
│   ├── llm_service.dart           # AI/LLM integration for receipt OCR
│   └── image_service.dart         # Image picking utilities
└── theme/
    ├── app_colors.dart    # Centralized color definitions
    └── app_theme.dart     # Light/Dark ThemeData with MD3
```

## Key Conventions

- **Services** are singletons with `init()` called in `main()`, accessed via `Service.instance`
- **Repositories** handle all SQL; pages never write raw queries
- **Theme**: All colors go through `app_colors.dart`; use `AppTheme.lightTheme` / `AppTheme.darkTheme`
- **File naming**: `snake_case.dart` for files, `PascalCase` for classes
- **Dart SDK**: `^3.11.4` with null safety
- **Linting**: `package:flutter_lints/flutter.yaml` (Flutter recommended rules)
- **Android package**: `com.passionzale.imh`

## Dependencies

| Package | Purpose |
|---------|---------|
| `sqflite` | SQLite local storage |
| `shared_preferences` | Key-value persistence |
| `fl_chart` | Fuel consumption charts |
| `image_picker` | Camera/gallery image selection |
| `wakelock_plus` | Keep screen on (debug mode only) |
