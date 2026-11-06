import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:postal_tracker/core/utils/validators.dart';

/// Модульні тести правил валідації полів форм.
void main() {
  group('Validators.email', () {
    test('порожнє поле — помилка', () {
      expect(Validators.email(''), isNotNull);
    });
    test('пошта без @ — помилка', () {
      expect(Validators.email('inna.gmail.com'), isNotNull);
    });
    test('правильна пошта — без помилки', () {
      expect(Validators.email('inna@gmail.com'), isNull);
    });
  });

  group('Validators.newPassword', () {
    test('короткий пароль — помилка', () {
      expect(Validators.newPassword('abc12'), isNotNull);
    });
    test('пароль без цифр — помилка', () {
      expect(Validators.newPassword('abcdefgh'), isNotNull);
    });
    test('правильний пароль — без помилки', () {
      expect(Validators.newPassword('parcel2026'), isNull);
    });
  });

  test('паролі мають збігатися', () {
    final controller = TextEditingController(text: 'parcel2026');
    final validator = Validators.confirmPassword(controller);
    expect(validator('other2026'), 'Паролі не збігаються');
    expect(validator('parcel2026'), isNull);
  });
}
