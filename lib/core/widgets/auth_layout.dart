import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Спільний макет для екранів входу, реєстрації та відновлення пароля:
/// світлий фон і картка з формою по центру вікна.
class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, required this.children, this.width = 400});

  final List<Widget> children;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.authBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Container(
            width: width,
            padding: const EdgeInsets.symmetric(
              horizontal: 36,
              vertical: AppSpacing.xLarge,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radius),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
