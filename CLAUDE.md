# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**imh** is a Flutter mobile application (Android + iOS) targeting children aged 5-12 as part of the KidLearn educational platform. The project was migrated from a Next.js web application in April 2026.

- **Framework**: Flutter SDK (stable channel)
- **Language**: Dart ^3.11.4
- **Platforms**: Android and iOS only

## Design System

Use [DESIGN.md](DESIGN.md) as reference before write any UI.

## Common Development Commands

```bash
# Run the app (Debug mode - with WakeLock enabled)
flutter run

# Run in Profile mode (for performance testing)
flutter run --profile

# Run in Release mode
flutter run --release

# Analyze code
flutter analyze

# Run tests
flutter test

# Format code
flutter format .

# Clean build cache
flutter clean

# Get dependencies
flutter pub get
flutter pub upgrade

# Build Android APK
flutter build apk --debug
flutter build apk --release

# Build Android App Bundle (for Play Store)
flutter build appbundle --release
```

## Device Debugging

For **Honor/Huawei/Nubia** devices, run the ADB fix script before debugging:

```bash
./scripts/adb_devices_fix.sh
```

This sets `persist.log.tag` to `I` to enable proper debugging. The VSCode launch configuration automatically runs this as a pre-launch task.

## Project Structure

```
lib/
  main.dart           # App entry point
test/                 # Widget and unit tests
openspec/
  config.yaml         # OpenSpec configuration
  specs/              # Capability specifications
  changes/            # Active and archived changes
scripts/
  adb_devices_fix.sh  # Device debugging fix
android/              # Android platform configuration
ios/                  # iOS platform configuration
```
