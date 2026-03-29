import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';

class HomeSidebar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const HomeSidebar({
    super.key,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 256,
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'WorkJournel',
              style: AppFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: -0.4,
              ),
            ),
          ),
          const SizedBox(height: 48),
          _SidebarNavItem(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Chat',
            isActive: activeIndex == 0,
            onTap: () => onTap(0),
          ),
          const SizedBox(height: 4),
          _SidebarNavItem(
            icon: Icons.edit_note_rounded,
            label: 'Log',
            isActive: activeIndex == 1,
            onTap: () => onTap(1),
          ),
          const SizedBox(height: 4),
          _SidebarNavItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            isActive: activeIndex == 2,
            onTap: () => onTap(2),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarNavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: isActive
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
