import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/welcome_viewmodel.dart';
import 'package:workjournel/widgets/welcome/desktop_cta_section.dart';
import 'package:workjournel/widgets/welcome/desktop_footer.dart';
import 'package:workjournel/widgets/welcome/hero_bento.dart';
import 'package:workjournel/widgets/welcome/supporting_benefits.dart';
import 'package:workjournel/widgets/welcome/top_nav_bar.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final WelcomeViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = WelcomeViewModel();
    _viewModel.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = AppBreakpoints.fromWidth(constraints.maxWidth);
          if (size == ResponsiveSize.sm) {
            return _WelcomeSmall(viewModel: _viewModel);
          }
          if (size == ResponsiveSize.md) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: AppBreakpoints.desktopMinWidth,
                ),
                child: _WelcomeMedium(viewModel: _viewModel),
              ),
            );
          }
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: AppBreakpoints.desktopMinWidth,
              ),
              child: _WelcomeLarge(viewModel: _viewModel),
            ),
          );
        },
      ),
    );
  }
}

class _WelcomeSmall extends StatelessWidget {
  final WelcomeViewModel viewModel;
  const _WelcomeSmall({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              const TopNavBar(size: ResponsiveSize.sm),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: HeroBento(size: ResponsiveSize.sm),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Never forget what\nyou ',
                            style: AppTextStyles.h1.copyWith(fontSize: 36),
                          ),
                          TextSpan(
                            text: 'accomplished',
                            style: AppTextStyles.h1.copyWith(
                              fontSize: 36,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const SupportingBenefits(size: ResponsiveSize.sm),
                  ],
                ),
              ),
              const SizedBox(height: 120), // Space for sticky button
              const DesktopFooter(),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.surfaceContainerLowest.withValues(alpha: 0),
                  AppColors.surfaceContainerLowest,
                ],
              ),
            ),
            child: ElevatedButton(
              onPressed: () => viewModel.onGetStarted(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 64),
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
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WelcomeMedium extends StatelessWidget {
  final WelcomeViewModel viewModel;
  const _WelcomeMedium({required this.viewModel});

  static const double _heroHeight = 420;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopNavBar(size: ResponsiveSize.md),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 980),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: _heroHeight,
                        width: double.infinity,
                        child: HeroBento(size: ResponsiveSize.md),
                      ),
                      const SizedBox(height: 20),
                      const SupportingBenefits(size: ResponsiveSize.md),
                      const SizedBox(height: 20),
                      DesktopCTASection(
                        viewModel: viewModel,
                        size: ResponsiveSize.md,
                      ),
                      const SizedBox(height: 24),
                      const DesktopFooter(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WelcomeLarge extends StatelessWidget {
  final WelcomeViewModel viewModel;
  const _WelcomeLarge({required this.viewModel});

  static const double _heroHeight = 600;
  static const double _rightColumnWidth = 400;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopNavBar(size: ResponsiveSize.lg),
        Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1440),
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 24,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: _heroHeight,
                          child: const HeroBento(size: ResponsiveSize.lg),
                        ),
                      ),
                      const SizedBox(width: 24),
                      SizedBox(
                        width: _rightColumnWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SupportingBenefits(size: ResponsiveSize.lg),
                            const SizedBox(height: 24),
                            DesktopCTASection(
                              viewModel: viewModel,
                              size: ResponsiveSize.lg,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const DesktopFooter(),
      ],
    );
  }
}
