import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/auth_layout.dart';

/// Екран реєстрації (FR1). Без бізнес-логіки: після натискання
/// «Зареєструватися» відкривається головний екран.
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AuthLayout(
      width: 420,
      children: [
        const Center(child: AppLogo(size: 60)),
        const SizedBox(height: 16),
        Text('Створення акаунта', textAlign: TextAlign.center, style: textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          'Заповніть дані для реєстрації',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        const AppTextField(label: "Ім'я та прізвище", hint: 'Наприклад, Інна Люльчак'),
        const SizedBox(height: 14),
        const AppTextField(
          label: 'Електронна пошта',
          hint: 'name@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        const AppTextField(
          label: 'Пароль',
          hint: 'Створіть пароль',
          isPassword: true,
          helperText: 'Мінімум 8 символів, літери та цифри',
        ),
        const SizedBox(height: 14),
        const AppTextField(
          label: 'Підтвердження пароля',
          hint: 'Повторіть пароль',
          isPassword: true,
        ),
        const SizedBox(height: 24),
        AppButton(
          label: 'Зареєструватися',
          expanded: true,
          height: 40,
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (route) => false,
          ),
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Вже маєте акаунт?',
              style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Увійти', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ],
    );
  }
}
