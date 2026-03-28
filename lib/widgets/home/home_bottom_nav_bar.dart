import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int activeIndex;
  final ValueChanged<int> onTap;

  const HomeBottomNavBar({
    super.key,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 69,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF191919).withValues(alpha: 0.8),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(9999),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 24,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Chat',
                isActive: activeIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: Icons.edit_note_rounded,
                label: 'Log',
                isActive: activeIndex == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                icon: Icons.settings_outlined,
                label: 'Settings',
                isActive: activeIndex == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(9999),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.black : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Text(
              label.toUpperCase(),
              style: AppFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.0,
                color: isActive ? Colors.black : AppColors.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
