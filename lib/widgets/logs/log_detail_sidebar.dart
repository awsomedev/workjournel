import 'package:flutter/material.dart';
import 'package:workjournel/models/log_entry.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/widgets/logs/log_detail_content.dart';

class LogDetailSidebar extends StatelessWidget {
  final LogEntry? log;
  final VoidCallback onClose;

  const LogDetailSidebar({super.key, required this.log, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        border: Border(
          left: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(-8, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 0, 16, 0),
            height: 64,
            child: Row(
              children: [
                Text(
                  'Log Detail',
                  style: AppFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded, size: 20),
                  color: AppColors.onSurfaceVariant,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
          if (log != null) Expanded(child: LogDetailContent(log: log!)),
        ],
      ),
    );
  }
}
