import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';

class SupportingBenefits extends StatelessWidget {
  final ResponsiveSize size;
  const SupportingBenefits({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final bool isSmall = size == ResponsiveSize.sm;
    final bool isMedium = size == ResponsiveSize.md;
    return Column(
      children: [
        BenefitCard(
          title: 'Log your work in 30 seconds',
          subtitle: isSmall
              ? 'Efficiency meets simplicity.'
              : isMedium
              ? 'Capture progress quickly and keep momentum.'
              : 'Frictionless capture for your busiest days.',
          icon: Icons.timer_outlined,
          size: size,
        ),
        const SizedBox(height: 12),
        BenefitCard(
          title: 'AI organizes everything',
          subtitle: isSmall
              ? 'Your data, perfectly categorized.'
              : isMedium
              ? 'Smart summaries and categories generated instantly.'
              : 'Tags, summaries, and impact metrics created automatically.',
          icon: Icons.auto_awesome_outlined,
          size: size,
        ),
        const SizedBox(height: 12),
        BenefitCard(
          title: 'Always ready for reviews',
          subtitle: isSmall
              ? 'Instant insights when you need them.'
              : isMedium
              ? 'Generate polished updates for your next check-in.'
              : 'Generate performance reports in one click.',
          icon: Icons.trending_up_outlined,
          size: size,
        ),
      ],
    );
  }
}

class BenefitCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final ResponsiveSize size;

  const BenefitCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSmall = size == ResponsiveSize.sm;
    final bool isMedium = size == ResponsiveSize.md;
    return Container(
      padding: EdgeInsets.all(
        isSmall
            ? 20
            : isMedium
            ? 24
            : 32,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(
          isSmall
              ? 12
              : isMedium
              ? 20
              : 32,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.plusJakartaSans(
                    fontSize: isSmall
                        ? 16
                        : isMedium
                        ? 17
                        : 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySm.copyWith(
                    fontSize: isSmall
                        ? 13
                        : isMedium
                        ? 13.5
                        : 14,
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
