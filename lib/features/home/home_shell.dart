import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/data/mock_data.dart';
import '../../core/widgets/app_sidebar.dart';
import '../../core/widgets/user_builder.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/analytics_service.dart';
import '../profile/profile_screen.dart';
import '../shipments/shipments_screen.dart';
import 'dashboard_screen.dart';

/// Основний каркас застосунку після входу:
/// бічна панель зліва та вміст обраного розділу справа.
/// Кожен розділ має власний Navigator, тож екрани деталей і форм
/// відкриваються праворуч, а бічна панель залишається на місці.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  static const _screenNames = ['dashboard', 'shipments', 'profile'];

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logScreen(_screenNames[_selectedIndex]);
    // Після побудови екрана показуємо стан сеансу:
    // успішний вхід/реєстрація або відновлений сеанс.
    WidgetsBinding.instance.addPostFrameCallback((_) => _showSessionMessage());
  }

  void _showSessionMessage() {
    if (!mounted) return;
    final repository = AuthRepository.instance;
    final message = repository.takePendingMessage() ??
        'Сеанс відновлено. Ви увійшли як ${repository.currentProfile?.email ?? ''}';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating, width: 460),
    );
  }

  void _selectSection(int index) {
    setState(() {
      _selectedIndex = index;
    });
    AnalyticsService.instance.logScreen(_screenNames[index]);
  }

  Widget _buildSection(int index) {
    return switch (index) {
      0 => DashboardScreen(onOpenSection: _selectSection),
      1 => const ShipmentsScreen(),
      _ => const ProfileScreen(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final sidebarItems = [
      const SidebarItem(icon: Icons.home_outlined, label: 'Огляд'),
      SidebarItem(
        icon: Icons.inventory_2_outlined,
        label: 'Посилки',
        badge: '${MockData.shipments.length}',
      ),
      const SidebarItem(icon: Icons.person_outline, label: 'Профіль'),
    ];

    return Scaffold(
      body: Row(
        children: [
          // Дані користувача в бічній панелі оновлюються після зміни профілю.
          UserBuilder(
            builder: (context, user) => AppSidebar(
              items: sidebarItems,
              selectedIndex: _selectedIndex,
              onSelected: _selectSection,
              user: user,
            ),
          ),
          Expanded(
            child: Navigator(
              // Новий ключ — новий стек екранів при зміні розділу.
              key: ValueKey(_selectedIndex),
              onGenerateRoute: (_) => AppRoutes.page(_buildSection(_selectedIndex)),
            ),
          ),
        ],
      ),
    );
  }
}
