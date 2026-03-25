import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(9999),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.4),
            blurRadius: 30,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.add_rounded,
            color: AppColors.primaryContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            'New Entry',
            style: AppFonts.lexend(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryContainer,
              height: 20 / 14,
            ),
          ),
        ],
      ),
    );
  }
}
