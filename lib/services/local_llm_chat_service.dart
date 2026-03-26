import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_gemma/flutter_gemma.dart';

class ChatTurnPayload {
  final String reply;
  final String action;
  final String date;
  final String logFilter;
  final bool shouldSave;
  final String title;
  final String subtitle;
  final String body;
  final List<String> tags;

  const ChatTurnPayload({
    required this.reply,
    required this.action,
    required this.date,
    required this.logFilter,
    required this.shouldSave,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.tags,
  });
}

class LocalLlmChatService {
  InferenceModel? _model;
  InferenceChat? _chat;
  String? _chatModelId;
  ModelType? _chatModelType;

  Future<ChatTurnPayload> generateChatTurn({
    required String message,
    required String modelId,
    required ModelType modelType,
  }) async {
    try {
      return await _generateOnce(
        message: message,
        modelId: modelId,
        modelType: modelType,
        forceCpu: false,
      );
    } catch (_) {
      await _disposeCurrentChat();
      return _generateOnce(
        message: message,
        modelId: modelId,
        modelType: modelType,
        forceCpu: true,
      );
    }
  }

  Future<String> generateLogsSummary({
    required String message,
    required String logsContext,
    required String modelId,
    required ModelType modelType,
  }) async {
    try {
      return await _generateLogsSummaryOnce(
        message: message,
        logsContext: logsContext,
        modelId: modelId,
        modelType: modelType,
        forceCpu: false,
      );
    } catch (_) {
      await _disposeCurrentChat();
      return _generateLogsSummaryOnce(
        message: message,
        logsContext: logsContext,
        modelId: modelId,
        modelType: modelType,
        forceCpu: true,
      );
    }
  }

  Future<void> dispose() async {
    final model = _model;
    _chat = null;
    _model = null;
    _chatModelId = null;
    _chatModelType = null;
    if (model != null) {
      await model.close();
    }
  }

  Future<ChatTurnPayload> _generateOnce({
    required String message,
    required String modelId,
    required ModelType modelType,
    required bool forceCpu,
  }) async {
    await _ensureChatWithBackend(
      modelId: modelId,
      modelType: modelType,
      forceCpu: forceCpu,
    );
    final prompt = _buildToolRoutingPrompt(message);
    await _chat!.addQuery(Message.text(text: prompt, isUser: true));
    final response = await _chat!.generateChatResponse();
    final rawText = response is TextResponse
        ? response.token.trim()
        : response.toString().trim();
    return _parsePayload(rawText);
  }

  Future<String> _generateLogsSummaryOnce({
    required String message,
    required String logsContext,
    required String modelId,
    required ModelType modelType,
    required bool forceCpu,
  }) async {
    await _ensureChatWithBackend(
      modelId: modelId,
      modelType: modelType,
      forceCpu: forceCpu,
    );
    final prompt = _buildLogsSummaryPrompt(
      message: message,
      logsContext: logsContext,
    );
    await _chat!.addQuery(Message.text(text: prompt, isUser: true));
    final response = await _chat!.generateChatResponse();
    final rawText = response is TextResponse
        ? response.token.trim()
        : response.toString().trim();
    return _cleanSummaryText(rawText);
  }

  Future<void> _ensureChatWithBackend({
    required String modelId,
    required ModelType modelType,
    required bool forceCpu,
  }) async {
    final sameSession =
        _chat != null && _chatModelId == modelId && _chatModelType == modelType;
    if (sameSession && !forceCpu) {
      return;
    }
    await _disposeCurrentChat();
    final model = await FlutterGemma.getActiveModel(
      maxTokens: 4096,
      preferredBackend: _backend(forceCpu: forceCpu),
    );
    final chat = await model.createChat(
      modelType: modelType,
      temperature: 0.4,
      topK: 20,
      topP: 0.9,
      isThinking: true,
    );
    _model = model;
    _chat = chat;
    _chatModelId = modelId;
    _chatModelType = modelType;
  }

  PreferredBackend? _backend({required bool forceCpu}) {
    if (forceCpu || defaultTargetPlatform == TargetPlatform.macOS) {
      return PreferredBackend.cpu;
    }
    return null;
  }

  Future<void> _disposeCurrentChat() async {
    if (_model != null) {
      await _model!.close();
    }
    _chat = null;
    _model = null;
    _chatModelId = null;
    _chatModelType = null;
  }

  ChatTurnPayload _parsePayload(String rawText) {
    var text = rawText;

    text = text
        .replaceAll(
          RegExp(r'<think>[\s\S]*?<\/think>', caseSensitive: false),
          '',
        )
        .replaceAll(RegExp(r'<\/?think>', caseSensitive: false), '')
        .trim();

    final codeBlock = RegExp(r'```(?:json)?\s*([\s\S]*?)```').firstMatch(text);
    if (codeBlock != null) {
      text = codeBlock.group(1)!.trim();
    }

    final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(text);
    if (jsonMatch != null) {
      try {
        final parsed = jsonDecode(jsonMatch.group(0)!) as Map<String, dynamic>;
        final reply = (parsed['reply'] as String?)?.trim() ?? '';
        final action = _parseAction(parsed['action']);
        final shouldSave = action == 'save' || _parseBool(parsed['shouldSave']);
        final date = _parseDate(parsed['date']);
        final logFilter = _parseLogFilter(parsed['filter'] ?? parsed['logFilter']);
        final title = (parsed['title'] as String?)?.trim() ?? '';
        final subtitle = (parsed['subtitle'] as String?)?.trim() ?? '';
        final body = (parsed['body'] as String?)?.trim() ?? '';
        final tagsDynamic = parsed['tags'];
        final tags = tagsDynamic is List
            ? tagsDynamic
                  .map((t) => t.toString().trim().toLowerCase())
                  .where((t) => t.isNotEmpty)
                  .take(5)
                  .toList(growable: false)
            : const <String>[];
        return ChatTurnPayload(
          reply: reply.isNotEmpty ? reply : _fallbackReply,
          action: action,
          date: shouldSave ? (date.isNotEmpty ? date : _todayIso()) : '',
          logFilter: action == 'get_logs' ? logFilter : '',
          shouldSave: shouldSave,
          title: title.length > 80 ? title.substring(0, 80) : title,
          subtitle:
              subtitle.length > 140 ? subtitle.substring(0, 140) : subtitle,
          body: body.length > 240 ? body.substring(0, 240) : body,
          tags: tags,
        );
      } catch (_) {
        final replyMatch = RegExp(r'"reply"\s*:\s*"((?:[^"\\]|\\.)*)"')
            .firstMatch(jsonMatch.group(0)!);
        if (replyMatch != null) {
          final extracted = replyMatch.group(1)!
              .replaceAll(r'\"', '"')
              .replaceAll(r'\\', r'\')
              .trim();
          return ChatTurnPayload(
            reply: extracted.isNotEmpty ? extracted : _fallbackReply,
            action: 'reply',
            date: '',
            logFilter: '',
            shouldSave: false,
            title: '',
            subtitle: '',
            body: '',
            tags: const [],
          );
        }
      }
    }

    return ChatTurnPayload(
      reply: _fallbackReply,
      action: 'reply',
      date: '',
      logFilter: '',
      shouldSave: false,
      title: '',
      subtitle: '',
      body: '',
      tags: const [],
    );
  }

  bool _parseBool(Object? raw) {
    if (raw is bool) return raw;
    if (raw is String) return raw.toLowerCase().trim() == 'true';
    return false;
  }

  String _parseAction(Object? raw) {
    final text = (raw?.toString() ?? '').trim().toLowerCase();
    if (text == 'save' || text == 'get_logs' || text == 'reply') {
      return text;
    }
    return 'reply';
  }

  String _parseDate(Object? raw) {
    final value = (raw?.toString() ?? '').trim();
    return RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value) ? value : '';
  }

  String _parseLogFilter(Object? raw) {
    final value = (raw?.toString() ?? '').trim().toLowerCase();
    if (value == 'all' || value == 'today') {
      return value;
    }
    if (RegExp(r'^date:\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
      return value;
    }
    if (RegExp(r'^range:\d{4}-\d{2}-\d{2},\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
      return value;
    }
    return 'all';
  }

  static const _fallbackReply = 'I\'m ready. Tell me what you worked on today.';

  String _buildToolRoutingPrompt(String message) {
    final now = DateTime.now();
    final todayIso = _toIsoDate(now);
    final todayHuman = _toHumanDate(now);
    return '''
Today is $todayHuman ($todayIso). Use this as your only date reference.

You are WorkJournel, a private work journal assistant.
You have one tool:
TOOL get_logs:
- purpose: fetch user's saved work logs
- filters:
  - all
  - today
  - date:YYYY-MM-DD
  - range:YYYY-MM-DD,YYYY-MM-DD

Step 1 — Classify the message into one action:
A) action = "save" for work report messages about what the user did.
B) action = "get_logs" for any request asking to see, count, filter, summarize, or analyze past logs.
C) action = "reply" for greetings, empty text, or normal chat that does not require save/get_logs.

Step 2 — Date handling rules for action="save":
- If the user mentions relative dates like "day before yesterday", "yesterday", "this monday", "last friday", resolve them to an exact date in YYYY-MM-DD from today ($todayIso).
- If no date is mentioned, always use today ($todayIso).
- Always return the exact resolved date in field "date".

Step 3 — For action="get_logs", return a "filter":
- all
- today
- date:YYYY-MM-DD
- range:YYYY-MM-DD,YYYY-MM-DD
Infer the best filter from user request.

Step 4 — reply style:
- Keep reply max 10 words.
- For save: brief acknowledgment only. Do not repeat user details.
- For get_logs: brief acknowledgment that you will check logs.
- For reply: ask what they worked on today.

Step 5 — Fill memory fields only when action="save":
- title: max 80 chars
- subtitle: max 140 chars, the key detail
- body: first-person, max 240 chars (I completed... / I worked on... / I fixed...)
- tags: 2-4 lowercase tags

When action is not "save": date="", title="", subtitle="", body="", tags=[].
When action is not "get_logs": filter="".

Respond with ONLY valid JSON, no markdown, no extra text:
{"action":"save|get_logs|reply","reply":"...","date":"YYYY-MM-DD or empty","filter":"all|today|date:YYYY-MM-DD|range:YYYY-MM-DD,YYYY-MM-DD or empty","title":"...","subtitle":"...","body":"...","tags":["..."]}

User: $message
''';
  }

  String _buildLogsSummaryPrompt({
    required String message,
    required String logsContext,
  }) {
    final now = DateTime.now();
    final todayIso = _toIsoDate(now);
    final todayHuman = _toHumanDate(now);
    return '''
Today is $todayHuman ($todayIso). Use this date as reference.

You are WorkJournel, answering a log question.
User asked: $message

Tool result:
$logsContext

Rules:
- Answer only from the tool result.
- If no logs were found, say that clearly and ask a short follow-up.
- Keep it concise and practical.
- Do not use markdown or JSON.
''';
  }

  String _cleanSummaryText(String rawText) {
    var text = rawText
        .replaceAll(
          RegExp(r'<think>[\s\S]*?<\/think>', caseSensitive: false),
          '',
        )
        .replaceAll(RegExp(r'<\/?think>', caseSensitive: false), '')
        .trim();
    final codeBlock = RegExp(r'```(?:text)?\s*([\s\S]*?)```').firstMatch(text);
    if (codeBlock != null) {
      text = codeBlock.group(1)!.trim();
    }
    return text.isNotEmpty ? text : 'I could not read the logs right now.';
  }

  String _todayIso() => _toIsoDate(DateTime.now());

  String _toIsoDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  String _toHumanDate(DateTime date) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekday, $month ${date.day}, ${date.year}';
  }
}
