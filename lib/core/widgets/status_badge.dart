import 'package:flutter/material.dart';

import '../../models/shipment_status.dart';

/// Кольорова мітка статусу доставки («В дорозі», «Отримано» тощо).
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final ShipmentStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.background,
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: status.foreground,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: status.foreground,
            ),
          ),
        ],
      ),
    );
  }
}
