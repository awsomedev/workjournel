import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/home_viewmodel.dart';

class HomeGreeting extends StatelessWidget {
  final HomeViewModel viewModel;

  const HomeGreeting({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hey ${viewModel.userName} 👋',
          style: AppFonts.plusJakartaSans(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.8,
            color: AppColors.primary,
            height: 40 / 36,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          viewModel.greeting.toUpperCase(),
          style: AppFonts.lexend(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.4,
            color: AppColors.onSurfaceVariant,
            height: 20 / 14,
          ),
        ),
      ],
    );
  }
}
