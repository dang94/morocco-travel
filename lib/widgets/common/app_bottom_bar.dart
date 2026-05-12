import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class AppBottomBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const AppBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, bottomInset + 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        border: const Border(
          top: BorderSide(color: AppColors.secondary, width: 2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            label: 'Weather',
            icon: Icons.cloud_outlined,
            activeIcon: Icons.cloud,
            active: selectedIndex == 0,
            onTap: () => onTabSelected(0),
          ),
          _NavItem(
            label: 'Cities',
            icon: Icons.explore_outlined,
            activeIcon: Icons.explore,
            active: selectedIndex == 1,
            onTap: () => onTabSelected(1),
          ),
          _NavItem(
            label: 'Tips',
            icon: Icons.lightbulb_outline,
            activeIcon: Icons.lightbulb,
            active: selectedIndex == 2,
            onTap: () => onTabSelected(2),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.secondary : AppColors.outline;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(active && activeIcon != null ? activeIcon : icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.labelCaps.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
