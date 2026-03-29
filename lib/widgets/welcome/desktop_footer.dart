import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';

class DesktopFooter extends StatelessWidget {
  const DesktopFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 420;
        final copyright = Text(
          '© 2026 WorkJournal',
          style: AppFonts.lexend(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
        );
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 20 : 48,
            vertical: 32,
          ),
          child: copyright,
        );
      },
    );
  }
}
