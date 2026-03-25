class ChatMessage {
  final String id;
  final String text;
  final String time;
  final bool isUser;
  final String? codeBlock;

  const ChatMessage({
    required this.id,
    required this.text,
    required this.time,
    required this.isUser,
    this.codeBlock,
  });
}
