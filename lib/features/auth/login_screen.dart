import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/auth_layout.dart';

/// Екран входу (FR2). Без бізнес-логіки: кнопка «Увійти»
/// одразу відкриває головний екран, як після успішної авторизації.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _onLoginPressed(BuildContext context) {
    // TODO(lab4+): перевірка даних через Firebase Authentication.
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AuthLayout(
      children: [
        const Center(child: AppLogo()),
        const SizedBox(height: 20),
        Text(
          'Трекер поштових відправлень',
          textAlign: TextAlign.center,
          style: textTheme.headlineSmall,
        ),
        const SizedBox(height: 6),
        Text(
          'Увійдіть, щоб переглянути свої посилки',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 28),
        const AppTextField(
          label: 'Електронна пошта',
          hint: 'name@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        const AppTextField(
          label: 'Пароль',
          hint: 'Введіть пароль',
          isPassword: true,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.resetPassword),
            child: const Text('Забули пароль?'),
          ),
        ),
        const SizedBox(height: 4),
        AppButton(
          label: 'Увійти',
          expanded: true,
          height: 40,
          onPressed: () => _onLoginPressed(context),
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Немає акаунта?',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
              child: const Text(
                'Зареєструватися',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
