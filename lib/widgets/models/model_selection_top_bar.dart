import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workjournel/theme/app_theme.dart';

class ModelSelectionTopBar extends StatelessWidget {
  final bool showSafeAreaTop;

  const ModelSelectionTopBar({super.key, required this.showSafeAreaTop});

  @override
  Widget build(BuildContext context) {
    final topPadding = showSafeAreaTop
        ? MediaQuery.of(context).padding.top
        : 0.0;
    return Container(
      height: 88 + topPadding,
      padding: EdgeInsets.fromLTRB(16, topPadding + 20, 24, 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          ),
          const SizedBox(width: 4),
          Text(
            'Model Selection',
            style: AppFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
