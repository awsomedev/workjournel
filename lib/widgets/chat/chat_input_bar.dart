import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final ResponsiveSize size;
  final bool isEnabled;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    required this.size,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = switch (size) {
      ResponsiveSize.sm => 16.0,
      ResponsiveSize.md => 24.0,
      ResponsiveSize.lg => 32.0,
    };

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          12,
          horizontalPadding,
          size == ResponsiveSize.sm ? 12 : 20,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow.withValues(alpha: 0.88),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      minLines: 1,
                      maxLines: 4,
                      readOnly: !isEnabled,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) {
                        if (isEnabled) {
                          onSend();
                        }
                      },
                      style: AppFonts.lexend(
                        fontSize: 14,
                        color: Colors.white,
                        height: 1.5,
                      ),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        border: InputBorder.none,
                        hintText: isEnabled
                            ? 'Ask anything about your work logs...'
                            : 'Select a model to start chatting...',
                        hintStyle: AppFonts.lexend(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: isEnabled ? onSend : null,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isEnabled
                            ? AppColors.primary
                            : AppColors.surfaceContainerHigh,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_upward_rounded,
                        size: 18,
                        color: isEnabled
                            ? Colors.black
                            : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
