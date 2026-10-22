import 'shipment_status.dart';
import 'status_event.dart';

/// Поштове відправлення (основна сутність застосунку).
class Shipment {
  const Shipment({
    required this.id,
    required this.title,
    required this.trackingNumber,
    required this.carrier,
    required this.isIncoming,
    required this.status,
    required this.expectedDate,
    this.sender = '—',
    this.recipient = 'Інна Люльчак',
    this.destination = '—',
    this.sentDate = '—',
    this.cost = '—',
    this.note,
    this.history = const [],
  });

  final String id;
  final String title;
  final String trackingNumber;
  final String carrier;
  final bool isIncoming;
  final ShipmentStatus status;
  final String expectedDate;
  final String sender;
  final String recipient;
  final String destination;
  final String sentDate;
  final String cost;
  final String? note;

  /// Історія статусів (від найновішого до найстарішого).
  final List<StatusEvent> history;

  String get direction => isIncoming ? 'Вхідна' : 'Вихідна';
}
