import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:workjournel/services/claude_cli_service.dart';

class ChatTurnPayload {
  final String reply;
  final String date;
  final bool shouldSave;
  final String title;
  final String subtitle;
  final String body;
  final List<String> tags;

  const ChatTurnPayload({
    required this.reply,
    required this.date,
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
  final ClaudeCliService _claudeCliService = const ClaudeCliService();

  bool get canUseClaudeCli =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;

  Future<ClaudeCliStatus> getClaudeStatus() {
    return _claudeCliService.getStatus();
  }

  Future<ChatTurnPayload> generateChatTurn({
    required String message,
    String? modelId,
    ModelType? modelType,
    bool useClaudeCli = false,
  }) async {
    if (useClaudeCli) {
      if (!canUseClaudeCli) {
        throw UnsupportedError('Claude Code chat is only supported on macOS.');
      }
      return _generateWithClaude(message: message);
    }
    if (modelId == null || modelType == null) {
      throw ArgumentError(
        'modelId and modelType are required on this platform.',
      );
    }
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

  Future<ChatTurnPayload> _generateWithClaude({required String message}) async {
    final prompt = _buildToolRoutingPrompt(message);
    final rawText = await _claudeCliService.chat(prompt);
    return _parsePayload(rawText);
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
    final prompt = _buildToolRoutingPrompt(
      _messageWithNoThinkDirective(message: message, modelType: modelType),
    );
    await _chat!.addQuery(Message.text(text: prompt, isUser: true));
    final response = await _chat!.generateChatResponse();
    final rawText = response is TextResponse
        ? response.token.trim()
        : response.toString().trim();
    return _parsePayload(rawText);
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
      temperature: 0.2,
      topK: 20,
      topP: 0.9,
      isThinking: false,
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
        final shouldSave = _parseBool(parsed['shouldSave']);
        final date = _parseDate(parsed['date']);
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
          date: shouldSave ? (date.isNotEmpty ? date : _todayIso()) : '',
          shouldSave: shouldSave,
          title: shouldSave
              ? (title.length > 80 ? title.substring(0, 80) : title)
              : '',
          subtitle: shouldSave
              ? (subtitle.length > 140 ? subtitle.substring(0, 140) : subtitle)
              : '',
          body: shouldSave
              ? (body.length > 240 ? body.substring(0, 240) : body)
              : '',
          tags: shouldSave ? tags : const <String>[],
        );
      } catch (_) {
        final replyMatch = RegExp(
          r'"reply"\s*:\s*"((?:[^"\\]|\\.)*)"',
        ).firstMatch(jsonMatch.group(0)!);
        if (replyMatch != null) {
          final extracted = replyMatch
              .group(1)!
              .replaceAll(r'\"', '"')
              .replaceAll(r'\\', r'\')
              .trim();
          return ChatTurnPayload(
            reply: extracted.isNotEmpty ? extracted : _fallbackReply,
            date: '',
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
      date: '',
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

  String _parseDate(Object? raw) {
    final value = (raw?.toString() ?? '').trim();
    return RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value) ? value : '';
  }

  static const _fallbackReply = 'I\'m ready. Tell me what you worked on today.';

  String _buildToolRoutingPrompt(String message) {
    final now = DateTime.now();
    final todayIso = _toIsoDate(now);
    final todayHuman = _toHumanDate(now);
    return '''
Today is $todayHuman ($todayIso). Use this as the date reference.

You are WorkJournel. This chat only decides if the user message should be saved as a work memory.
Output contract (must follow exactly):
- Return exactly one JSON object.
- Do not output any text before or after JSON.
- Do not output markdown, code fences, xml, tags, or thoughts.
- Use exactly these keys and no extras, in this order:
{"reply":"...","shouldSave":true|false,"title":"...","subtitle":"...","body":"...","tags":["..."],"date":"YYYY-MM-DD or empty"}

Rules:
1) shouldSave=true when user reports work done, progress, fix, meeting outcome, shipment, or task completion.
2) shouldSave=false for greeting, vague chat, unclear text, or non-work content.
3) When shouldSave=true:
   - Resolve relative dates ("yesterday", "day before yesterday", "this monday", "last friday") to exact YYYY-MM-DD using today.
   - If no date is mentioned, use $todayIso.
   - date must be exact YYYY-MM-DD.
   - title <= 80, subtitle <= 140, body <= 240 in first-person, tags 2-4 lowercase.
   - reply must be a short supportive acknowledgment (about 8-18 words), focused on what the user completed.
   - reply should encourage the user briefly ("nice work", "great progress", "keep it up").
   - never use team/company phrasing like "our project", "our team", or "contribution to project".
4) When shouldSave=false:
   - title="", subtitle="", body="", tags=[], date="".
   - reply should ask a clarifying follow-up question based on the user message.

User: $message
''';
  }

  String _messageWithNoThinkDirective({
    required String message,
    required ModelType modelType,
  }) {
    if (modelType != ModelType.qwen) {
      return message;
    }
    final lower = message.toLowerCase();
    if (lower.contains('/no_think') || lower.contains('/think')) {
      return message;
    }
    return '$message /no_think';
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
