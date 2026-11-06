import 'package:flutter/widgets.dart';

/// Правила перевірки (валідації) полів форм.
/// Кожен метод повертає текст помилки або null, якщо значення правильне.
class Validators {
  Validators._();

  static final RegExp _emailRegExp = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
  static final RegExp _letterRegExp = RegExp(r'[A-Za-zА-Яа-яІіЇїЄєҐґ]');
  static final RegExp _digitRegExp = RegExp(r'\d');

  static String? name(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return "Введіть ім'я та прізвище";
    if (text.length < 2) return "Ім'я має містити щонайменше 2 символи";
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Введіть електронну пошту';
    if (!_emailRegExp.hasMatch(text)) {
      return 'Неправильний формат email, наприклад name@example.com';
    }
    return null;
  }

  /// Пароль для входу: лише перевірка, що поле не порожнє.
  static String? loginPassword(String? value) {
    if (value == null || value.isEmpty) return 'Введіть пароль';
    return null;
  }

  /// Новий пароль (реєстрація, зміна пароля).
  static String? newPassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) return 'Введіть пароль';
    if (text.length < 8) return 'Пароль має містити щонайменше 8 символів';
    if (!_letterRegExp.hasMatch(text)) return 'Пароль має містити хоча б одну літеру';
    if (!_digitRegExp.hasMatch(text)) return 'Пароль має містити хоча б одну цифру';
    return null;
  }

  /// Підтвердження пароля: має збігатися з полем [passwordController].
  static FormFieldValidator<String> confirmPassword(TextEditingController passwordController) {
    return (value) {
      if (value == null || value.isEmpty) return 'Повторіть пароль';
      if (value != passwordController.text) return 'Паролі не збігаються';
      return null;
    };
  }

  static String? requiredField(String? value, {String message = 'Заповніть це поле'}) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  static String? trackingNumber(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Введіть номер ТТН';
    if (text.length < 8) return 'Номер ТТН має містити щонайменше 8 символів';
    return null;
  }

  static String? httpsUrl(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Вставте посилання на зображення';
    final uri = Uri.tryParse(text);
    if (uri == null || uri.scheme != 'https' || uri.host.isEmpty) {
      return 'Посилання має починатися з https://';
    }
    return null;
  }
}
