import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Аватар користувача з ініціалами (поки немає завантаженого фото).
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.initials, this.radius = 18});

  final String initials;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFC9DAF6),
      child: Text(
        initials,
        style: TextStyle(
          fontSize: radius * 0.8,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
