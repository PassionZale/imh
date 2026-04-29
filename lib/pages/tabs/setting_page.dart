import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../database/models/user.dart';
import '../../services/current_user_service.dart';
import '../settings/user_edit_page.dart';
import '../settings/check_in/check_in_task_list_page.dart';
import '../settings/car/car_list_page.dart';

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
  }

  @override
  void dispose() {
    CurrentUserService.instance.removeListener(_onUserChanged);
    super.dispose();
  }

  void _onUserChanged() {
    setState(() {
      _currentUser = CurrentUserService.instance.currentUser;
    });
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
      MaterialPageRoute(builder: (_) => const UserEditPage()),
    );
  }

  void _navigateToCheckInTasks() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CheckInTaskListPage()),
    );
  }

  void _navigateToCars() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CarListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: _currentUser == null
          ? const Center(child: Text('暂无用户信息'))
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: _navigateToUserEdit,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors.surfaceRaised,
                          backgroundImage: _getAvatarImage(),
                          child: _getAvatarImage() == null
                              ? const Icon(
                                  Icons.person,
                                  size: 40,
                                  color: AppColors.textMuted,
                                )
                              : null,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _currentUser!.nickname,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMain,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.checklist_rtl_outlined),
                          title: const Text('打卡任务'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: _navigateToCheckInTasks,
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.directions_car_outlined),
                          title: const Text('我的车辆'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: _navigateToCars,
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
