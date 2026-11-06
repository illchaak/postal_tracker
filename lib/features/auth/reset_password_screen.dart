import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/auth_layout.dart';
import '../../core/widgets/message_banner.dart';
import '../../data/repositories/auth_exception.dart';
import '../../data/repositories/auth_repository.dart';

/// Екран відновлення пароля через email (FR3).
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      final email = _emailController.text.trim();
      await AuthRepository.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        setState(() => _successMessage =
            'Якщо акаунт з поштою $email існує, ми надіслали лист із посиланням для зміни пароля. Перевірте також папку «Спам».');
      }
    } on AuthException catch (e) {
      if (mounted) setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
            decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
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
        Form(
          key: _formKey,
          child: AppTextField(
            label: 'Електронна пошта',
            hint: 'name@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            enabled: !_isLoading,
            validator: Validators.email,
            onFieldSubmitted: (_) => _sendResetLink(),
          ),
        ),
        const SizedBox(height: 18),
        AppButton(
          label: _isLoading ? 'Надсилання…' : 'Надіслати посилання',
          expanded: true,
          height: 40,
          isLoading: _isLoading,
          onPressed: _sendResetLink,
        ),
        if (_successMessage != null) ...[
          const SizedBox(height: 16),
          MessageBanner(message: _successMessage!, type: MessageType.success),
        ],
        if (_errorMessage != null) ...[
          const SizedBox(height: 16),
          MessageBanner(message: _errorMessage!),
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
