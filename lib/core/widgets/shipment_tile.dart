import 'package:flutter/material.dart';

import '../../models/shipment.dart';
import '../theme/app_colors.dart';
import 'status_badge.dart';

/// Рядок зі стислою інформацією про відправлення.
class ShipmentTile extends StatelessWidget {
  const ShipmentTile({super.key, required this.shipment, this.onTap});

  final Shipment shipment;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F4F8),
                borderRadius: BorderRadius.circular(9),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shipment.title,
                    style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${shipment.carrier} · ТТН ${shipment.trackingNumber}',
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            StatusBadge(status: shipment.status),
          ],
        ),
      ),
    );
  }
}
