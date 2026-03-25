import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';

class HomeRecentEntriesCard extends StatelessWidget {
  const HomeRecentEntriesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer.withValues(alpha: 0.6),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.1),
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RECENT',
                    style: AppFonts.lexend(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.2,
                      color: AppColors.onSurfaceVariant,
                      height: 16 / 12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _CategoryTag(
                        label: 'PRODUCT',
                        textColor: AppColors.secondary,
                        bgColor: AppColors.secondaryContainer.withValues(
                          alpha: 0.3,
                        ),
                        borderColor: AppColors.secondary.withValues(alpha: 0.2),
                      ),
                      const SizedBox(height: 8),
                      _CategoryTag(
                        label: 'DESIGN',
                        textColor: const Color(0xFFFF7351),
                        bgColor: const Color(0xFFB92902).withValues(alpha: 0.2),
                        borderColor: const Color(
                          0xFFFF7351,
                        ).withValues(alpha: 0.2),
                      ),
                    ],
                  ),
                ],
              ),
              _SeeAllButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTag extends StatelessWidget {
  final String label;
  final Color textColor;
  final Color bgColor;
  final Color borderColor;

  const _CategoryTag({
    required this.label,
    required this.textColor,
    required this.bgColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: AppFonts.lexend(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: textColor,
          height: 1.5,
        ),
      ),
    );
  }
}

class _SeeAllButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'SEE ALL',
          style: AppFonts.lexend(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.0,
            color: AppColors.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.onSurfaceVariant,
          size: 12,
        ),
      ],
    );
  }
}
