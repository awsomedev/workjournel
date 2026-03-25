import 'package:flutter/material.dart';
import 'package:workjournel/models/chat_message.dart';
import 'package:workjournel/theme/app_theme.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final ResponsiveSize size;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleMaxWidth = switch (size) {
      ResponsiveSize.sm => 320.0,
      ResponsiveSize.md => 620.0,
      ResponsiveSize.lg => 720.0,
    };

    final alignment = message.isUser
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final bubbleColor = message.isUser
        ? AppColors.primary.withValues(alpha: 0.14)
        : AppColors.surfaceContainerLow;
    final borderColor = message.isUser
        ? AppColors.primary.withValues(alpha: 0.5)
        : AppColors.outlineVariant.withValues(alpha: 0.35);

    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: bubbleMaxWidth),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.text,
                style: AppFonts.lexend(
                  fontSize: 14,
                  color: Colors.white,
                  height: 1.5,
                ),
              ),
              if (message.codeBlock != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    message.codeBlock!,
                    style: AppFonts.lexend(
                      fontSize: 12,
                      color: AppColors.primary,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                message.time,
                style: AppFonts.lexend(
                  fontSize: 11,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
