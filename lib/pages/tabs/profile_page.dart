import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../database/models/user.dart';
import '../../services/current_user_service.dart';
import '../../components/card/card.dart';
import '../../components/cell/cell.dart';
import '../../components/empty/empty.dart';
import '../../components/img_preview/img_preview.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _currentUser;
  final String _heroTag = 'profile-user-avatar';

  @override
  void initState() {
    super.initState();
    _currentUser = CurrentUserService.instance.currentUser;
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

  void _showAvatarPreview() {
    final imageProvider = _getAvatarImage();
    if (imageProvider != null) {
      ImgPreview.show(context, imageProvider, heroTag: _heroTag);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
      ),
      body: _currentUser == null
          ? const EmptyWidget(
              icon: Icons.person_outline,
              message: '暂无用户信息',
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Hero(
                    tag: _heroTag,
                    child: GestureDetector(
                      onTap: _showAvatarPreview,
                      child: CircleAvatar(
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
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CardWidget(
                      title: '个人信息',
                      child: CellWidget(
                        label: '昵称',
                        value: _currentUser!.nickname,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
