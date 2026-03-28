import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workjournel/models/log_entry.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/logs_viewmodel.dart';
import 'package:workjournel/widgets/logs/logs_top_bar.dart';
import 'package:workjournel/widgets/logs/logs_list.dart';
import 'package:workjournel/widgets/logs/log_detail_bottom_sheet.dart';
import 'package:workjournel/widgets/logs/log_detail_sidebar.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  final _viewModel = LogsViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.initialize();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _onLogTapped(LogEntry log, ResponsiveSize size) {
    if (size == ResponsiveSize.sm) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useRootNavigator: true,
        backgroundColor: Colors.transparent,
        builder: (_) =>
            LogDetailBottomSheet(log: log, onDelete: _viewModel.deleteLog),
      );
    } else {
      _viewModel.selectLog(log);
    }
  }

  void _clearSelection() {
    _viewModel.clearSelection();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _viewModel,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final size = AppBreakpoints.fromWidth(constraints.maxWidth);
            if (size == ResponsiveSize.sm) {
              return _buildMobile(size);
            }
            return _buildDesktop(size);
          },
        );
      },
    );
  }

  Widget _buildMobile(ResponsiveSize size) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    final listBottomPadding = bottomInset + 109;
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: LogsTopBar(onBragTap: () => context.push('/logs/brag')),
          ),
          Expanded(
            child: LogsList(
              viewModel: _viewModel,
              onTap: (log) => _onLogTapped(log, size),
              padding: EdgeInsets.fromLTRB(24, 24, 24, listBottomPadding),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktop(ResponsiveSize size) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: Stack(
        children: [
          Column(
            children: [
              LogsTopBar(onBragTap: () => context.push('/logs/brag')),
              Expanded(
                child: LogsList(
                  viewModel: _viewModel,
                  onTap: (log) => _onLogTapped(log, size),
                  padding: const EdgeInsets.all(32),
                ),
              ),
            ],
          ),
          IgnorePointer(
            ignoring: !_viewModel.hasSelection,
            child: AnimatedOpacity(
              opacity: _viewModel.hasSelection ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 250),
              child: GestureDetector(
                onTap: _clearSelection,
                child: Container(color: Colors.black.withValues(alpha: 0.45)),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: AnimatedSlide(
                offset: _viewModel.hasSelection
                    ? Offset.zero
                    : const Offset(1, 0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                child: LogDetailSidebar(
                  log: _viewModel.selectedLog,
                  onClose: _clearSelection,
                  onDelete: _viewModel.deleteLog,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
