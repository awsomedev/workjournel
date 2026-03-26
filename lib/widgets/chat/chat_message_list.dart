import 'package:flutter/material.dart';
import 'package:workjournel/models/agent_status.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/chat_viewmodel.dart';
import 'package:workjournel/widgets/chat/agent_status_bubble.dart';
import 'package:workjournel/widgets/chat/chat_message_bubble.dart';

class ChatMessageList extends StatelessWidget {
  final ChatViewModel viewModel;
  final ResponsiveSize size;
  final ScrollController scrollController;
  final EdgeInsets padding;
  final AgentStatus agentStatus;

  const ChatMessageList({
    super.key,
    required this.viewModel,
    required this.size,
    required this.scrollController,
    required this.padding,
    required this.agentStatus,
  });

  @override
  Widget build(BuildContext context) {
    final showStatusIndicator = agentStatus != AgentStatus.idle;
    final totalItems = viewModel.messages.length + (showStatusIndicator ? 1 : 0);
    return ListView.separated(
      controller: scrollController,
      padding: padding,
      itemCount: totalItems,
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final isStatusItem = showStatusIndicator && index == totalItems - 1;
        if (isStatusItem) {
          return AgentStatusBubble(status: agentStatus, size: size);
        }
        final message = viewModel.messages[index];
        return ChatMessageBubble(message: message, size: size);
      },
    );
  }
}
