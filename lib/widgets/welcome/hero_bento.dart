import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';

class HeroBento extends StatelessWidget {
  final ResponsiveSize size;
  const HeroBento({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    if (size == ResponsiveSize.sm) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(40),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const BentoHeroIcon(size: ResponsiveSize.sm),
                  const SizedBox(height: 32),
                  const WelcomeBadge(
                    text: 'AI POWERED LOGGING',
                    size: ResponsiveSize.sm,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (size == ResponsiveSize.md) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(36),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.2,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const BentoHeroIcon(size: ResponsiveSize.md),
                    const SizedBox(height: 36),
                    const WelcomeBadge(
                      text: 'INTELLIGENT JOURNALING',
                      size: ResponsiveSize.md,
                    ),
                    const SizedBox(height: 24),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Never forget what\nyou ',
                            style: AppTextStyles.h1.copyWith(fontSize: 48),
                          ),
                          TextSpan(
                            text: 'accomplished.',
                            style: AppTextStyles.h1.copyWith(
                              fontSize: 48,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        // color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(32),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const BentoHeroIcon(size: ResponsiveSize.lg),
                const SizedBox(height: 60),
                const WelcomeBadge(
                  text: 'INTELLIGENT JOURNALING',
                  size: ResponsiveSize.lg,
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Never forget what\nyou ',
                          style: AppTextStyles.h1,
                        ),
                        TextSpan(
                          text: 'accomplished.',
                          style: AppTextStyles.h1.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BentoHeroIcon extends StatelessWidget {
  final ResponsiveSize size;
  const BentoHeroIcon({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final bool isSmall = size == ResponsiveSize.sm;
    final bool isMedium = size == ResponsiveSize.md;
    final double boxSize = isSmall
        ? 140
        : isMedium
        ? 168
        : 200;
    final double iconSize = isSmall
        ? 60
        : isMedium
        ? 68
        : 80;
    final double sparkleSize = isSmall
        ? 20
        : isMedium
        ? 22
        : 24;

    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(
          isSmall
              ? 32
              : isMedium
              ? 40
              : 48,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.layers_outlined, size: iconSize, color: AppColors.primary),
          Positioned(
            top: isSmall
                ? 30
                : isMedium
                ? 34
                : 40,
            right: isSmall
                ? 30
                : isMedium
                ? 34
                : 40,
            child: Icon(
              Icons.auto_awesome,
              size: sparkleSize,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomeBadge extends StatelessWidget {
  final String text;
  final ResponsiveSize size;
  const WelcomeBadge({super.key, required this.text, required this.size});

  @override
  Widget build(BuildContext context) {
    final bool isSmall = size == ResponsiveSize.sm;
    final bool isMedium = size == ResponsiveSize.md;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall
            ? 24
            : isMedium
            ? 20
            : 16,
        vertical: isSmall
            ? 12
            : isMedium
            ? 9
            : 6,
      ),
      decoration: BoxDecoration(
        color: isSmall
            ? Colors.black.withValues(alpha: 0.3)
            : AppColors.secondaryContainer.withValues(alpha: 0.1),
        border: Border.all(
          color: isSmall
              ? AppColors.outlineVariant.withValues(alpha: 0.3)
              : AppColors.secondary.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSmall) ...[
            Icon(
              Icons.psychology_alt_rounded,
              size: 18,
              color: AppColors.secondary,
            ),
            const SizedBox(width: 12),
          ],
          Text(
            text,
            style: AppFonts.lexend(
              fontSize: isMedium ? 11 : 10,
              fontWeight: FontWeight.w700,
              color: isSmall ? Colors.white : AppColors.secondary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
