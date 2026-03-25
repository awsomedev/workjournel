import 'package:workjournel/models/chat_message.dart';

class ChatViewModel {
  final List<ChatMessage> messages = [];

  int _counter = 0;

  bool get hasMessages => messages.isNotEmpty;

  void sendMessage(String rawText) {
    final text = rawText.trim();
    if (text.isEmpty) {
      return;
    }

    _counter += 1;
    messages.add(
      ChatMessage(id: 'user-$_counter', text: text, time: 'Now', isUser: true),
    );

    _counter += 1;
    messages.add(
      ChatMessage(
        id: 'assistant-$_counter',
        text:
            'Got it. I captured that request and can help you turn it into a clean daily update, action items, or a concise summary.',
        time: 'Now',
        isUser: false,
      ),
    );
  }
}
