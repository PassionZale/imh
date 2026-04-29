import 'dart:io';
import 'package:flutter/material.dart';
import '../database/models/user.dart';
import '../services/current_user_service.dart';
import '../services/image_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  String? _avatarPath;
  final ImageService _imageService = ImageService();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final image = await _imageService.pickImageFromGallery();
    if (image != null) {
      final savedPath = await _imageService.saveAvatar(image);
      setState(() {
        _avatarPath = savedPath;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final user = User(
      nickname: _nicknameController.text,
      avatar: _avatarPath,
    );

    await CurrentUserService.instance.save(user);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.waving_hand_rounded,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      '欢迎来到 imh',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '设置你的昵称和头像以开始使用',
                      style: TextStyle(fontSize: 16, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: _pickAvatar,
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: AppColors.surfaceRaised,
                        backgroundImage: _avatarPath != null &&
                                _avatarPath!.isNotEmpty
                            ? FileImage(File(_avatarPath!))
                            : null,
                        child: _avatarPath == null || _avatarPath!.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add_a_photo_outlined,
                                    size: 28,
                                    color: AppColors.textMuted,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '添加头像',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              )
                            : Align(
                                alignment: Alignment.bottomRight,
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: AppColors.secondary,
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _nicknameController,
                      decoration: InputDecoration(
                        labelText: '昵称',
                        hintText: '请输入昵称',
                        prefixIcon: const Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '请输入昵称';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              '开始使用',
                              style: TextStyle(fontSize: 18),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
