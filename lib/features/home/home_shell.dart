import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/data/mock_data.dart';
import '../../core/widgets/app_sidebar.dart';
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

  void _selectSection(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
          AppSidebar(
            items: sidebarItems,
            selectedIndex: _selectedIndex,
            onSelected: _selectSection,
            user: MockData.user,
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
