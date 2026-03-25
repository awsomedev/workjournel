import 'package:flutter/material.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/chat_viewmodel.dart';
import 'package:workjournel/widgets/chat/chat_message_bubble.dart';

class ChatMessageList extends StatelessWidget {
  final ChatViewModel viewModel;
  final ResponsiveSize size;
  final ScrollController scrollController;
  final EdgeInsets padding;

  const ChatMessageList({
    super.key,
    required this.viewModel,
    required this.size,
    required this.scrollController,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      padding: padding,
      itemCount: viewModel.messages.length,
      separatorBuilder: (_, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final message = viewModel.messages[index];
        return ChatMessageBubble(message: message, size: size);
      },
    );
  }
}
