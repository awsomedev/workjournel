import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';

class SettingsTopBar extends StatelessWidget {
  final bool showSafeAreaTop;

  const SettingsTopBar({super.key, required this.showSafeAreaTop});

  @override
  Widget build(BuildContext context) {
    final topPadding = showSafeAreaTop
        ? MediaQuery.of(context).padding.top
        : 0.0;
    return Container(
      height: 88 + topPadding,
      padding: EdgeInsets.fromLTRB(24, topPadding + 20, 24, 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Settings',
            style: AppFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
