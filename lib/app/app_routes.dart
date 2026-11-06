import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/reset_password_screen.dart';
import 'auth_gate.dart';

/// Іменовані маршрути застосунку.
class AppRoutes {
  AppRoutes._();

  /// Кореневий маршрут: AuthGate показує вхід або головний екран.
  static const String root = '/';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';

  static Map<String, WidgetBuilder> get routes => {
        root: (_) => const AuthGate(),
        register: (_) => const RegisterScreen(),
        resetPassword: (_) => const ResetPasswordScreen(),
      };

  /// Маршрут для екранів усередині основної частини вікна
  /// (праворуч від бічної панелі).
  static Route<T> page<T>(Widget child) {
    return MaterialPageRoute<T>(
      builder: (_) => Material(color: AppColors.background, child: child),
    );
  }

  /// Повернення до кореневого екрана (після реєстрації або виходу).
  static void backToRoot(BuildContext context) {
    Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
  }
}
