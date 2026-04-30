# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**imh** ("I'm here") — A Flutter personal assistant app with daily check-in tasks, car fuel tracking, and data import. Currently v1.0.1.

## Build & Development Commands

```bash
flutter pub get          # Install dependencies
flutter run              # Run the app (debug mode)
flutter build apk        # Build Android APK
flutter build ios        # Build iOS
flutter analyze          # Run static analysis / lint
dart format .            # Format all Dart files
dart format lib/foo.dart # Format a single file
flutter test             # Run all tests
flutter test test/foo_test.dart  # Run a single test file
```

SDK requirement: Dart ^3.11.4

## Architecture

### Layered Structure

```
lib/
├── main.dart              # Entry point, wakelock in debug, init CurrentUserService
├── theme/                 # AppColors + AppTheme (Material ThemeData)
├── services/              # Singleton business services (ChangeNotifier pattern)
├── database/
│   ├── database_helper.dart  # SQLite singleton (sqflite), version 3 with migrations
│   └── models/               # Data models with fromJson/toJson/copyWith
├── repositories/          # CRUD data access, all extend DatabaseHelper
├── components/            # Reusable UI widgets (card, cell, empty state, img preview)
└── pages/
    ├── create_user_page.dart
    ├── index_page.dart        # Bottom nav with IndexedStack (Home + Settings)
    ├── tabs/                  # Tab root pages (home_page, setting_page)
    ├── home/                  # Home sub-pages (fuel records)
    └── settings/              # Settings sub-pages (user edit, check-in, car, data import)
```

### Key Patterns

- **State Management**: `ChangeNotifier` singleton (`CurrentUserService`) + `ListenableBuilder` at root. Local state uses `StatefulWidget`.
- **Database**: SQLite via `sqflite`. `DatabaseHelper` is a singleton; repositories access `db` getter. Migrations in `_onUpgrade` (currently v3).
- **User Session**: `CurrentUserService` persists user to `SharedPreferences`. App shows `CreateUserPage` when no user, `IndexPage` otherwise.
- **Navigation**: Simple `BottomNavigationBar` with `IndexedStack` (2 tabs: Home, Settings). No routing library.
- **Models**: Plain Dart classes with `fromJson`, `toJson`, `copyWith`. No code generation.

### Database Tables

`check_in_tasks`, `check_in_records`, `car`, `car_fuel_record` — defined in `DatabaseHelper._onCreate`.

## OpenSpec

The project uses [OpenSpec](openspec/config.yaml) for spec-driven development. Changes live in `openspec/changes/`, archived specs in `openspec/changes/archive/`. Current specs in `openspec/specs/`.
