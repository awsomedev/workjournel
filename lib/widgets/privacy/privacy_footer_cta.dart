import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/privacy_viewmodel.dart';

class PrivacyFooterCta extends StatelessWidget {
  final PrivacyViewModel viewModel;
  const PrivacyFooterCta({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'READY TO JOURNAL SECURELY?',
          style: AppTextStyles.labelMd.copyWith(
            color: AppColors.onSurfaceVariant,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w800,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 40),
        InkWell(
          onTap: viewModel.onContinue,
          borderRadius: BorderRadius.circular(40),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 24),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  blurRadius: 32,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Continue to App',
                  style: AppTextStyles.h2.copyWith(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.black,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'By continuing, you agree to our Privacy Policy.',
          style: AppTextStyles.bodyMd.copyWith(
            fontSize: 14,
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
