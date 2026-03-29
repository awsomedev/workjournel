import 'package:flutter/material.dart';
import 'package:workjournel/models/local_llm_model.dart';
import 'package:workjournel/theme/app_theme.dart';

class ChatEmptyState extends StatelessWidget {
  final bool hasSelectedModel;
  final bool isLoading;
  final String? selectedModelId;
  final List<LocalLlmModel> models;
  final ValueChanged<String?> onModelChanged;
  final VoidCallback onOpenModelSelection;

  const ChatEmptyState({
    super.key,
    required this.hasSelectedModel,
    this.isLoading = false,
    required this.selectedModelId,
    required this.models,
    required this.onModelChanged,
    required this.onOpenModelSelection,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Setting up...',
              style: AppFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            hasSelectedModel ? 'Start a conversation' : 'Select a chat model',
            style: AppFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasSelectedModel
                ? 'Ask the assistant to summarize logs or draft updates.'
                : 'We suggest Qwen 0.6B for speed and accuracy.',
            style: AppFonts.lexend(
              fontSize: 14,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          if (!hasSelectedModel) ...[
            const SizedBox(height: 18),
            SizedBox(
              width: 320,
              child: DropdownButtonFormField<String>(
                initialValue: selectedModelId,
                dropdownColor: AppColors.surfaceContainerHigh,
                style: AppFonts.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surfaceContainer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.outlineVariant.withValues(alpha: 0.35),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.outlineVariant.withValues(alpha: 0.35),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
                hint: Text(
                  'Choose model (size)',
                  style: AppFonts.lexend(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                items: models
                    .where((model) => model.isInstalled)
                    .map(
                      (model) => DropdownMenuItem<String>(
                        value: model.id,
                        child: Text('${model.name} (${model.sizeLabel})'),
                      ),
                    )
                    .toList(growable: false),
                onChanged: onModelChanged,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 320,
              height: 42,
              child: ElevatedButton(
                onPressed: onOpenModelSelection,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Download model',
                  style: AppFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
