import 'package:flutter/material.dart';
import 'package:workjournel/models/log_entry.dart';
import 'package:workjournel/viewmodels/logs_viewmodel.dart';
import 'package:workjournel/widgets/logs/log_list_item.dart';

class LogsList extends StatelessWidget {
  final LogsViewModel viewModel;
  final ValueChanged<LogEntry> onTap;
  final EdgeInsets padding;

  const LogsList({
    super.key,
    required this.viewModel,
    required this.onTap,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: padding,
      itemCount: viewModel.logs.length,
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final log = viewModel.logs[index];
        return LogListItem(
          log: log,
          isSelected: viewModel.selectedLog?.id == log.id,
          onTap: () => onTap(log),
        );
      },
    );
  }
}
