import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Тип повідомлення: помилка, успіх або інформація.
enum MessageType { error, success, info }

/// Кольорова смужка з повідомленням для користувача
/// (невдалий вхід, лист надіслано, пароль змінено тощо).
class MessageBanner extends StatelessWidget {
  const MessageBanner({super.key, required this.message, this.type = MessageType.error});

  final String message;
  final MessageType type;

  @override
  Widget build(BuildContext context) {
    final (Color background, Color foreground, IconData icon) = switch (type) {
      MessageType.error => (const Color(0xFFFDECEC), AppColors.danger, Icons.error_outline),
      MessageType.success => (AppColors.successLight, AppColors.success, Icons.check_circle_outline),
      MessageType.info => (AppColors.primaryLight, AppColors.primary, Icons.info_outline),
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: foreground),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: foreground, fontWeight: FontWeight.w500, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}
