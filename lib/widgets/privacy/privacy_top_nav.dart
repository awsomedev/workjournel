import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/privacy_viewmodel.dart';

class PrivacyTopNav extends StatelessWidget {
  final ResponsiveSize size;
  final PrivacyViewModel viewModel;
  const PrivacyTopNav({super.key, required this.size, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    final isMobile = size == ResponsiveSize.sm;
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: isMobile ? 80 : 100,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 24 : 48),
          decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'WorkJournal',
                style: AppTextStyles.displaySm.copyWith(
                  fontSize: 24,
                  letterSpacing: -1.2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (!isMobile)
                InkWell(
                  onTap: viewModel.onContinue,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Continue',
                      style: AppTextStyles.labelMd.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
