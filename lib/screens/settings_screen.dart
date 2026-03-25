import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/model_selection_viewmodel.dart';
import 'package:workjournel/viewmodels/settings_viewmodel.dart';
import 'package:workjournel/widgets/settings/settings_model_card.dart';
import 'package:workjournel/widgets/settings/settings_option_tile.dart';
import 'package:workjournel/widgets/settings/settings_top_bar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _settingsViewModel = SettingsViewModel();
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
                                onOpenModelSelection: () async {
                                  await context.push('/settings/models');
                                  await _modelViewModel.refreshStates();
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Runtime',
                            style: AppFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SettingsOptionTile(
                            title: 'Prefer GPU backend',
                            subtitle:
                                'Use GPU acceleration for faster local generation when available.',
                            value: _settingsViewModel.preferGpu,
                            onChanged: (value) {
                              setState(() {
                                _settingsViewModel.setPreferGpu(value);
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          SettingsOptionTile(
                            title: 'Local-only mode',
                            subtitle:
                                'Keep prompts and responses on-device without remote processing.',
                            value: _settingsViewModel.localOnlyMode,
                            onChanged: (value) {
                              setState(() {
                                _settingsViewModel.setLocalOnlyMode(value);
                              });
                            },
                          ),
                          const SizedBox(height: 12),
                          SettingsOptionTile(
                            title: 'Auto-download models on Wi-Fi',
                            subtitle:
                                'Enable scheduled downloads when new on-device models become available.',
                            value: _settingsViewModel.autoDownloadOnWifi,
                            onChanged: (value) {
                              setState(() {
                                _settingsViewModel.setAutoDownloadOnWifi(value);
                              });
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
