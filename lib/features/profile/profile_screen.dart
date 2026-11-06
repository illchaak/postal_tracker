import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/data/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/message_banner.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/user_avatar.dart';
import '../../core/widgets/user_builder.dart';
import '../../data/repositories/auth_exception.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/analytics_service.dart';
import '../../data/services/crash_reporting_service.dart';
import '../../models/user_profile.dart';
import 'change_password_dialog.dart';
import 'photo_picker_dialog.dart';

/// Екран профілю користувача (FR12, FR13, FR14).
/// Ім'я, email і фото беруться з Firebase Authentication.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xLarge),
      child: UserBuilder(
        builder: (context, user) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const PageHeader(
              title: 'Профіль',
              subtitle: 'Особисті дані та налаштування акаунта',
            ),
            const SizedBox(height: AppSpacing.large),
            LayoutBuilder(
              builder: (context, constraints) {
                final avatarCard = _AvatarCard(user: user);
                final dataCard = _PersonalDataCard(user: user);

                if (constraints.maxWidth >= 760) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 300, child: avatarCard),
                      const SizedBox(width: AppSpacing.medium),
                      Expanded(child: dataCard),
                    ],
                  );
                }
                return Column(
                  children: [avatarCard, const SizedBox(height: AppSpacing.medium), dataCard],
                );
              },
            ),
            const SizedBox(height: AppSpacing.medium),
            const _SecurityCard(),
            const SizedBox(height: AppSpacing.medium),
            const _CrashlyticsTestCard(),
          ],
        ),
      ),
    );
  }
}

void _showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating, width: 460),
  );
}

// ---------------- Фото профілю ----------------

class _AvatarCard extends StatefulWidget {
  const _AvatarCard({required this.user});

  final UserProfile user;

  @override
  State<_AvatarCard> createState() => _AvatarCardState();
}

class _AvatarCardState extends State<_AvatarCard> {
  bool _isLoading = false;

  Future<void> _changePhoto() async {
    final url = await showDialog<String>(
      context: context,
      builder: (_) => PhotoPickerDialog(currentUrl: widget.user.photoUrl),
    );
    if (url == null || !mounted) return;

    setState(() => _isLoading = true);
    try {
      await AuthRepository.instance.updatePhotoUrl(url);
      AnalyticsService.instance.logProfilePhotoChanged();
      if (mounted) _showSnackBar(context, 'Фото профілю оновлено');
    } on AuthException catch (e) {
      if (mounted) _showSnackBar(context, e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        children: [
          Stack(
            children: [
              UserAvatar(initials: user.initials, photoUrl: user.photoUrl, radius: 56),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(Icons.edit, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(user.fullName, style: textTheme.titleLarge, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(user.email, style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.large),
          AppButton(
            label: 'Змінити фото',
            icon: Icons.image_outlined,
            variant: AppButtonVariant.secondary,
            isLoading: _isLoading,
            onPressed: _changePhoto,
          ),
          const SizedBox(height: AppSpacing.small),
          Text('Готові зображення або HTTPS-посилання', style: textTheme.bodySmall),
        ],
      ),
    );
  }
}

// ---------------- Особисті дані ----------------

class _PersonalDataCard extends StatefulWidget {
  const _PersonalDataCard({required this.user});

  final UserProfile user;

  @override
  State<_PersonalDataCard> createState() => _PersonalDataCardState();
}

class _PersonalDataCardState extends State<_PersonalDataCard> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      await AuthRepository.instance.updateDisplayName(_nameController.text);
      if (mounted) setState(() => _successMessage = 'Зміни збережено');
    } on AuthException catch (e) {
      if (mounted) setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Особисті дані',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_errorMessage != null) ...[
              MessageBanner(message: _errorMessage!),
              const SizedBox(height: 14),
            ],
            if (_successMessage != null) ...[
              MessageBanner(message: _successMessage!, type: MessageType.success),
              const SizedBox(height: 14),
            ],
            AppTextField(
              label: "Ім'я та прізвище",
              controller: _nameController,
              enabled: !_isLoading,
              validator: Validators.name,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Електронна пошта',
              initialValue: widget.user.email,
              enabled: false,
              helperText: 'Email використовується для входу і тут не змінюється',
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: AppTextField(
                    label: 'Телефон',
                    initialValue: MockData.stubPhone,
                    helperText: 'Заглушка: збереження — у наступних ЛР',
                  ),
                ),
                const SizedBox(width: AppSpacing.medium),
                Expanded(
                  child: AppDropdown<String>(
                    label: 'Мова інтерфейсу',
                    value: MockData.stubLanguage,
                    items: MockData.languages,
                    itemLabel: (language) => language,
                    onChanged: (_) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.large),
            Align(
              alignment: Alignment.centerRight,
              child: AppButton(label: 'Зберегти зміни', isLoading: _isLoading, onPressed: _save),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------- Безпека ----------------

class _SecurityCard extends StatefulWidget {
  const _SecurityCard();

  @override
  State<_SecurityCard> createState() => _SecurityCardState();
}

class _SecurityCardState extends State<_SecurityCard> {
  bool _isSigningOut = false;

  Future<void> _openChangePassword() async {
    final changed = await showDialog<bool>(
      context: context,
      builder: (_) => const ChangePasswordDialog(),
    );
    if (changed == true && mounted) _showSnackBar(context, 'Пароль успішно змінено');
  }

  Future<void> _logout() async {
    setState(() => _isSigningOut = true);
    try {
      AppRoutes.backToRoot(context);
      // Після виходу AuthGate автоматично покаже екран входу.
      await AuthRepository.instance.signOut();
    } on AuthException catch (e) {
      if (mounted) {
        setState(() => _isSigningOut = false);
        _showSnackBar(context, e.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      title: 'Безпека',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_outline, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Пароль', style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                    Text('Для зміни потрібно ввести поточний пароль', style: textTheme.bodySmall),
                  ],
                ),
              ),
              AppButton(
                label: 'Змінити пароль',
                variant: AppButtonVariant.secondary,
                onPressed: _openChangePassword,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.small),
          TextButton.icon(
            onPressed: _isSigningOut ? null : _logout,
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            icon: const Icon(Icons.logout, size: 18),
            label: const Text('Вийти з акаунта', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ---------------- Тестування Crashlytics ----------------

class _CrashlyticsTestCard extends StatelessWidget {
  const _CrashlyticsTestCard();

  Future<void> _sendNonFatal(BuildContext context) async {
    await CrashReportingService.instance.sendTestNonFatalError();
    if (context.mounted) {
      _showSnackBar(context, 'Тестову помилку надіслано в Firebase Crashlytics. Перезапустіть застосунок, щоб звіт точно відправився.');
    }
  }

  Future<void> _crash(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Викликати збій?'),
        content: const Text('Застосунок аварійно закриється. Звіт про збій буде надіслано під час наступного запуску.'),
        actions: [
          AppButton(
            label: 'Скасувати',
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.pop(dialogContext, false),
          ),
          AppButton(
            label: 'Викликати збій',
            variant: AppButtonVariant.danger,
            onPressed: () => Navigator.pop(dialogContext, true),
          ),
        ],
      ),
    );
    if (confirmed == true) CrashReportingService.instance.crashApp();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Тестування Crashlytics (для розробника)',
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          AppButton(
            label: 'Надіслати тестову помилку',
            icon: Icons.bug_report_outlined,
            variant: AppButtonVariant.secondary,
            onPressed: () => _sendNonFatal(context),
          ),
          AppButton(
            label: 'Викликати збій застосунку',
            icon: Icons.warning_amber_rounded,
            variant: AppButtonVariant.dangerOutline,
            onPressed: () => _crash(context),
          ),
        ],
      ),
    );
  }
}
