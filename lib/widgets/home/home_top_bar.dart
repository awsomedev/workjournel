import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/home_viewmodel.dart';

class HomeTopBar extends StatelessWidget {
  final HomeViewModel viewModel;
  final bool isDesktop;

  const HomeTopBar({
    super.key,
    required this.viewModel,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48 : 24,
        vertical: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!isDesktop) ...[
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.2),
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: AppColors.onSurfaceVariant,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Welcome Back',
                  style: AppFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.6,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ] else ...[
            Text(
              'Welcome Back, ${viewModel.userName}',
              style: AppFonts.plusJakartaSans(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.6,
                color: AppColors.primary,
              ),
            ),
          ],
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: const Icon(
              Icons.notifications_outlined,
              color: AppColors.primary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
