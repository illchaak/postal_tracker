import 'package:flutter/material.dart';

import '../data/repositories/auth_repository.dart';
import '../data/services/analytics_service.dart';
import '../data/services/crash_reporting_service.dart';
import '../features/auth/login_screen.dart';
import '../features/home/home_shell.dart';
import '../models/user_profile.dart';

/// Вибирає перший екран залежно від стану входу:
/// є користувач — головний екран, немає — екран входу.
/// Під час запуску Firebase відновлює попередній сеанс автоматично.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserProfile?>(
      stream: AuthRepository.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Поки Firebase перевіряє збережений сеанс — індикатор завантаження.
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final user = snapshot.data;
        AnalyticsService.instance.setUserId(user?.uid);
        CrashReportingService.instance.setUserId(user?.uid);

        if (user == null) return const LoginScreen();
        return HomeShell(key: ValueKey(user.uid));
      },
    );
  }
}
