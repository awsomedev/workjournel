import 'package:flutter/material.dart';
import 'package:workjournel/models/local_llm_model.dart';
import 'package:workjournel/theme/app_theme.dart';

class SettingsModelCard extends StatelessWidget {
  final LocalLlmModel? activeModel;
  final VoidCallback onOpenModelSelection;

  const SettingsModelCard({
    super.key,
    required this.activeModel,
    required this.onOpenModelSelection,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Local Model',
            style: AppFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            activeModel?.name ?? 'No model selected',
            style: AppFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: activeModel == null ? Colors.white : AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            activeModel == null
                ? 'Choose a model to enable local chat responses.'
                : '${activeModel!.summary} • ${activeModel!.sizeLabel}',
            style: AppFonts.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 44,
            child: ElevatedButton(
              onPressed: onOpenModelSelection,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: Text(
                'Select Model',
                style: AppFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
