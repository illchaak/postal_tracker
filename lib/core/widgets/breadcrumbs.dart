import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// «Хлібні крихти» над заголовком: «Посилки › Деталі».
/// Натискання на перший пункт повертає на попередній екран.
class Breadcrumbs extends StatelessWidget {
  const Breadcrumbs({super.key, required this.parent, required this.current});

  final String parent;
  final String current;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: Text(
              parent,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        const Icon(Icons.chevron_right, size: 16, color: AppColors.textSecondary),
        Text(
          current,
          style: const TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
