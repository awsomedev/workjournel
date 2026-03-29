import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/model_selection_viewmodel.dart';
import 'package:workjournel/widgets/models/claude_code_card.dart';
import 'package:workjournel/widgets/models/model_card.dart';
import 'package:workjournel/widgets/models/model_selection_top_bar.dart';

class ModelSelectionScreen extends StatefulWidget {
  const ModelSelectionScreen({super.key});

  @override
  State<ModelSelectionScreen> createState() => _ModelSelectionScreenState();
}

class _ModelSelectionScreenState extends State<ModelSelectionScreen> {
  final _viewModel = ModelSelectionViewModel();
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _viewModel.initialize();
  }

  Future<void> _downloadModel(String modelId) async {
    setState(() {
      _isBusy = true;
    });
    try {
      await _viewModel.downloadModel(modelId);
      if (!mounted) {
        return;
      }
      final selected = _viewModel.activeModel;
      if (selected != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${selected.name} downloaded and selected.',
              style: AppFonts.lexend(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Model download failed. Please retry.',
            style: AppFonts.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  Future<void> _selectInstalledModel(String modelId) async {
    setState(() {
      _isBusy = true;
    });
    try {
      await _viewModel.selectModel(modelId);
      if (!mounted) {
        return;
      }
      final selected = _viewModel.activeModel;
      if (selected != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${selected.name} selected.',
              style: AppFonts.lexend(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not select this model right now.',
            style: AppFonts.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
  }

  Future<void> _cancelDownload(String modelId) async {
    await _viewModel.cancelDownload(modelId);
    if (!mounted) {
      return;
    }
    setState(() {
      _isBusy = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Download cancelled.',
          style: AppFonts.lexend(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.surfaceContainerHigh,
      ),
    );
  }

  Future<void> _selectClaudeCode() async {
    setState(() {
      _isBusy = true;
    });
    try {
      await _viewModel.selectClaudeCode();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Claude Code selected.',
            style: AppFonts.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          backgroundColor: AppColors.primary,
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _viewModel.claudeStatusMessage,
            style: AppFonts.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isBusy = false;
        });
      }
    }
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
          ResponsiveSize.lg => 920.0,
        };
        final bottomInset = MediaQuery.of(context).padding.bottom;
        final bottomPadding = size == ResponsiveSize.sm
            ? bottomInset + 120
            : bottomInset + 40;

        return Scaffold(
          backgroundColor: AppColors.surfaceContainerLowest,
          body: AnimatedBuilder(
            animation: _viewModel,
            builder: (context, _) {
              return Column(
                children: [
                  ModelSelectionTopBar(
                    showSafeAreaTop: size == ResponsiveSize.sm,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        18,
                        horizontalPadding,
                        bottomPadding,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_viewModel.supportsClaudeOption) ...[
                                ClaudeCodeCard(
                                  isSelected: _viewModel.isClaudeSelected,
                                  isBusy: _isBusy,
                                  isReady: _viewModel.isClaudeReady,
                                  statusMessage: _viewModel.claudeStatusMessage,
                                  onSelect: _selectClaudeCode,
                                ),
                                const SizedBox(height: 14),
                              ],
                              Text(
                                'Installed and downloadable local models',
                                style: AppFonts.lexend(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 14),
                              for (
                                var i = 0;
                                i < _viewModel.models.length;
                                i++
                              ) ...[
                                ModelCard(
                                  model: _viewModel.models[i],
                                  isBusy: _isBusy,
                                  isSelected: _viewModel.isSelected(
                                    _viewModel.models[i].id,
                                  ),
                                  onDownload: () {
                                    _downloadModel(_viewModel.models[i].id);
                                  },
                                  onCancel: () {
                                    _cancelDownload(_viewModel.models[i].id);
                                  },
                                  onSelect: () {
                                    _selectInstalledModel(
                                      _viewModel.models[i].id,
                                    );
                                  },
                                ),
                                if (i < _viewModel.models.length - 1)
                                  const SizedBox(height: 12),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
