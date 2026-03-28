import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';

class BragDocTimeframePicker extends StatelessWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final ValueChanged<DateTime> onFromDateChanged;
  final ValueChanged<DateTime> onToDateChanged;

  const BragDocTimeframePicker({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.onFromDateChanged,
    required this.onToDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DateFieldButton(
            label: 'From',
            value: _formatDate(fromDate),
            onTap: () => _pickDate(
              context: context,
              initial: fromDate,
              onSelected: onFromDateChanged,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DateFieldButton(
            label: 'To',
            value: _formatDate(toDate),
            onTap: () => _pickDate(
              context: context,
              initial: toDate,
              onSelected: onToDateChanged,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate({
    required BuildContext context,
    required DateTime initial,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDate: initial,
    );
    if (picked == null) {
      return;
    }
    onSelected(DateTime(picked.year, picked.month, picked.day));
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}

class _DateFieldButton extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;

  const _DateFieldButton({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          children: [
            Text(
              '$label: ',
              style: AppFonts.lexend(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            Expanded(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: AppFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.calendar_today_rounded,
              size: 16,
              color: AppColors.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
