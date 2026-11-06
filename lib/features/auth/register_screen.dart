import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_logo.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/auth_layout.dart';
import '../../core/widgets/message_banner.dart';
import '../../data/repositories/auth_exception.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/analytics_service.dart';

/// Екран реєстрації (FR1) з валідацією полів через Form.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Ключ форми створюється один раз (не в build), щоб не втрачати її стан.
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_isLoading) return;
    // Перевіряє всі поля форми; якщо є помилки — показує їх під полями.
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await AuthRepository.instance.signUp(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
      AnalyticsService.instance.logSignUp();
      // Користувач уже увійшов — повертаємось до AuthGate (головний екран).
      if (mounted) AppRoutes.backToRoot(context);
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
        if (_errorMessage != null) ...[
          MessageBanner(message: _errorMessage!),
          const SizedBox(height: 16),
        ],
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                label: "Ім'я та прізвище",
                hint: 'Наприклад, Інна Люльчак',
                controller: _nameController,
                textInputAction: TextInputAction.next,
                enabled: !_isLoading,
                validator: Validators.name,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Електронна пошта',
                hint: 'name@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                enabled: !_isLoading,
                validator: Validators.email,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Пароль',
                hint: 'Створіть пароль',
                controller: _passwordController,
                isPassword: true,
                textInputAction: TextInputAction.next,
                helperText: 'Мінімум 8 символів, літери та цифри',
                enabled: !_isLoading,
                validator: Validators.newPassword,
              ),
              const SizedBox(height: 14),
              AppTextField(
                label: 'Підтвердження пароля',
                hint: 'Повторіть пароль',
                controller: _confirmController,
                isPassword: true,
                textInputAction: TextInputAction.done,
                enabled: !_isLoading,
                validator: Validators.confirmPassword(_passwordController),
                onFieldSubmitted: (_) => _register(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        AppButton(
          label: _isLoading ? 'Створення акаунта…' : 'Зареєструватися',
          expanded: true,
          height: 40,
          isLoading: _isLoading,
          onPressed: _register,
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Вже маєте акаунт?', style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
            TextButton(
              onPressed: _isLoading ? null : () => Navigator.pop(context),
              child: const Text('Увійти', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ],
    );
  }
}
