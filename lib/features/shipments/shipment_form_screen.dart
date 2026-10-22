import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../core/data/mock_data.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_dropdown.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/breadcrumbs.dart';
import '../../models/shipment.dart';
import '../../models/shipment_status.dart';

/// Форма створення (FR8) або редагування (FR9) відправлення.
/// Якщо [shipment] переданий — форма заповнена його даними.
class ShipmentFormScreen extends StatefulWidget {
  const ShipmentFormScreen({super.key, this.shipment});

  final Shipment? shipment;

  bool get isEditing => shipment != null;

  static void open(BuildContext context, {Shipment? shipment}) {
    Navigator.of(context).push(AppRoutes.page(ShipmentFormScreen(shipment: shipment)));
  }

  @override
  State<ShipmentFormScreen> createState() => _ShipmentFormScreenState();
}

class _ShipmentFormScreenState extends State<ShipmentFormScreen> {
  late String _carrier;
  late bool _isIncoming;
  late ShipmentStatus _status;
  late final TextEditingController _sentDateController;
  late final TextEditingController _expectedDateController;

  @override
  void initState() {
    super.initState();
    final shipment = widget.shipment;
    _carrier = shipment?.carrier ?? MockData.carriers.first;
    _isIncoming = shipment?.isIncoming ?? true;
    _status = shipment?.status ?? ShipmentStatus.created;
    _sentDateController = TextEditingController(text: shipment?.sentDate ?? '');
    _expectedDateController = TextEditingController(text: shipment?.expectedDate ?? '');
  }

  @override
  void dispose() {
    _sentDateController.dispose();
    _expectedDateController.dispose();
    super.dispose();
  }

  /// Системний вибір дати.
  Future<void> _pickDate(TextEditingController controller) async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      initialDate: DateTime(2026, 10, 10),
    );
    if (date != null) {
      final day = date.day.toString().padLeft(2, '0');
      final month = date.month.toString().padLeft(2, '0');
      controller.text = '$day.$month.${date.year}';
    }
  }

  void _save() {
    // TODO(lab4+): валідація та збереження в базі даних.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final shipment = widget.shipment;
    final title = widget.isEditing ? 'Редагування посилки' : 'Нова посилка';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Breadcrumbs(parent: 'Посилки', current: title),
          const SizedBox(height: AppSpacing.small),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.large),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _twoColumns(
                  AppTextField(
                    label: 'Назва відправлення *',
                    initialValue: shipment?.title,
                    hint: 'Наприклад, «Книги для навчання»',
                  ),
                  AppTextField(
                    label: 'Номер ТТН *',
                    initialValue: shipment?.trackingNumber,
                    hint: '14 цифр для Нової пошти',
                  ),
                ),
                _twoColumns(
                  AppDropdown<String>(
                    label: 'Перевізник *',
                    value: _carrier,
                    items: MockData.carriers,
                    itemLabel: (carrier) => carrier,
                    onChanged: (value) => setState(() => _carrier = value ?? _carrier),
                  ),
                  _DirectionSelector(
                    isIncoming: _isIncoming,
                    onChanged: (value) => setState(() => _isIncoming = value),
                  ),
                ),
                _twoColumns(
                  AppTextField(
                    label: 'Відправник',
                    initialValue: shipment?.sender,
                    hint: "Ім'я або назва компанії",
                  ),
                  AppTextField(
                    label: 'Отримувач',
                    initialValue: shipment?.recipient ?? MockData.user.fullName,
                  ),
                ),
                _twoColumns(
                  AppTextField(
                    label: 'Пункт отримання',
                    initialValue: shipment?.destination,
                    hint: 'Місто, відділення або поштомат',
                  ),
                  AppDropdown<ShipmentStatus>(
                    label: 'Статус',
                    value: _status,
                    items: ShipmentStatus.values,
                    itemLabel: (status) => status.label,
                    onChanged: (value) => setState(() => _status = value ?? _status),
                  ),
                ),
                _twoColumns(
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Дата відправлення',
                          controller: _sentDateController,
                          hint: 'дд.мм.рррр',
                          readOnly: true,
                          suffixIcon: Icons.calendar_today_outlined,
                          onTap: () => _pickDate(_sentDateController),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.medium),
                      Expanded(
                        child: AppTextField(
                          label: 'Очікувана дата',
                          controller: _expectedDateController,
                          hint: 'дд.мм.рррр',
                          readOnly: true,
                          suffixIcon: Icons.calendar_today_outlined,
                          onTap: () => _pickDate(_expectedDateController),
                        ),
                      ),
                    ],
                  ),
                  AppTextField(
                    label: 'Вартість доставки, грн',
                    initialValue: shipment?.cost,
                    hint: '0',
                    keyboardType: TextInputType.number,
                  ),
                ),
                _twoColumns(
                  AppTextField(
                    label: 'Примітка',
                    initialValue: shipment?.note,
                    hint: 'Додаткова інформація…',
                    maxLines: 4,
                  ),
                  const _PhotoDropZone(),
                ),
                Text('* — обов’язкові поля', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: AppSpacing.large),
                const Divider(height: 1),
                const SizedBox(height: AppSpacing.medium),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      label: 'Скасувати',
                      variant: AppButtonVariant.secondary,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 12),
                    AppButton(
                      label: widget.isEditing ? 'Зберегти зміни' : 'Зберегти',
                      onPressed: _save,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Два поля в рядок у широкому вікні, одне під одним — у вузькому.
  Widget _twoColumns(Widget left, Widget right) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 640) {
            return Column(children: [left, const SizedBox(height: 18), right]);
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: left),
              const SizedBox(width: AppSpacing.large),
              Expanded(child: right),
            ],
          );
        },
      ),
    );
  }
}

/// Перемикач «Вхідна / Вихідна» (segmented control).
class _DirectionSelector extends StatelessWidget {
  const _DirectionSelector({required this.isIncoming, required this.onChanged});

  final bool isIncoming;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Напрямок', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        SegmentedButton<bool>(
          showSelectedIcon: false,
          segments: const [
            ButtonSegment(value: true, label: Text('Вхідна')),
            ButtonSegment(value: false, label: Text('Вихідна')),
          ],
          selected: {isIncoming},
          onSelectionChanged: (selection) => onChanged(selection.first),
        ),
      ],
    );
  }
}

/// Зона завантаження фото посилки або чека (FR14).
class _PhotoDropZone extends StatelessWidget {
  const _PhotoDropZone();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Фото посилки або чека', style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 6),
        InkWell(
          onTap: () {
            // TODO(lab4+): відкрити системне вікно вибору файлу.
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFB9C9E6)),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image_outlined, color: AppColors.primary),
                SizedBox(height: 6),
                Text('Перетягніть фото сюди або', style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                Text(
                  'оберіть файл (JPG, PNG до 5 МБ)',
                  style: TextStyle(fontSize: 12.5, color: AppColors.primary, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
