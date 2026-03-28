import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';

class LogsTopBar extends StatelessWidget {
  final VoidCallback? onBragTap;

  const LogsTopBar({super.key, this.onBragTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Logs',
            style: AppFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          FilledButton.tonalIcon(
            onPressed: onBragTap,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary.withValues(alpha: 0.16),
              foregroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.auto_awesome_rounded, size: 18),
            label: Text(
              'Brag Doc',
              style: AppFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
