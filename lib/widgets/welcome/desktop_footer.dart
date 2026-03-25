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
          child: isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    copyright,
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 24,
                      runSpacing: 8,
                      children: const [
                        FooterLink(text: 'Privacy'),
                        FooterLink(text: 'Terms'),
                        FooterLink(text: 'Support'),
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    copyright,
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FooterLink(text: 'Privacy'),
                        SizedBox(width: 24),
                        FooterLink(text: 'Terms'),
                        SizedBox(width: 24),
                        FooterLink(text: 'Support'),
                      ],
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class FooterLink extends StatelessWidget {
  final String text;
  const FooterLink({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppFonts.lexend(fontSize: 12, color: AppColors.onSurfaceVariant),
    );
  }
}
