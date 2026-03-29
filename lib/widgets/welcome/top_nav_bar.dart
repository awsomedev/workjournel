import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';

class TopNavBar extends StatelessWidget {
  final ResponsiveSize size;
  const TopNavBar({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final bool isSmall = size == ResponsiveSize.sm;
    final bool isMedium = size == ResponsiveSize.md;
    return Container(
      height: isSmall
          ? 80
          : isMedium
          ? 88
          : 80,
      padding: EdgeInsets.symmetric(
        horizontal: isSmall
            ? 24
            : isMedium
            ? 36
            : 48,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'WorkJournal',
            style: AppFonts.plusJakartaSans(
              fontSize: isSmall
                  ? 24
                  : isMedium
                  ? 26
                  : 24,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: -0.6,
            ),
          ),
        ],
      ),
    );
  }
}
