import 'package:flutter/foundation.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:workjournel/models/journal_entry_record.dart';

class BragDocLlmService {
  InferenceModel? _model;
  InferenceChat? _chat;
  String? _chatModelId;
  ModelType? _chatModelType;

  Future<String> generateBragDoc({
    required List<JournalEntryRecord> memories,
    required DateTime fromDate,
    required DateTime toDate,
    required String modelId,
    required ModelType modelType,
  }) async {
    try {
      return await _generateOnce(
        memories: memories,
        fromDate: fromDate,
        toDate: toDate,
        modelId: modelId,
        modelType: modelType,
        forceCpu: false,
      );
    } catch (_) {
      await _disposeCurrentChat();
      return _generateOnce(
        memories: memories,
        fromDate: fromDate,
        toDate: toDate,
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

  Future<String> _generateOnce({
    required List<JournalEntryRecord> memories,
    required DateTime fromDate,
    required DateTime toDate,
    required String modelId,
    required ModelType modelType,
    required bool forceCpu,
  }) async {
    await _ensureChatWithBackend(
      modelId: modelId,
      modelType: modelType,
      forceCpu: forceCpu,
    );
    final prompt = _buildPrompt(
      memories: memories,
      fromDate: fromDate,
      toDate: toDate,
      modelType: modelType,
    );
    await _chat!.addQuery(Message.text(text: prompt, isUser: true));
    final response = await _chat!.generateChatResponse();
    final rawText = response is TextResponse
        ? response.token.trim()
        : response.toString().trim();
    return _sanitizeMarkdown(rawText);
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
      maxTokens: 8192,
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

  String _buildPrompt({
    required List<JournalEntryRecord> memories,
    required DateTime fromDate,
    required DateTime toDate,
    required ModelType modelType,
  }) {
    final memoryLines = memories
        .map((entry) {
          final created = DateTime.fromMillisecondsSinceEpoch(
            entry.createdAtMillis,
          );
          final tags = entry.tags.join(', ');
          return '- date: ${_toIsoDate(created)} | title: ${entry.title} | subtitle: ${entry.subtitle} | body: ${entry.body} | tags: [$tags]';
        })
        .join('\n');
    final message =
        '''
You are WorkJournel Brag Writer.
Generate a brag document in markdown from the provided work memories.

Rules:
1) Output only markdown. No code fences.
2) Keep first person voice.
3) Start with: # Brag Document
4) Then include:
   - Timeframe section
   - Impact Highlights section (bullets)
   - Detailed Wins section grouped by theme
   - Metrics and Outcomes section
   - Next Focus section
5) Use concise, strong statements suitable for self-review.
6) If a metric is not explicit, do not invent numbers.
7) Reference only the memories provided.

Timeframe:
From ${_toIsoDate(fromDate)} to ${_toIsoDate(toDate)}.

Memories:
$memoryLines
''';
    if (modelType != ModelType.qwen) {
      return message;
    }
    final lower = message.toLowerCase();
    if (lower.contains('/no_think') || lower.contains('/think')) {
      return message;
    }
    return '$message /no_think';
  }

  String _sanitizeMarkdown(String rawText) {
    var text = rawText
        .replaceAll(
          RegExp(r'<think>[\s\S]*?<\/think>', caseSensitive: false),
          '',
        )
        .replaceAll(RegExp(r'<\/?think>', caseSensitive: false), '')
        .trim();
    final codeBlock = RegExp(
      r'```(?:markdown)?\s*([\s\S]*?)```',
    ).firstMatch(text);
    if (codeBlock != null) {
      text = codeBlock.group(1)!.trim();
    }
    if (text.isEmpty) {
      return '# Brag Document\n\nNo content generated.';
    }
    return text;
  }

  String _toIsoDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
