import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';

/// Діалог підтвердження видалення (FR10), у стилі Alert на macOS.
/// Повертає true, якщо користувач підтвердив видалення.
class DeleteShipmentDialog extends StatelessWidget {
  const DeleteShipmentDialog({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.warning_rounded, size: 44, color: Color(0xFFFDB022)),
              const SizedBox(height: 12),
              Text(
                'Видалити посилку «$title»?',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                'Посилку та історію її статусів буде видалено. Цю дію не можна скасувати.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              AppButton(
                label: 'Видалити',
                variant: AppButtonVariant.danger,
                expanded: true,
                onPressed: () => Navigator.pop(context, true),
              ),
              const SizedBox(height: 8),
              AppButton(
                label: 'Скасувати',
                variant: AppButtonVariant.secondary,
                expanded: true,
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
