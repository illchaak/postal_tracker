import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/data/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/user_avatar.dart';
import 'change_password_dialog.dart';

/// Екран профілю користувача (FR12, FR14) з переходом до зміни пароля (FR13).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _openChangePassword(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const ChangePasswordDialog(),
    );
  }

  void _logout(BuildContext context) {
    // Головний Navigator (rootNavigator), бо розділи мають власні.
    Navigator.of(context, rootNavigator: true)
        .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeader(
            title: 'Профіль',
            subtitle: 'Особисті дані та налаштування акаунта',
          ),
          const SizedBox(height: AppSpacing.large),
          LayoutBuilder(
            builder: (context, constraints) {
              const avatarCard = _AvatarCard();
              const dataCard = _PersonalDataCard();

              if (constraints.maxWidth >= 760) {
                return const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 300, child: avatarCard),
                    SizedBox(width: AppSpacing.medium),
                    Expanded(child: dataCard),
                  ],
                );
              }
              return const Column(
                children: [avatarCard, SizedBox(height: AppSpacing.medium), dataCard],
              );
            },
          ),
          const SizedBox(height: AppSpacing.medium),
          _SecurityCard(
            onChangePassword: () => _openChangePassword(context),
            onLogout: () => _logout(context),
          ),
        ],
      ),
    );
  }
}

class _AvatarCard extends StatelessWidget {
  const _AvatarCard();

  @override
  Widget build(BuildContext context) {
    const user = MockData.user;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        children: [
          Stack(
            children: [
              UserAvatar(initials: user.initials, radius: 56),
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
          Text(user.fullName, style: textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(user.email, style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppSpacing.large),
          AppButton(
            label: 'Завантажити нове фото',
            icon: Icons.image_outlined,
            variant: AppButtonVariant.secondary,
            onPressed: () {
              // TODO(lab4+): вибір файлу та завантаження фото (FR14).
            },
          ),
          const SizedBox(height: AppSpacing.small),
          Text('JPG або PNG, до 5 МБ', style: textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _PersonalDataCard extends StatelessWidget {
  const _PersonalDataCard();

  @override
  Widget build(BuildContext context) {
    const user = MockData.user;

    return AppCard(
      title: 'Особисті дані',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(label: "Ім'я та прізвище", initialValue: user.fullName),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Електронна пошта',
            initialValue: user.email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  label: 'Телефон',
                  initialValue: user.phone,
                  keyboardType: TextInputType.phone,
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: AppDropdown<String>(
                  label: 'Мова інтерфейсу',
                  value: user.language,
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
            child: AppButton(label: 'Зберегти зміни', onPressed: () {}),
          ),
        ],
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  const _SecurityCard({required this.onChangePassword, required this.onLogout});

  final VoidCallback onChangePassword;
  final VoidCallback onLogout;

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
                    Text(
                      'Останню зміну виконано ${MockData.user.passwordChangedAt}',
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              AppButton(
                label: 'Змінити пароль',
                variant: AppButtonVariant.secondary,
                onPressed: onChangePassword,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.small),
          TextButton.icon(
            onPressed: onLogout,
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            icon: const Icon(Icons.logout, size: 18),
            label: const Text('Вийти з акаунта', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
