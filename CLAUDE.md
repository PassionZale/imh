# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**imh** is a personal assistant app that integrates commonly used utilities and tools. The name "imh" stands for "I'm here". Specific functionality is still being explored.

- **Package**: `com.passionzale.imh`
- **Dart SDK**: ^3.11.4
- **Design System**: See `DESIGN.md` for comprehensive styling guidelines

## Common Development Commands

### Running the App

```bash
# Run on connected device (debug mode)
flutter run

# Run in specific mode
flutter run --profile
flutter run --release

# List available devices
flutter devices
```

**Note**: On Honor/Huawei/Nubia devices, run `./scripts/adb_devices_fix.sh` before debugging to prevent ADB disconnection issues.

### Building

```bash
# Build Android APK
flutter build apk --release

# Build Android App Bundle
flutter build appbundle --release

# Build iOS
flutter build ios --release
```

### Testing & Quality

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Analyze code
flutter analyze

# Format code (use dart format, not flutter format)
dart format .
```

### Dependencies

```bash
# Install dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Add a new dependency
flutter pub add <package>
```

## Architecture

### Current State

The app is in early development with a minimal structure:
- `lib/main.dart` - Entry point with `MyApp` (MaterialApp) and `MyHomePage` widgets
- Debug mode enables `WakelockPlus` to keep screen on (prevents wireless ADB disconnection)

### Design System Integration

When implementing UI components, follow `DESIGN.md` specifications:

- **Colors**: Use defined semantic colors (#EF4444 primary, #3B82F6 secondary, etc.)
- **Typography**: Fredoka (headlines), Nunito (body), Roboto Mono (code)
- **Spacing**: Base unit 8px, use generous padding for young users
- **Border Radius**: Minimum 12px, buttons use 20px+
- **Touch Targets**: Minimum 48px for all interactive elements
- **Accessibility**: Pair labels with icons, use age-appropriate language

### Platform-Specific Configuration

- **Android**: Gradle Kotlin DSL, namespace `com.passionzale.imh`
- **iOS**: Standard Flutter Runner setup, supports all orientations

## Working Rules

- **Do NOT run flutter run**: User will launch the app manually for testing. Do not attempt to start the Flutter app during development sessions.
