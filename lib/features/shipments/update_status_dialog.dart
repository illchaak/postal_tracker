import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_text_field.dart';
import '../../models/shipment.dart';
import '../../models/shipment_status.dart';

/// Модальна панель оновлення статусу доставки (FR11).
class UpdateStatusDialog extends StatefulWidget {
  const UpdateStatusDialog({super.key, required this.shipment});

  final Shipment shipment;

  @override
  State<UpdateStatusDialog> createState() => _UpdateStatusDialogState();
}

class _UpdateStatusDialogState extends State<UpdateStatusDialog> {
  late ShipmentStatus _status;

  @override
  void initState() {
    super.initState();
    _status = widget.shipment.status;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Оновити статус', style: textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                '${widget.shipment.title} · ТТН ${widget.shipment.trackingNumber}',
                style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 22),
              AppDropdown<ShipmentStatus>(
                label: 'Новий статус *',
                value: _status,
                items: ShipmentStatus.values,
                itemLabel: (status) => status.label,
                onChanged: (status) {
                  if (status != null) setState(() => _status = status);
                },
              ),
              const SizedBox(height: 14),
              const AppTextField(label: 'Місцезнаходження', hint: 'Наприклад, Львів, відділення №12'),
              const SizedBox(height: 14),
              const Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Дата',
                      initialValue: '10.10.2026',
                      suffixIcon: Icons.calendar_today_outlined,
                    ),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: AppTextField(
                      label: 'Час',
                      initialValue: '09:45',
                      suffixIcon: Icons.schedule,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const AppTextField(label: 'Коментар', hint: 'Необов’язково', maxLines: 3),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    label: 'Скасувати',
                    variant: AppButtonVariant.secondary,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 12),
                  AppButton(
                    label: 'Зберегти',
                    // TODO(lab4+): збереження нового статусу в історії.
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
