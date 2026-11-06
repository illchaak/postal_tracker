import 'package:flutter/material.dart';

import '../../models/user_profile.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import 'app_logo.dart';
import 'user_avatar.dart';

/// Пункт меню бічної панелі.
class SidebarItem {
  const SidebarItem({required this.icon, required this.label, this.badge});

  final IconData icon;
  final String label;
  final String? badge;
}

/// Бічна панель навігації (основна навігація на macOS).
class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    required this.user,
  });

  final List<SidebarItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: AppSpacing.sidebarWidth,
      decoration: const BoxDecoration(
        color: AppColors.sidebar,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                const AppLogo(size: 32),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Поштовий трекер',
                      style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text('Ваші відправлення', style: textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 8),
            child: Text(
              'МЕНЮ',
              style: textTheme.labelMedium?.copyWith(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF9A9AA0),
              ),
            ),
          ),
          for (var i = 0; i < items.length; i++)
            _SidebarButton(
              item: items[i],
              selected: i == selectedIndex,
              onTap: () => onSelected(i),
            ),
          const Spacer(),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.medium),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                UserAvatar(initials: user.initials, photoUrl: user.photoUrl, radius: 17),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.fullName,
                        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        user.email,
                        style: textTheme.bodySmall?.copyWith(fontSize: 11),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarButton extends StatelessWidget {
  const _SidebarButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final SidebarItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : const Color(0xFF3A3A3F);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: selected ? AppColors.sidebarSelected : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(7),
          hoverColor: const Color(0xFFE8E8ED),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(item.icon, size: 18, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: color,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                if (item.badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E5EA),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Text(
                      item.badge!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
