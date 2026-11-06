import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Варіанти оформлення кнопки.
enum AppButtonVariant { primary, secondary, danger, dangerOutline }

/// Стилізована кнопка застосунку (основна, другорядна, небезпечна дія).
/// Під час виконання запиту ([isLoading]) показує індикатор
/// і блокує повторне натискання.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.expanded = false,
    this.height = 36,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;

  /// Розтягнути кнопку на всю доступну ширину.
  final bool expanded;
  final double height;

  /// Стан завантаження: кнопка неактивна і показує індикатор.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final (Color background, Color foreground, Color? borderColor) =
        switch (variant) {
      AppButtonVariant.primary => (AppColors.primary, Colors.white, null),
      AppButtonVariant.secondary =>
        (Colors.white, AppColors.textPrimary, AppColors.fieldBorder),
      AppButtonVariant.danger => (AppColors.danger, Colors.white, null),
      AppButtonVariant.dangerOutline =>
        (Colors.white, AppColors.danger, AppColors.fieldBorder),
    };

    final button = TextButton(
      // null робить кнопку неактивною — захист від повторного надсилання.
      onPressed: isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        disabledBackgroundColor: background.withValues(alpha: 0.7),
        disabledForegroundColor: foreground.withValues(alpha: 0.9),
        minimumSize: Size(0, height),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.medium),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
          side: borderColor == null
              ? BorderSide.none
              : BorderSide(color: borderColor),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading) ...[
            SizedBox.square(
              dimension: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: foreground),
            ),
            const SizedBox(width: 8),
          ] else if (icon != null) ...[
            Icon(icon, size: 16),
            const SizedBox(width: 6),
          ],
          Text(label),
        ],
      ),
    );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}
