import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/privacy_viewmodel.dart';
import 'package:workjournel/widgets/privacy/privacy_mobile_card.dart';
import 'package:workjournel/widgets/privacy/privacy_desktop_card.dart';
import 'package:workjournel/widgets/privacy/privacy_action_button.dart';

class PrivacyBento extends StatelessWidget {
  final ResponsiveSize size;
  final PrivacyViewModel viewModel;
  const PrivacyBento({super.key, required this.size, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    if (size == ResponsiveSize.sm) {
      return Column(
        children: [
          const PrivacyMobileCard(
            icon: Icons.psychology_outlined,
            iconColor: AppColors.secondary,
            title: 'Local-First AI',
            description:
                'AI processing happens on your device where possible, keeping data off remote servers.',
          ),
          const SizedBox(height: 24),
          const PrivacyMobileCard(
            icon: Icons.folder_shared_outlined,
            iconColor: AppColors.primary,
            title: 'You Own Your Logs',
            description:
                'Export or delete your entire history at any time with a single click.',
          ),
        ],
      );
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: PrivacyDesktopCard(
                minHeight: 440,
                icon: Icons.memory_rounded,
                iconColor: AppColors.primary,
                title: 'Local-First AI',
                description:
                    'Your data never leaves your device. All AI processing —from transcription to analysis—happens locally using high-performance on-device neural engines.',
                footer: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.memory_rounded,
                        color: AppColors.onSurfaceVariant,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.onSurfaceVariant,
                        size: 16,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'EDGE COMPUTING ACTIVE',
                        style: AppTextStyles.labelSm.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 24),
            const Expanded(
              flex: 4,
              child: PrivacyDesktopCard(
                minHeight: 440,
                icon: Icons.shutter_speed_rounded,
                iconColor: AppColors.secondary,
                title: 'Zero Latency',
                description: 'No cloud round-trips means instant results.',
                centerContent: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        PrivacyDesktopCard(
          minHeight: 320,
          icon: Icons.vpn_key_outlined,
          iconColor: AppColors.secondary,
          title: 'You Own Your Logs',
          description:
              'We have no backdoor. Export your entire history in open formats (Markdown, JSON) or wipe everything with a single tap. Your data is your property.',
          footer: Row(
            children: [
              PrivacyActionButton(
                label: 'EXPORT ALL',
                onPressed: viewModel.onExportData,
              ),
              const SizedBox(width: 12),
              PrivacyActionButton(
                label: 'DELETE HISTORY',
                onPressed: viewModel.onDeleteHistory,
              ),
            ],
          ),
          trailing: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.05),
                  blurRadius: 40,
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.storage_rounded,
                color: AppColors.secondary,
                size: 48,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
