import 'package:flutter/material.dart';
import 'package:workjournel/models/log_entry.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/widgets/logs/log_detail_content.dart';

class LogDetailBottomSheet extends StatelessWidget {
  final LogEntry log;

  const LogDetailBottomSheet({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.72,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                child: LogDetailContent(
                  log: log,
                  scrollController: scrollController,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }
}
