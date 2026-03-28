import 'package:flutter/foundation.dart';
import 'package:workjournel/models/agent_status.dart';
import 'package:workjournel/models/chat_message.dart';
import 'package:workjournel/models/journal_entry_record.dart';
import 'package:workjournel/models/local_llm_model.dart';
import 'package:workjournel/services/journal_storage_service.dart';
import 'package:workjournel/services/local_llm_chat_service.dart';

class ChatViewModel extends ChangeNotifier {
  final List<ChatMessage> messages = [];
  final LocalLlmChatService _chatService = LocalLlmChatService();

  int _counter = 0;
  bool _isSending = false;
  AgentStatus _agentStatus = AgentStatus.idle;

  bool get hasMessages => messages.isNotEmpty;
  bool get isSending => _isSending;
  AgentStatus get agentStatus => _agentStatus;

  Future<void> sendMessage(
    String rawText, {
    required LocalLlmModel model,
  }) async {
    final text = rawText.trim();
    if (text.isEmpty) return;

    _counter += 1;
    messages.add(
      ChatMessage(id: 'user-$_counter', text: text, time: 'Now', isUser: true),
    );
    notifyListeners();
    _isSending = true;
    _setStatus(AgentStatus.thinking);
    try {
      final payload = await _chatService.generateChatTurn(
        message: text,
        modelId: model.id,
        modelType: model.modelType,
      );
      if (payload.shouldSave) {
        if (_hasRelativeDateReference(text)) {
          _setStatus(AgentStatus.resolvingDate);
        }
        _setStatus(AgentStatus.savingMemory);
        if (payload.title.isNotEmpty &&
            payload.subtitle.isNotEmpty &&
            payload.body.isNotEmpty &&
            payload.tags.isNotEmpty) {
          await _saveEntry(payload);
        }
      }
      _addAssistantMessage(payload.reply);
    } catch (_) {
      _addAssistantMessage('Could not generate a response. Please try again.');
    } finally {
      _isSending = false;
      _setStatus(AgentStatus.idle);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _chatService.dispose();
    super.dispose();
  }

  Future<void> _saveEntry(ChatTurnPayload payload) async {
    final targetDate = _resolveEntryDate(payload.date);
    final record = JournalEntryRecord(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: payload.title,
      subtitle: payload.subtitle,
      body: payload.body,
      tags: payload.tags,
      createdAtMillis: targetDate.millisecondsSinceEpoch,
    );
    await JournalStorageService.saveEntry(record);
  }

  void _addAssistantMessage(String text) {
    _counter += 1;
    messages.add(
      ChatMessage(
        id: 'assistant-$_counter',
        text: text,
        time: 'Now',
        isUser: false,
      ),
    );
    notifyListeners();
  }

  void _setStatus(AgentStatus status) {
    if (_agentStatus == status) {
      return;
    }
    _agentStatus = status;
    notifyListeners();
  }

  DateTime _resolveEntryDate(String isoDate) {
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(isoDate);
    if (match == null) {
      return DateTime.now();
    }
    final year = int.tryParse(match.group(1)!);
    final month = int.tryParse(match.group(2)!);
    final day = int.tryParse(match.group(3)!);
    if (year == null || month == null || day == null) {
      return DateTime.now();
    }
    return DateTime(year, month, day);
  }

  bool _hasRelativeDateReference(String text) {
    final lower = text.toLowerCase();
    return lower.contains('yesterday') ||
        lower.contains('day before yesterday') ||
        lower.contains('last ') ||
        lower.contains('this monday') ||
        lower.contains('this tuesday') ||
        lower.contains('this wednesday') ||
        lower.contains('this thursday') ||
        lower.contains('this friday') ||
        lower.contains('this saturday') ||
        lower.contains('this sunday');
  }
}
