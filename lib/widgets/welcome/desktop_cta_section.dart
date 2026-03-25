import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/welcome_viewmodel.dart';

class DesktopCTASection extends StatelessWidget {
  final WelcomeViewModel viewModel;
  final ResponsiveSize size;
  const DesktopCTASection({
    super.key,
    required this.viewModel,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMedium = size == ResponsiveSize.md;
    return Container(
      padding: EdgeInsets.all(isMedium ? 28 : 40),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(isMedium ? 24 : 32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Log Daily with ai', style: AppTextStyles.bodySm),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => viewModel.onGetStarted(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity, isMedium ? 64 : 72),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9999),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Get Started',
                  style: AppFonts.plusJakartaSans(
                    fontSize: isMedium ? 18 : 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'No credit card required. Free for personal use.',
              style: AppTextStyles.bodySm,
            ),
          ),
        ],
      ),
    );
  }
}
