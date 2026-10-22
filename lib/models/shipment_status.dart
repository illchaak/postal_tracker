import 'package:flutter/material.dart';

/// Статуси доставки відправлення з кольорами для відображення.
enum ShipmentStatus {
  created('Створено', Color(0xFFEFEFF2), Color(0xFF55555C)),
  sent('Відправлено', Color(0xFFF0E8FC), Color(0xFF6A3FA3)),
  inTransit('В дорозі', Color(0xFFE3EDFB), Color(0xFF1A5DB8)),
  atBranch('У відділенні', Color(0xFFFFF1DE), Color(0xFFA15C00)),
  received('Отримано', Color(0xFFE4F4E8), Color(0xFF1E7A36)),
  returned('Повернено', Color(0xFFFDE8E7), Color(0xFFB3261E));

  const ShipmentStatus(this.label, this.background, this.foreground);

  final String label;
  final Color background;
  final Color foreground;

  /// Чи відправлення ще в процесі доставки.
  bool get isActive => this != received && this != returned;
}
