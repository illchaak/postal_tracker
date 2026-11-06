import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Стилізоване поле введення з підписом і перевіркою (validator).
/// Для паролів показує кнопку «показати / сховати пароль».
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.isPassword = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.helperText,
    this.maxLines = 1,
    this.readOnly = false,
    this.enabled = true,
    this.onTap,
    this.validator,
    this.textInputAction,
    this.onFieldSubmitted,
    this.onChanged,
    this.autofillHints,
  });

  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final bool isPassword;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final String? helperText;
  final int maxLines;

  /// Поле лише для читання (наприклад, вибір дати через календар).
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;

  /// Функція перевірки: повертає текст помилки або null.
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofillHints;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  OutlineInputBorder _border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSpacing.fieldRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget? _buildSuffix() {
    if (widget.isPassword) {
      return IconButton(
        onPressed: _toggleVisibility,
        tooltip: _obscureText ? 'Показати пароль' : 'Сховати пароль',
        icon: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 18,
          color: AppColors.textSecondary,
        ),
      );
    }
    if (widget.suffixIcon != null) {
      return Icon(widget.suffixIcon, size: 18, color: AppColors.textSecondary);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: textTheme.labelMedium),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: widget.controller,
          initialValue: widget.controller == null ? widget.initialValue : null,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          onTap: widget.onTap,
          validator: widget.validator,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          onChanged: widget.onChanged,
          autofillHints: widget.autofillHints,
          // Помилка показується, щойно користувач почав виправляти поле.
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: AppColors.textHint, fontSize: 13),
            helperText: widget.helperText,
            helperMaxLines: 2,
            errorMaxLines: 2,
            isDense: true,
            filled: true,
            fillColor: widget.enabled ? Colors.white : AppColors.surfaceMuted,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.normal,
              vertical: 13,
            ),
            prefixIcon: widget.prefixIcon == null
                ? null
                : Icon(widget.prefixIcon, size: 18, color: AppColors.textSecondary),
            suffixIcon: _buildSuffix(),
            border: _border(AppColors.fieldBorder),
            enabledBorder: _border(AppColors.fieldBorder),
            disabledBorder: _border(AppColors.border),
            focusedBorder: _border(AppColors.primary, 2),
            errorBorder: _border(AppColors.danger),
            focusedErrorBorder: _border(AppColors.danger, 2),
          ),
        ),
      ],
    );
  }
}
