import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/home_viewmodel.dart';
import 'package:workjournel/widgets/home/home_current_focus_card.dart';
import 'package:workjournel/widgets/home/home_fab.dart';
import 'package:workjournel/widgets/home/home_greeting.dart';
import 'package:workjournel/widgets/home/home_recent_entries_card.dart';
import 'package:workjournel/widgets/home/home_streak_card.dart';
import 'package:workjournel/widgets/home/home_top_bar.dart';
import 'package:workjournel/widgets/home/home_weekly_stats_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _viewModel = HomeViewModel();

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
      body: Column(
        children: [
          HomeTopBar(viewModel: _viewModel),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeGreeting(viewModel: _viewModel),
                  const SizedBox(height: 32),
                  HomeWeeklyStatsCard(viewModel: _viewModel),
                  const SizedBox(height: 28),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: HomeStreakCard(viewModel: _viewModel)),
                        const SizedBox(width: 16),
                        const Expanded(child: HomeRecentEntriesCard()),
                      ],
                    ),
                  ),
                  const SizedBox(height: 21),
                  HomeCurrentFocusCard(viewModel: _viewModel),
                  const SizedBox(height: 160),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: const Padding(
        padding: EdgeInsets.only(bottom: 88),
        child: HomeFAB(),
      ),
    );
  }

  Widget _buildDesktop() {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: Column(
        children: [
          HomeTopBar(viewModel: _viewModel, isDesktop: true),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(48, 32, 48, 48),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeGreeting(viewModel: _viewModel),
                      const SizedBox(height: 40),
                      HomeWeeklyStatsCard(viewModel: _viewModel),
                      const SizedBox(height: 28),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: HomeStreakCard(viewModel: _viewModel),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(child: HomeRecentEntriesCard()),
                          ],
                        ),
                      ),
                      const SizedBox(height: 21),
                      HomeCurrentFocusCard(viewModel: _viewModel),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
