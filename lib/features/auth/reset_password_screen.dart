import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/auth_layout.dart';

/// Екран відновлення пароля через email (FR3).
/// Лист не надсилається — лише показується повідомлення.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isEmailSent = false;

  void _sendResetLink() {
    // TODO(lab4+): FirebaseAuth.sendPasswordResetEmail(...)
    setState(() {
      _isEmailSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AuthLayout(
      width: 420,
      children: [
        Center(
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mail_outline, color: AppColors.primary, size: 26),
          ),
        ),
        const SizedBox(height: 16),
        Text('Відновлення пароля', textAlign: TextAlign.center, style: textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Введіть email, вказаний під час реєстрації.\n'
          'Ми надішлемо посилання для зміни пароля.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, height: 1.4),
        ),
        const SizedBox(height: 24),
        const AppTextField(
          label: 'Електронна пошта',
          hint: 'name@example.com',
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 18),
        AppButton(
          label: 'Надіслати посилання',
          expanded: true,
          height: 40,
          onPressed: _sendResetLink,
        ),
        if (_isEmailSent) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.successLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle_outline, size: 18, color: AppColors.success),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Лист для відновлення пароля надіслано',
                    style: TextStyle(color: AppColors.success, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        Center(
          child: TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('Повернутися до входу'),
          ),
        ),
      ],
    );
  }
}
