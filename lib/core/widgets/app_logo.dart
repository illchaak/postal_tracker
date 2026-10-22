import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Логотип застосунку (посилка з міткою геолокації).
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 72});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset('assets/images/parcel.png', fit: BoxFit.cover),
      ),
    );
  }
}
