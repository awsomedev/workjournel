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
            title: 'On-Device Models',
            description:
                'Run local models (Gemma, Qwen, DeepSeek) entirely on your device. No data leaves your machine.',
          ),
          const SizedBox(height: 24),
          const PrivacyMobileCard(
            icon: Icons.cloud_outlined,
            iconColor: AppColors.primary,
            title: 'Claude Code CLI',
            description:
                'When selected, prompts are sent to Anthropic\'s API via Claude Code for higher-quality responses.*',
          ),
          const SizedBox(height: 24),
          const PrivacyMobileCard(
            icon: Icons.folder_shared_outlined,
            iconColor: AppColors.secondary,
            title: 'You Own Your Logs',
            description:
                'Export or delete your entire history at any time. Your data is stored locally and never shared.',
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '* When using Claude Code, your prompts are processed by Anthropic under their privacy policy. Anthropic does not train on API inputs. Local models keep all data on-device.',
              style: AppTextStyles.bodyMd.copyWith(
                fontSize: 12,
                height: 1.5,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
              ),
            ),
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
                title: 'On-Device Models',
                description:
                    'Run Gemma, Qwen, or DeepSeek entirely on your device. Your prompts and responses never leave your machine — zero network calls, full privacy.',
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
                        '100% ON-DEVICE',
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
            Expanded(
              flex: 4,
              child: PrivacyDesktopCard(
                minHeight: 440,
                icon: Icons.cloud_outlined,
                iconColor: AppColors.secondary,
                title: 'Claude Code CLI',
                description:
                    'Opt into Claude Code for higher-quality responses. Processed via Anthropic\'s API.*',
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
              'Export your entire history in open formats or wipe everything with a single tap. Your journal data is stored locally and never shared with us or any third party.',
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
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            '* When using Claude Code, your prompts are processed by Anthropic under their privacy policy. Anthropic does not train on API inputs. Local models keep all data entirely on-device.',
            style: AppTextStyles.bodyMd.copyWith(
              fontSize: 13,
              height: 1.5,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }
}
