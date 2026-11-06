import 'package:flutter/material.dart';

import '../../data/repositories/auth_repository.dart';
import '../../models/user_profile.dart';

/// Перебудовує частину інтерфейсу, коли змінюються дані користувача
/// (наприклад, після зміни імені чи фото профілю).
class UserBuilder extends StatelessWidget {
  const UserBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, UserProfile user) builder;

  @override
  Widget build(BuildContext context) {
    final repository = AuthRepository.instance;

    return StreamBuilder<UserProfile?>(
      stream: repository.profileChanges(),
      initialData: repository.currentProfile,
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user == null) return const SizedBox.shrink();
        return builder(context, user);
      },
    );
  }
}
