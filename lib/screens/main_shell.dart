import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/widgets/home/home_bottom_nav_bar.dart';
import 'package:workjournel/widgets/home/home_sidebar.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  int get _supportedBranchCount => 4;

  void _onNavTap(int index) {
    if (index >= _supportedBranchCount) {
      return;
    }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = AppBreakpoints.fromWidth(constraints.maxWidth);
        if (size == ResponsiveSize.sm) {
          return _buildMobile();
        }
        return _buildDesktop();
      },
    );
  }

  Widget _buildMobile() {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: Stack(
        children: [
          Positioned.fill(child: navigationShell),
          Positioned(
            left: 19.5,
            right: 19.5,
            bottom: 24,
            child: HomeBottomNavBar(
              activeIndex: navigationShell.currentIndex,
              onTap: _onNavTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktop() {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: Row(
        children: [
          HomeSidebar(
            activeIndex: navigationShell.currentIndex,
            onTap: _onNavTap,
          ),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
