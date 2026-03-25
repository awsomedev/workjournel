import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/home_viewmodel.dart';

class HomeWeeklyStatsCard extends StatelessWidget {
  final HomeViewModel viewModel;

  const HomeWeeklyStatsCard({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(
          height: 188,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer.withValues(alpha: 0.6),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.1),
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.05),
                blurRadius: 24,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'WEEKLY STATS',
                    style: AppFonts.lexend(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.2,
                      color: AppColors.onSurfaceVariant,
                      height: 16 / 12,
                    ),
                  ),
                  Icon(
                    Icons.bar_chart_rounded,
                    color: AppColors.primary,
                    size: 13.33,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _StatItem(
                      value: viewModel.entriesLogged.toString(),
                      label: 'Entries\nLogged',
                      valueColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatItem(
                      value: viewModel.accomplishments.toString(),
                      label: 'Accomplish-\nments',
                      valueColor: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatItem(
                      value: viewModel.activeProjects.toString(),
                      label: 'Active\nProjects',
                      valueColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _ProgressBar(progress: viewModel.weeklyProgress),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _StatItem({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppFonts.plusJakartaSans(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: valueColor,
            height: 36 / 30,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label.toUpperCase(),
          style: AppFonts.lexend(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
            color: AppColors.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final double progress;

  const _ProgressBar({required this.progress});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
            Container(
              height: 4,
              width: constraints.maxWidth * progress,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(9999),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
