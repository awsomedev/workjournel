import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/home_viewmodel.dart';

class HomeCurrentFocusCard extends StatelessWidget {
  final HomeViewModel viewModel;

  const HomeCurrentFocusCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0],
          colors: [AppColors.surfaceContainer, AppColors.surfaceContainerHigh],
        ),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.05),
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
              borderRadius: BorderRadius.circular(48),
            ),
            child: const Icon(
              Icons.my_location_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  viewModel.currentFocusTitle,
                  style: AppFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 20 / 14,
                  ),
                ),
                Text(
                  viewModel.currentFocusSubtitle,
                  style: AppFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onSurfaceVariant,
                    height: 16 / 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.more_horiz,
            color: AppColors.onSurfaceVariant,
            size: 16,
          ),
        ],
      ),
    );
  }
}
