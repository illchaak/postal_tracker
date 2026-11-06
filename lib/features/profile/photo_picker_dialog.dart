import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';

/// Вибір фото профілю (FR14): готові зображення з HTTPS-посиланнями
/// або власне посилання з попереднім переглядом.
/// Повертає вибране посилання або null, якщо скасовано.
class PhotoPickerDialog extends StatefulWidget {
  const PhotoPickerDialog({super.key, this.currentUrl});

  final String? currentUrl;

  /// Набір готових аватарів (сервіс DiceBear, формат PNG).
  static const List<String> presetUrls = [
    'https://api.dicebear.com/9.x/avataaars/png?seed=Inna&size=160',
    'https://api.dicebear.com/9.x/lorelei/png?seed=Parcel&size=160',
    'https://api.dicebear.com/9.x/notionists/png?seed=Tracker&size=160',
    'https://api.dicebear.com/9.x/adventurer/png?seed=Lviv&size=160',
    'https://api.dicebear.com/9.x/fun-emoji/png?seed=Box&size=160',
    'https://api.dicebear.com/9.x/bottts/png?seed=Post&size=160',
  ];

  @override
  State<PhotoPickerDialog> createState() => _PhotoPickerDialogState();
}

class _PhotoPickerDialogState extends State<PhotoPickerDialog> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();

  String? _selectedUrl;

  /// Посилання, введене вручну, для попереднього перегляду.
  String? _previewUrl;

  @override
  void initState() {
    super.initState();
    _selectedUrl = widget.currentUrl;
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _showPreview() {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _previewUrl = _urlController.text.trim();
      _selectedUrl = _previewUrl;
    });
  }

  Widget _imageTile(String url, {double size = 72}) {
    final selected = url == _selectedUrl;
    return InkWell(
      onTap: () => setState(() => _selectedUrl = url),
      borderRadius: BorderRadius.circular(size),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 3,
          ),
        ),
        child: ClipOval(
          child: Image.network(
            url,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Container(
              width: size,
              height: size,
              color: AppColors.surfaceMuted,
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image_outlined, color: AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Фото профілю', style: textTheme.titleLarge),
              const SizedBox(height: 6),
              Text(
                'Оберіть готове зображення або вставте власне HTTPS-посилання',
                style: textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [for (final url in PhotoPickerDialog.presetUrls) _imageTile(url)],
              ),
              const SizedBox(height: 22),
              Form(
                key: _formKey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: AppTextField(
                        label: 'Власне посилання на зображення',
                        hint: 'https://…',
                        controller: _urlController,
                        keyboardType: TextInputType.url,
                        validator: Validators.httpsUrl,
                        onFieldSubmitted: (_) => _showPreview(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: AppButton(
                        label: 'Переглянути',
                        variant: AppButtonVariant.secondary,
                        height: 44,
                        onPressed: _showPreview,
                      ),
                    ),
                  ],
                ),
              ),
              if (_previewUrl != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    _imageTile(_previewUrl!, size: 96),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Попередній перегляд. Якщо замість фото видно значок помилки — посилання не веде на зображення.',
                        style: textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
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
                    label: 'Зберегти фото',
                    onPressed: _selectedUrl == null ? null : () => Navigator.pop(context, _selectedUrl),
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
