import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/privacy_viewmodel.dart';
import 'package:workjournel/widgets/privacy/privacy_hero.dart';
import 'package:workjournel/widgets/privacy/privacy_bento.dart';
import 'package:workjournel/widgets/privacy/privacy_footer_cta.dart';
import 'package:workjournel/widgets/privacy/privacy_top_nav.dart';
import 'package:workjournel/widgets/privacy/privacy_bottom_bar.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  late final PrivacyViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = PrivacyViewModel();
    _viewModel.initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _viewModel.attachContext(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final size = AppBreakpoints.fromWidth(constraints.maxWidth);
          final isMobile = size == ResponsiveSize.sm;

          return Stack(
            children: [
              SingleChildScrollView(
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: isMobile ? 600 : 1200,
                    ),
                    padding:
                        EdgeInsets.symmetric(
                          horizontal: isMobile ? 24 : 48,
                        ).copyWith(
                          top: isMobile ? 120 : 160,
                          bottom: isMobile ? 160 : 120,
                        ),
                    child: Column(
                      crossAxisAlignment: isMobile
                          ? CrossAxisAlignment.center
                          : CrossAxisAlignment.start,
                      children: [
                        PrivacyHero(size: size),
                        SizedBox(height: isMobile ? 64 : 100),
                        PrivacyBento(size: size, viewModel: _viewModel),
                        if (!isMobile) ...[
                          const SizedBox(height: 120),
                          Center(
                            child: PrivacyFooterCta(viewModel: _viewModel),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              PrivacyTopNav(size: size, viewModel: _viewModel),
              if (isMobile)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: PrivacyBottomBar(viewModel: _viewModel),
                ),
            ],
          );
        },
      ),
    );
  }
}
