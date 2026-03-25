import 'package:flutter/material.dart';
import 'package:workjournel/models/local_llm_model.dart';
import 'package:workjournel/theme/app_theme.dart';

class ModelCard extends StatelessWidget {
  final LocalLlmModel model;
  final bool isSelected;
  final bool isBusy;
  final VoidCallback onDownload;
  final VoidCallback onSelect;

  const ModelCard({
    super.key,
    required this.model,
    required this.isSelected,
    required this.isBusy,
    required this.onDownload,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name,
                      style: AppFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${model.family} · ${model.sizeLabel}',
                      style: AppFonts.lexend(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            model.summary,
            style: AppFonts.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          if (model.status == ModelInstallStatus.downloading) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: model.progress / 100,
                minHeight: 8,
                backgroundColor: AppColors.surfaceContainerHigh,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Downloading ${model.progress}%',
              style: AppFonts.lexend(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: ElevatedButton(
                    onPressed: _buttonEnabled()
                        ? (model.isInstalled ? onSelect : onDownload)
                        : null,
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
              ),
              if (model.status == ModelInstallStatus.unavailable) ...[
                const SizedBox(width: 10),
                const _StatusChip(label: 'Unsupported'),
              ] else if (model.status == ModelInstallStatus.failed) ...[
                const SizedBox(width: 10),
                const _StatusChip(label: 'Retry'),
              ],
            ],
          ),
        ],
      ),
    );
  }

  bool _buttonEnabled() {
    if (isBusy) {
      return false;
    }
    if (model.status == ModelInstallStatus.unavailable ||
        model.status == ModelInstallStatus.downloading) {
      return false;
    }
    if (model.isInstalled && isSelected) {
      return false;
    }
    return true;
  }

  String _buttonLabel() {
    if (model.status == ModelInstallStatus.downloading) {
      return 'Downloading...';
    }
    if (model.status == ModelInstallStatus.unavailable) {
      return 'Unsupported';
    }
    if (model.isInstalled) {
      return isSelected ? 'Selected' : 'Select';
    }
    if (model.status == ModelInstallStatus.failed) {
      return 'Retry Download';
    }
    return 'Download';
  }

  Color _buttonBackground() {
    if (model.status == ModelInstallStatus.unavailable ||
        model.status == ModelInstallStatus.downloading) {
      return AppColors.surfaceContainerHigh;
    }
    if (model.isInstalled) {
      return isSelected ? AppColors.surfaceContainerHigh : AppColors.primary;
    }
    return AppColors.primary;
  }

  Color _buttonForeground() {
    if (model.status == ModelInstallStatus.unavailable ||
        model.status == ModelInstallStatus.downloading) {
      return AppColors.onSurfaceVariant;
    }
    if (model.isInstalled && isSelected) {
      return AppColors.onSurfaceVariant;
    }
    return Colors.black;
  }
}

class _StatusChip extends StatelessWidget {
  final String label;

  const _StatusChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        label,
        style: AppFonts.lexend(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurfaceVariant,
        ),
      ),
    );
  }
}
