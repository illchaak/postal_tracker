import 'package:flutter/material.dart';

import '../../core/data/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/shipment.dart';
import 'shipment_details_screen.dart';
import 'shipment_form_screen.dart';

/// Список відправлень (FR5). Пошук поки лише візуальний.
/// Клік по рядку відкриває деталі відправлення (FR7).
class ShipmentsScreen extends StatelessWidget {
  const ShipmentsScreen({super.key});

  static const List<(String, int)> _columns = [
    ('Назва', 4),
    ('Номер ТТН', 3),
    ('Перевізник', 2),
    ('Напрямок', 2),
    ('Статус', 2),
    ('Очікується', 2),
  ];

  @override
  Widget build(BuildContext context) {
    const shipments = MockData.shipments;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeader(
            title: 'Посилки',
            subtitle: '${shipments.length} відправлень',
            action: AppButton(
              label: 'Нова посилка',
              icon: Icons.add,
              onPressed: () => ShipmentFormScreen.open(context),
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          const SizedBox(
            width: 320,
            child: AppTextField(hint: 'Пошук за назвою або ТТН', prefixIcon: Icons.search),
          ),
          const SizedBox(height: AppSpacing.medium),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceMuted,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radius)),
                  ),
                  child: Row(
                    children: [
                      for (final (title, flex) in _columns)
                        Expanded(
                          flex: flex,
                          child: Text(
                            title,
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                for (final shipment in shipments) _ShipmentRow(shipment: shipment),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShipmentRow extends StatelessWidget {
  const _ShipmentRow({required this.shipment});

  final Shipment shipment;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => ShipmentDetailsScreen.open(context, shipment),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFEFEFF2))),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Text(
                shipment.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(flex: 3, child: Text(shipment.trackingNumber, style: textTheme.bodyMedium)),
            Expanded(flex: 2, child: Text(shipment.carrier, style: textTheme.bodyMedium)),
            Expanded(
              flex: 2,
              child: Text(
                shipment.direction,
                style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: StatusBadge(status: shipment.status),
              ),
            ),
            Expanded(flex: 2, child: Text(shipment.expectedDate, style: textTheme.bodyMedium)),
          ],
        ),
      ),
    );
  }
}
