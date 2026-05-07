import 'dart:io';
import 'package:flutter/material.dart';
import 'package:imh/database/models/user.dart';
import 'package:imh/services/current_user_service.dart';
import 'package:imh/services/theme_service.dart';
import 'package:imh/theme/app_theme.dart';
import 'package:imh/theme/app_page_route.dart';
import 'package:imh/pages/settings/user_edit_page.dart';
import 'package:imh/pages/check_in/check_in_task_list_page.dart';
import 'package:imh/pages/car/car_list_page.dart';
import 'package:imh/pages/settings/data_import/data_import_page.dart';
import 'package:imh/pages/settings/env_settings_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = CurrentUserService.instance.currentUser;
    CurrentUserService.instance.addListener(_onUserChanged);
    ThemeService.instance.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    CurrentUserService.instance.removeListener(_onUserChanged);
    ThemeService.instance.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onUserChanged() {
    setState(() {
      _currentUser = CurrentUserService.instance.currentUser;
    });
  }

  void _onThemeChanged() {
    setState(() {});
  }

  ImageProvider? _getAvatarImage() {
    if (_currentUser?.avatar != null && _currentUser!.avatar!.isNotEmpty) {
      final file = File(_currentUser!.avatar!);
      if (file.existsSync()) {
        return FileImage(file);
      }
    }
    return null;
  }

  void _navigateToUserEdit() {
    Navigator.of(context).push(
      AppPageRoute(builder: (_) => const UserEditPage()),
    );
  }

  void _navigateToCheckInTasks() {
    Navigator.of(context).push(
      AppPageRoute(builder: (_) => const CheckInTaskListPage()),
    );
  }

  void _navigateToCars() {
    Navigator.of(context).push(
      AppPageRoute(builder: (_) => const CarListPage()),
    );
  }

  void _navigateToDataImport() {
    Navigator.of(context).push(
      AppPageRoute(builder: (_) => const DataImportPage()),
    );
  }

  void _navigateToEnvSettings() {
    Navigator.of(context).push(
      AppPageRoute(builder: (_) => const EnvSettingsPage()),
    );
  }

  String _themeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return '跟随系统';
      case ThemeMode.light:
        return '浅色';
      case ThemeMode.dark:
        return '深色';
    }
  }

  void _showThemePicker() {
    final themeService = ThemeService.instance;
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ThemeMode.values.map((mode) {
              final selected = mode == themeService.themeMode;
              return ListTile(
                leading: Icon(
                  mode == ThemeMode.system
                      ? Icons.brightness_auto
                      : mode == ThemeMode.light
                          ? Icons.light_mode
                          : Icons.dark_mode,
                ),
                title: Text(_themeModeLabel(mode)),
                trailing: selected
                    ? const Icon(Icons.check, size: 20)
                    : null,
                onTap: () {
                  themeService.setMode(mode);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: _currentUser == null
          ? const Center(child: Text('暂无用户信息'))
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: AppTheme.spacing.xl),
                  GestureDetector(
                    onTap: _navigateToUserEdit,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor:
                              colorScheme.surfaceContainerHighest,
                          backgroundImage: _getAvatarImage(),
                          child: _getAvatarImage() == null
                              ? Icon(
                                  Icons.person,
                                  size: 40,
                                  color: colorScheme.onSurfaceVariant,
                                )
                              : null,
                        ),
                        SizedBox(height: AppTheme.spacing.sm),
                        Text(
                          _currentUser!.nickname,
                          style: textTheme.titleLarge?.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppTheme.spacing.xl),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing.md),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading:
                              const Icon(Icons.checklist_rtl_outlined),
                          title: const Text('打卡任务'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: _navigateToCheckInTasks,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading:
                              const Icon(Icons.directions_car_outlined),
                          title: const Text('我的车辆'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: _navigateToCars,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading:
                              const Icon(Icons.file_upload_outlined),
                          title: const Text('数据导入'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: _navigateToDataImport,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.tune),
                          title: const Text('环境变量'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: _navigateToEnvSettings,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.palette_outlined),
                          title: const Text('主题设置'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _themeModeLabel(
                                    ThemeService.instance.themeMode),
                                style: textTheme.labelLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(width: AppTheme.spacing.xs),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                          onTap: _showThemePicker,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
