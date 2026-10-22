import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/reset_password_screen.dart';
import '../features/home/home_shell.dart';

/// Іменовані маршрути застосунку.
class AppRoutes {
  AppRoutes._();

  static const String login = '/';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';

  static Map<String, WidgetBuilder> get routes => {
        login: (_) => const LoginScreen(),
        register: (_) => const RegisterScreen(),
        resetPassword: (_) => const ResetPasswordScreen(),
        home: (_) => const HomeShell(),
      };

  /// Маршрут для екранів усередині основної частини вікна
  /// (праворуч від бічної панелі).
  static Route<T> page<T>(Widget child) {
    return MaterialPageRoute<T>(
      builder: (_) => Material(color: AppColors.background, child: child),
    );
  }
}
