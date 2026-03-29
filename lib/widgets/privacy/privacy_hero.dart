import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';

class PrivacyHero extends StatelessWidget {
  final ResponsiveSize size;
  const PrivacyHero({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final isMobile = size == ResponsiveSize.sm;

    if (isMobile) {
      return Column(
        children: [
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.verified_user_rounded,
                    color: AppColors.primary,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Your Privacy\n',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 48,
                    height: 1.1,
                    letterSpacing: -1,
                  ),
                ),
                TextSpan(
                  text: 'Matters',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 48,
                    height: 1.1,
                    letterSpacing: -1,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Your data stays on your device. When you choose Claude Code, prompts are processed via Anthropic\'s API under their privacy policy.*',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMd.copyWith(
                fontSize: 18,
                height: 1.5,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.security_rounded,
                color: AppColors.secondary,
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                'PRIVATE BY DESIGN',
                style: AppTextStyles.labelSm.copyWith(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Your Privacy ',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 84,
                  height: 1.0,
                  letterSpacing: -4,
                ),
              ),
              TextSpan(
                text: 'Matters.',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 84,
                  height: 1.0,
                  letterSpacing: -4,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: 600,
          child: Text(
            'WorkJournel gives you two ways to work: fully on-device with local models, or with Claude Code CLI for more capable responses. You choose what leaves your machine.',
            style: AppTextStyles.bodyMd.copyWith(
              fontSize: 20,
              height: 1.6,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
