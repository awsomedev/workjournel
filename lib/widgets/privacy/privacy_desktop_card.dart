import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';

class PrivacyDesktopCard extends StatelessWidget {
  final double minHeight;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final Widget? footer;
  final Widget? trailing;
  final bool centerContent;

  const PrivacyDesktopCard({
    super.key,
    required this.minHeight,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    this.footer,
    this.trailing,
    this.centerContent = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: minHeight),
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(48),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: centerContent
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: centerContent
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(height: 32),
                Text(
                  title,
                  textAlign: centerContent ? TextAlign.center : TextAlign.start,
                  style: AppTextStyles.h2.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  description,
                  textAlign: centerContent ? TextAlign.center : TextAlign.start,
                  style: AppTextStyles.bodyMd.copyWith(
                    fontSize: 18,
                    height: 1.6,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                if (footer != null) ...[const SizedBox(height: 40), footer!],
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 48), trailing!],
        ],
      ),
    );
  }
}
