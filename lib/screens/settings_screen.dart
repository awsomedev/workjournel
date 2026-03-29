import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/model_selection_viewmodel.dart';
import 'package:workjournel/widgets/settings/settings_model_card.dart';
import 'package:workjournel/widgets/settings/settings_top_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _modelViewModel = ModelSelectionViewModel();

  @override
  void initState() {
    super.initState();
    _modelViewModel.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = AppBreakpoints.fromWidth(constraints.maxWidth);
        final horizontalPadding = switch (size) {
          ResponsiveSize.sm => 24.0,
          ResponsiveSize.md => 32.0,
          ResponsiveSize.lg => 48.0,
        };
        final maxWidth = switch (size) {
          ResponsiveSize.sm => double.infinity,
          ResponsiveSize.md => 760.0,
          ResponsiveSize.lg => 880.0,
        };
        final bottomInset = MediaQuery.of(context).padding.bottom;
        final bottomPadding = size == ResponsiveSize.sm
            ? bottomInset + 120
            : bottomInset + 40;

        return Scaffold(
          backgroundColor: AppColors.surfaceContainerLowest,
          body: Column(
            children: [
              SettingsTopBar(showSafeAreaTop: size == ResponsiveSize.sm),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    20,
                    horizontalPadding,
                    bottomPadding,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedBuilder(
                            animation: _modelViewModel,
                            builder: (context, _) {
                              return SettingsModelCard(
                                activeModel: _modelViewModel.activeModel,
                                isClaudeSelected: _modelViewModel.isClaudeSelected,
                                claudeVersion: _modelViewModel.claudeVersion,
                                onOpenModelSelection: () async {
                                  await context.push('/settings/models');
                                  await _modelViewModel.refreshStates();
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
