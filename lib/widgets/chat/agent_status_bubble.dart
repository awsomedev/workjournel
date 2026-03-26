import 'package:flutter/material.dart';
import 'package:workjournel/models/agent_status.dart';
import 'package:workjournel/theme/app_theme.dart';

class AgentStatusBubble extends StatefulWidget {
  final AgentStatus status;
  final ResponsiveSize size;

  const AgentStatusBubble({
    super.key,
    required this.status,
    required this.size,
  });

  @override
  State<AgentStatusBubble> createState() => _AgentStatusBubbleState();
}

class _AgentStatusBubbleState extends State<AgentStatusBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bubbleMaxWidth = switch (widget.size) {
      ResponsiveSize.sm => 320.0,
      ResponsiveSize.md => 620.0,
      ResponsiveSize.lg => 720.0,
    };
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: bubbleMaxWidth),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final alpha = 0.4 + (0.6 * _controller.value);
                  return Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: alpha),
                    ),
                  );
                },
              ),
              const SizedBox(width: 10),
              Text(
                widget.status.label,
                style: AppFonts.lexend(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
