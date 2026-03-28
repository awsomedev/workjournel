import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:workjournel/theme/app_theme.dart';

class BragDocMarkdownView extends StatelessWidget {
  final String markdown;

  const BragDocMarkdownView({super.key, required this.markdown});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
      child: Markdown(
        data: markdown,
        selectable: true,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        styleSheet: MarkdownStyleSheet(
          h1: AppFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.4,
          ),
          h2: AppFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            height: 1.4,
          ),
          h3: AppFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
            height: 1.4,
          ),
          p: AppFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            height: 1.6,
          ),
          listBullet: AppFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.primary,
            height: 1.6,
          ),
          strong: AppFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          em: AppFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.onSurfaceVariant,
          ),
          code: AppFonts.lexend(
            fontSize: 13,
            color: AppColors.primary,
          ),
          horizontalRuleDecoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.outlineVariant.withValues(alpha: 0.4),
              ),
            ),
          ),
          blockquoteDecoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(4),
            border: Border(
              left: BorderSide(color: AppColors.primary, width: 3),
            ),
          ),
          blockquotePadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          blockquote: AppFonts.lexend(
            fontSize: 14,
            color: AppColors.onSurfaceVariant,
            height: 1.6,
          ),
          h1Padding: const EdgeInsets.only(top: 8, bottom: 4),
          h2Padding: const EdgeInsets.only(top: 16, bottom: 4),
          h3Padding: const EdgeInsets.only(top: 12, bottom: 4),
          pPadding: const EdgeInsets.only(bottom: 8),
          listIndent: 16,
          listBulletPadding: const EdgeInsets.only(right: 8),
        ),
      ),
    );
  }
}
