import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';

class ChatTopBar extends StatelessWidget {
  final bool showSafeAreaTop;

  const ChatTopBar({super.key, required this.showSafeAreaTop});

  @override
  Widget build(BuildContext context) {
    final bar = Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            'Chat',
            style: AppFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );

    if (!showSafeAreaTop) {
      return bar;
    }

    return SafeArea(bottom: false, child: bar);
  }
}
