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

/// Екран входу за email і паролем (FR2).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  /// Повідомлення після виходу з акаунта («Ви вийшли з акаунта»).
  String? _infoMessage;

  @override
  void initState() {
    super.initState();
    _infoMessage = AuthRepository.instance.takePendingMessage();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_isLoading) return; // блокування повторного надсилання
    if (!_formKey.currentState!.validate()) return; // локальна валідація

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _infoMessage = null;
    });

    try {
      await AuthRepository.instance.signIn(
        email: _emailController.text,
        password: _passwordController.text,
      );
      AnalyticsService.instance.logLogin();
      // Після успішного входу AuthGate сам відкриє головний екран.
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
      children: [
        const Center(child: AppLogo()),
        const SizedBox(height: 20),
        Text('Трекер поштових відправлень', textAlign: TextAlign.center, style: textTheme.headlineSmall),
        const SizedBox(height: 6),
        Text(
          'Увійдіть, щоб переглянути свої посилки',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),
        if (_infoMessage != null) ...[
          MessageBanner(message: _infoMessage!, type: MessageType.info),
          const SizedBox(height: 16),
        ],
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
                label: 'Електронна пошта',
                hint: 'name@example.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
                enabled: !_isLoading,
                validator: Validators.email,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: 'Пароль',
                hint: 'Введіть пароль',
                controller: _passwordController,
                isPassword: true,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.password],
                enabled: !_isLoading,
                validator: Validators.loginPassword,
                onFieldSubmitted: (_) => _signIn(),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _isLoading ? null : () => Navigator.pushNamed(context, AppRoutes.resetPassword),
            child: const Text('Забули пароль?'),
          ),
        ),
        const SizedBox(height: 4),
        AppButton(
          label: _isLoading ? 'Вхід…' : 'Увійти',
          expanded: true,
          height: 40,
          isLoading: _isLoading,
          onPressed: _signIn,
        ),
        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Немає акаунта?', style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
            TextButton(
              onPressed: _isLoading ? null : () => Navigator.pushNamed(context, AppRoutes.register),
              child: const Text('Зареєструватися', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ],
    );
  }
}
