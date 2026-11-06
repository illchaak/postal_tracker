import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/shipment_tile.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/user_builder.dart';
import '../../models/shipment_status.dart';
import '../shipments/shipment_details_screen.dart';
import '../shipments/shipment_form_screen.dart';

/// Головний екран «Огляд» (FR4): статистика, останні оновлення,
/// очікувані доставки та швидкі дії.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.onOpenSection});

  /// Перехід до іншого розділу бічної панелі (1 — «Посилки»).
  final ValueChanged<int> onOpenSection;

  static const int _shipmentsSection = 1;

  @override
  Widget build(BuildContext context) {
    const shipments = MockData.shipments;

    final activeCount = shipments.where((s) => s.status.isActive).length;
    final inTransitCount =
        shipments.where((s) => s.status == ShipmentStatus.inTransit).length;
    final atBranchCount =
        shipments.where((s) => s.status == ShipmentStatus.atBranch).length;
    final receivedCount =
        shipments.where((s) => s.status == ShipmentStatus.received).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ім'я користувача береться з Firebase Authentication.
          UserBuilder(
            builder: (context, user) => PageHeader(
              title: 'Вітаємо, ${user.firstName}!',
              subtitle: 'У вас $activeCount активні відправлення',
              action: AppButton(
                label: 'Нова посилка',
                icon: Icons.add,
                onPressed: () => ShipmentFormScreen.open(context),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          Row(
            children: [
              Expanded(child: StatCard(label: 'Активні', value: '$activeCount', color: AppColors.primary)),
              const SizedBox(width: AppSpacing.medium),
              Expanded(child: StatCard(label: 'В дорозі', value: '$inTransitCount', color: const Color(0xFF1A5DB8))),
              const SizedBox(width: AppSpacing.medium),
              Expanded(child: StatCard(label: 'Чекають у відділенні', value: '$atBranchCount', color: AppColors.warning)),
              const SizedBox(width: AppSpacing.medium),
              Expanded(child: StatCard(label: 'Отримано', value: '$receivedCount', color: AppColors.success)),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          LayoutBuilder(
            builder: (context, constraints) {
              final recent = _buildRecentUpdates(context);
              final side = _buildSideColumn(context);

              // Широке вікно — дві колонки, вузьке — одна.
              if (constraints.maxWidth >= 820) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: recent),
                    const SizedBox(width: AppSpacing.medium),
                    Expanded(flex: 2, child: side),
                  ],
                );
              }
              return Column(
                children: [recent, const SizedBox(height: AppSpacing.medium), side],
              );
            },
          ),
        ],
      ),
    );
  }

  /// Імітація оновлення статусів (без запиту до перевізників).
  void _showStatusesUpdated(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        icon: const Icon(Icons.check_circle_outline, color: AppColors.success, size: 36),
        title: const Text('Статуси оновлено'),
        content: const Text(
          'Інформацію про всі активні відправлення оновлено.',
          textAlign: TextAlign.center,
        ),
        actions: [
          AppButton(label: 'OK', onPressed: () => Navigator.pop(dialogContext)),
        ],
      ),
    );
  }

  Widget _buildRecentUpdates(BuildContext context) {
    final recent = MockData.shipments.take(5).toList();

    return AppCard(
      title: 'Останні оновлення',
      trailing: TextButton(
        onPressed: () => onOpenSection(_shipmentsSection),
        child: const Text('Усі посилки →'),
      ),
      child: Column(
        children: [
          for (var i = 0; i < recent.length; i++) ...[
            ShipmentTile(
              shipment: recent[i],
              onTap: () => ShipmentDetailsScreen.open(context, recent[i]),
            ),
            if (i < recent.length - 1) const Divider(height: 1, color: Color(0xFFEFEFF2)),
          ],
        ],
      ),
    );
  }

  Widget _buildSideColumn(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        AppCard(
          title: 'Очікувані доставки',
          child: Column(
            children: [
              for (final item in MockData.upcoming)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.day,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              item.month,
                              style: const TextStyle(fontSize: 11, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(item.carrier, style: textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        AppCard(
          title: 'Швидкі дії',
          child: Column(
            children: [
              AppButton(
                label: 'Додати посилку',
                icon: Icons.add,
                variant: AppButtonVariant.secondary,
                expanded: true,
                onPressed: () => ShipmentFormScreen.open(context),
              ),
              const SizedBox(height: 10),
              AppButton(
                label: 'Знайти за номером ТТН',
                icon: Icons.search,
                variant: AppButtonVariant.secondary,
                expanded: true,
                onPressed: () => onOpenSection(_shipmentsSection),
              ),
              const SizedBox(height: 10),
              AppButton(
                label: 'Оновити статуси',
                icon: Icons.refresh,
                variant: AppButtonVariant.secondary,
                expanded: true,
                onPressed: () => _showStatusesUpdated(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
