import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'services/current_user_service.dart';
import 'theme/app_theme.dart';
import 'pages/create_user_page.dart';
import 'pages/index_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) {
    WakelockPlus.enable();
  }
  await CurrentUserService.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMH',
      theme: AppTheme.lightTheme,
      home: ListenableBuilder(
        listenable: CurrentUserService.instance,
        builder: (context, child) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: CurrentUserService.instance.currentUser == null
                ? const CreateUserPage(key: ValueKey('create'))
                : const IndexPage(key: ValueKey('home')),
          );
        },
      ),
    );
  }
}
