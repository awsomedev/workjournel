import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';

class ClaudeCodeCard extends StatelessWidget {
  final bool isSelected;
  final bool isBusy;
  final bool isReady;
  final String statusMessage;
  final VoidCallback onSelect;

  const ClaudeCodeCard({
    super.key,
    required this.isSelected,
    required this.isBusy,
    required this.isReady,
    required this.statusMessage,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? AppColors.primary
        : AppColors.outlineVariant.withValues(alpha: 0.3);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor, width: isSelected ? 1.4 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Claude Code',
            style: AppFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Local CLI',
            style: AppFonts.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Use locally installed Claude Code from Terminal for chat.',
            style: AppFonts.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            statusMessage,
            style: AppFonts.lexend(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: _buttonEnabled() ? onSelect : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _buttonBackground(),
                foregroundColor: _buttonForeground(),
                disabledBackgroundColor: AppColors.surfaceContainerHigh,
                disabledForegroundColor: AppColors.onSurfaceVariant,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                _buttonLabel(),
                style: AppFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _buttonForeground(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _buttonEnabled() {
    if (isBusy) {
      return false;
    }
    if (isSelected) {
      return false;
    }
    return isReady;
  }

  String _buttonLabel() {
    if (isSelected) {
      return 'Selected';
    }
    if (isReady) {
      return 'Select';
    }
    return 'Unavailable';
  }

  Color _buttonBackground() {
    if (isSelected || !isReady) {
      return AppColors.surfaceContainerHigh;
    }
    return AppColors.primary;
  }

  Color _buttonForeground() {
    if (isSelected || !isReady) {
      return AppColors.onSurfaceVariant;
    }
    return Colors.black;
  }
}
