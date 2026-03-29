import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/model_selection_viewmodel.dart';
import 'package:workjournel/widgets/home/home_bottom_nav_bar.dart';
import 'package:workjournel/widgets/home/home_sidebar.dart';

class MainShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  final _modelSelectionViewModel = ModelSelectionViewModel();

  @override
  void initState() {
    super.initState();
    _modelSelectionViewModel.applyStartupSelection();
  }

  int get _supportedBranchCount => 3;

  void _onNavTap(int index) {
    if (index >= _supportedBranchCount) {
      return;
    }
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
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
          Positioned.fill(child: widget.navigationShell),
          Positioned(
            left: 19.5,
            right: 19.5,
            bottom: 24,
            child: HomeBottomNavBar(
              activeIndex: widget.navigationShell.currentIndex,
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
            activeIndex: widget.navigationShell.currentIndex,
            onTap: _onNavTap,
          ),
          Expanded(child: widget.navigationShell),
        ],
      ),
    );
  }
}
