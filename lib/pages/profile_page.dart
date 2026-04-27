import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 80, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              '个人中心',
              style: TextStyle(fontSize: 20, color: AppColors.textMain),
            ),
          ],
        ),
      ),
    );
  }
}
