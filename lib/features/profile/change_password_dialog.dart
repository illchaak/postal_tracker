import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/message_banner.dart';
import '../../data/repositories/auth_exception.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/analytics_service.dart';

/// Модальна панель зміни пароля (FR13).
/// Повертає true, якщо пароль успішно змінено.
class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    if (_currentController.text == _newController.text) {
      setState(() => _errorMessage = 'Новий пароль має відрізнятися від поточного.');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await AuthRepository.instance.changePassword(
        currentPassword: _currentController.text,
        newPassword: _newController.text,
      );
      AnalyticsService.instance.logPasswordChanged();
      if (mounted) Navigator.pop(context, true);
    } on AuthException catch (e) {
      // Сюди потрапляють: неправильний поточний пароль,
      // requires-recent-login, проблеми з мережею тощо.
      if (mounted) setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Зміна пароля', style: textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(
                  'Мінімум 8 символів, літери та цифри',
                  style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 18),
                if (_errorMessage != null) ...[
                  MessageBanner(message: _errorMessage!),
                  const SizedBox(height: 14),
                ],
                AppTextField(
                  label: 'Поточний пароль',
                  controller: _currentController,
                  isPassword: true,
                  enabled: !_isLoading,
                  validator: Validators.loginPassword,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Новий пароль',
                  controller: _newController,
                  isPassword: true,
                  enabled: !_isLoading,
                  validator: Validators.newPassword,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  label: 'Підтвердження нового пароля',
                  controller: _confirmController,
                  isPassword: true,
                  enabled: !_isLoading,
                  validator: Validators.confirmPassword(_newController),
                  onFieldSubmitted: (_) => _changePassword(),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      label: 'Скасувати',
                      variant: AppButtonVariant.secondary,
                      onPressed: _isLoading ? null : () => Navigator.pop(context, false),
                    ),
                    const SizedBox(width: 12),
                    AppButton(
                      label: 'Змінити пароль',
                      isLoading: _isLoading,
                      onPressed: _changePassword,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
