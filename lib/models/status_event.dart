import 'shipment_status.dart';

/// Запис в історії статусів відправлення.
class StatusEvent {
  const StatusEvent({
    required this.status,
    required this.dateTime,
    required this.location,
  });

  final ShipmentStatus status;
  final String dateTime;
  final String location;
}
