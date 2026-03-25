import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/home_viewmodel.dart';

class HomeStreakCard extends StatelessWidget {
  final HomeViewModel viewModel;

  const HomeStreakCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.1),
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 24)),
              Text(
                'STREAK',
                style: AppFonts.lexend(
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.0,
                  color: AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.streakDays.toString(),
                style: AppFonts.plusJakartaSans(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.9,
                  color: Colors.white,
                  height: 40 / 36,
                ),
              ),
              Text(
                'Days Active',
                style: AppFonts.lexend(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  height: 16 / 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
