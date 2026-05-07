import 'dart:io';
import 'package:flutter/material.dart';
import '../../database/models/user.dart';
import '../../services/current_user_service.dart';
import '../../services/image_service.dart';
import '../../theme/app_theme.dart';

class UserEditPage extends StatefulWidget {
  const UserEditPage({super.key});

  @override
  State<UserEditPage> createState() => _UserEditPageState();
}

class _UserEditPageState extends State<UserEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();
  String? _avatarPath;
  final ImageService _imageService = ImageService();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final user = CurrentUserService.instance.currentUser;
    if (user != null) {
      _nicknameController.text = user.nickname;
      _avatarPath = user.avatar;
    }
  }

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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final user = User(
      nickname: _nicknameController.text,
      avatar: _avatarPath,
    );

    await CurrentUserService.instance.save(user);

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑个人信息'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.spacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: AppTheme.spacing.md),
              GestureDetector(
                onTap: _pickAvatar,
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  backgroundImage: _avatarPath != null &&
                          _avatarPath!.isNotEmpty
                      ? FileImage(File(_avatarPath!))
                      : null,
                  child: _avatarPath == null || _avatarPath!.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              size: 28,
                              color: colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(height: AppTheme.spacing.xs),
                            Text(
                              '更换头像',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        )
                      : Align(
                          alignment: Alignment.bottomRight,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: colorScheme.primary,
                            child: Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(height: AppTheme.spacing.xl),
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: '昵称',
                  hintText: '请输入昵称',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入昵称';
                  }
                  return null;
                },
              ),
              SizedBox(height: AppTheme.spacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _save,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radius.md),
                    ),
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : Text(
                          '保存',
                          style: textTheme.titleLarge?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
