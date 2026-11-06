import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Аватар користувача: фото за HTTPS-посиланням або ініціали,
/// якщо фото немає чи його не вдалося завантажити.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.initials,
    this.photoUrl,
    this.radius = 18,
  });

  final String initials;
  final String? photoUrl;
  final double radius;

  Widget _initials() {
    return Container(
      color: const Color(0xFFC9DAF6),
      alignment: Alignment.center,
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

  @override
  Widget build(BuildContext context) {
    final url = photoUrl;

    return SizedBox.square(
      dimension: radius * 2,
      child: ClipOval(
        child: url == null || url.isEmpty
            ? _initials()
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _initials(),
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : _initials(),
              ),
      ),
    );
  }
}
