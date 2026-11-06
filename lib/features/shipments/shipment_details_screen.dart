import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/breadcrumbs.dart';
import '../../core/widgets/status_badge.dart';
import '../../data/services/analytics_service.dart';
import '../../models/shipment.dart';
import '../../models/status_event.dart';
import 'delete_shipment_dialog.dart';
import 'shipment_form_screen.dart';
import 'update_status_dialog.dart';

/// Деталі відправлення (FR7) з діями: редагувати (FR9),
/// оновити статус (FR11), видалити (FR10).
class ShipmentDetailsScreen extends StatelessWidget {
  const ShipmentDetailsScreen({super.key, required this.shipment});

  final Shipment shipment;

  /// Відкрити екран деталей у поточному розділі.
  static void open(BuildContext context, Shipment shipment) {
    // Власна подія Firebase Analytics: користувач відкрив посилку.
    AnalyticsService.instance.logShipmentOpened(shipment);
    Navigator.of(context).push(AppRoutes.page(ShipmentDetailsScreen(shipment: shipment)));
  }

  void _edit(BuildContext context) {
    ShipmentFormScreen.open(context, shipment: shipment);
  }

  void _updateStatus(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => UpdateStatusDialog(shipment: shipment),
    );
  }

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteShipmentDialog(title: shipment.title),
    );
    // TODO(lab4+): видалення з бази даних.
    if (confirmed == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Breadcrumbs(parent: 'Посилки', current: 'Деталі'),
          const SizedBox(height: AppSpacing.small),
          Wrap(
            spacing: AppSpacing.normal,
            runSpacing: AppSpacing.normal,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(shipment.title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(width: AppSpacing.normal),
                  StatusBadge(status: shipment.status),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppButton(
                    label: 'Редагувати',
                    icon: Icons.edit_outlined,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => _edit(context),
                  ),
                  const SizedBox(width: 10),
                  AppButton(
                    label: 'Оновити статус',
                    icon: Icons.refresh,
                    onPressed: () => _updateStatus(context),
                  ),
                  const SizedBox(width: 10),
                  AppButton(
                    label: 'Видалити',
                    icon: Icons.delete_outline,
                    variant: AppButtonVariant.dangerOutline,
                    onPressed: () => _delete(context),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          LayoutBuilder(
            builder: (context, constraints) {
              final left = Column(
                children: [
                  _InfoCard(shipment: shipment),
                  const SizedBox(height: AppSpacing.medium),
                  const _PhotoCard(),
                ],
              );
              final right = _HistoryCard(shipment: shipment);

              if (constraints.maxWidth >= 820) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: left),
                    const SizedBox(width: AppSpacing.medium),
                    Expanded(flex: 2, child: right),
                  ],
                );
              }
              return Column(
                children: [left, const SizedBox(height: AppSpacing.medium), right],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.shipment});

  final Shipment shipment;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Перевізник', shipment.carrier),
      ('Напрямок', shipment.direction),
      ('Відправник', shipment.sender),
      ('Отримувач', shipment.recipient),
      ('Пункт отримання', shipment.destination),
      ('Дата відправлення', shipment.sentDate),
      ('Очікувана дата', shipment.expectedDate),
      ('Вартість доставки', shipment.cost),
    ];

    return AppCard(
      title: 'Інформація про відправлення',
      child: Column(
        children: [
          _InfoRow(
            label: 'Номер ТТН',
            value: shipment.trackingNumber,
            trailing: IconButton(
              tooltip: 'Скопіювати номер',
              visualDensity: VisualDensity.compact,
              iconSize: 16,
              color: AppColors.primary,
              icon: const Icon(Icons.copy_outlined),
              onPressed: () => Clipboard.setData(ClipboardData(text: shipment.trackingNumber)),
            ),
          ),
          for (final (label, value) in rows) _InfoRow(label: label, value: value),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.trailing});

  final String label;
  final String value;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 170,
            child: Text(label, style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
          ),
          Flexible(
            child: Text(value, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  const _PhotoCard();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: 'Фото посилки / чека',
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset('assets/images/parcel.png', width: 120, height: 120, fit: BoxFit.cover),
          ),
          const SizedBox(width: AppSpacing.medium),
          InkWell(
            onTap: () {
              // TODO(lab4+): вибір і завантаження фото (FR14).
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFC7C7CC)),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: AppColors.textSecondary),
                  SizedBox(height: 6),
                  Text('Додати фото', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.shipment});

  final Shipment shipment;

  @override
  Widget build(BuildContext context) {
    final history = shipment.history;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      title: 'Історія статусів',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (history.isEmpty)
            Text('Історія поки порожня', style: textTheme.bodySmall)
          else
            for (var i = 0; i < history.length; i++)
              _TimelineItem(
                event: history[i],
                isCurrent: i == 0,
                isLast: i == history.length - 1,
              ),
          if (shipment.note != null) ...[
            const SizedBox(height: AppSpacing.medium),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surfaceMuted,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Примітка', style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(shipment.note!, style: textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  const _TimelineItem({
    required this.event,
    required this.isCurrent,
    required this.isLast,
  });

  final StatusEvent event;
  final bool isCurrent;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = event.status.foreground;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: isCurrent ? color : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
            ),
            if (!isLast) Container(width: 2, height: 62, color: AppColors.fieldBorder),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.status.label, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(event.dateTime, style: textTheme.bodySmall),
                const SizedBox(height: 2),
                Text(event.location, style: textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
