import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:workjournel/viewmodels/chat_viewmodel.dart';
import 'package:workjournel/viewmodels/model_selection_viewmodel.dart';
import 'package:workjournel/widgets/chat/chat_empty_state.dart';
import 'package:workjournel/widgets/chat/chat_input_bar.dart';
import 'package:workjournel/widgets/chat/chat_message_list.dart';
import 'package:workjournel/widgets/chat/chat_top_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _viewModel = ChatViewModel();
  final _modelViewModel = ModelSelectionViewModel();
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _modelViewModel.applyStartupSelection();
    _viewModel.addListener(_onMessagesChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onMessagesChanged);
    _viewModel.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onMessagesChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> _sendMessage() async {
    if (_viewModel.isSending) {
      return;
    }
    final useClaudeCli = _modelViewModel.shouldUseClaudeCli;
    if (useClaudeCli && !_modelViewModel.isClaudeReady) {
      final message = _modelViewModel.claudeStatusMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppFonts.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
      return;
    }
    if (!useClaudeCli && !_modelViewModel.hasSelectedModel) {
      return;
    }
    final text = _messageController.text;
    if (text.trim().isEmpty) {
      return;
    }
    final selectedModel = useClaudeCli ? null : _modelViewModel.activeModel;
    if (!useClaudeCli && selectedModel == null) {
      return;
    }
    _messageController.clear();
    final sendFuture = _viewModel.sendMessage(
      text,
      model: selectedModel,
      useClaudeCli: useClaudeCli,
    );
    await sendFuture;
    if (!mounted) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) {
      return;
    }
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  Future<void> _openModelSelection() async {
    await context.push('/settings/models');
    await _modelViewModel.refreshStates();
  }

  Future<void> _onInlineModelSelected(String? modelId) async {
    if (modelId == null) {
      return;
    }
    try {
      await _modelViewModel.selectModel(modelId);
    } catch (_) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please download this model from settings first.',
            style: AppFonts.lexend(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.surfaceContainerHigh,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_modelViewModel, _viewModel]),
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final windowWidth = MediaQuery.of(context).size.width;
            final size = AppBreakpoints.fromWidth(windowWidth);
            return _ChatScaffold(
              size: size,
              viewModel: _viewModel,
              modelViewModel: _modelViewModel,
              usesClaudeCli: _modelViewModel.shouldUseClaudeCli,
              claudeStatusMessage:
                  _modelViewModel.shouldUseClaudeCli &&
                      !_modelViewModel.isClaudeReady
                  ? _modelViewModel.claudeStatusMessage
                  : null,
              messageController: _messageController,
              scrollController: _scrollController,
              onSend: () {
                _sendMessage();
              },
              onModelSelectionTap: _openModelSelection,
              onInlineModelSelected: _onInlineModelSelected,
            );
          },
        );
      },
    );
  }
}

class _ChatScaffold extends StatelessWidget {
  final ResponsiveSize size;
  final ChatViewModel viewModel;
  final ModelSelectionViewModel modelViewModel;
  final bool usesClaudeCli;
  final String? claudeStatusMessage;
  final TextEditingController messageController;
  final ScrollController scrollController;
  final VoidCallback onSend;
  final VoidCallback onModelSelectionTap;
  final ValueChanged<String?> onInlineModelSelected;

  const _ChatScaffold({
    required this.size,
    required this.viewModel,
    required this.modelViewModel,
    required this.usesClaudeCli,
    required this.claudeStatusMessage,
    required this.messageController,
    required this.scrollController,
    required this.onSend,
    required this.onModelSelectionTap,
    required this.onInlineModelSelected,
  });

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;
    final mobileNavClearance = size == ResponsiveSize.sm ? 109.0 : 0.0;
    final contentHorizontalPadding = switch (size) {
      ResponsiveSize.sm => 0.0,
      ResponsiveSize.md => 24.0,
      ResponsiveSize.lg => 48.0,
    };
    final listHorizontalPadding = switch (size) {
      ResponsiveSize.sm => 16.0,
      ResponsiveSize.md => 24.0,
      ResponsiveSize.lg => 32.0,
    };
    final contentMaxWidth = switch (size) {
      ResponsiveSize.sm => double.infinity,
      ResponsiveSize.md => 900.0,
      ResponsiveSize.lg => 1080.0,
    };
    final composerHeight = size == ResponsiveSize.sm ? 88.0 : 96.0;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: Column(
        children: [
          ChatTopBar(showSafeAreaTop: size == ResponsiveSize.sm),
          if (usesClaudeCli && claudeStatusMessage != null)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                claudeStatusMessage!,
                style: AppFonts.lexend(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: contentHorizontalPadding,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentMaxWidth),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: viewModel.hasMessages
                            ? ChatMessageList(
                                viewModel: viewModel,
                                size: size,
                                scrollController: scrollController,
                                padding: EdgeInsets.fromLTRB(
                                  listHorizontalPadding,
                                  18,
                                  listHorizontalPadding,
                                  composerHeight +
                                      safeBottom +
                                      mobileNavClearance +
                                      28,
                                ),
                                agentStatus: viewModel.agentStatus,
                              )
                            : ChatEmptyState(
                                hasSelectedModel: usesClaudeCli
                                    ? true
                                    : modelViewModel.hasSelectedModel,
                                isLoading:
                                    modelViewModel.isCheckingClaudeStatus,
                                selectedModelId: usesClaudeCli
                                    ? null
                                    : modelViewModel.selectedModelId,
                                models: modelViewModel.models,
                                onModelChanged: onInlineModelSelected,
                                onOpenModelSelection: onModelSelectionTap,
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: mobileNavClearance),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ChatInputBar(
                            controller: messageController,
                            onSend: onSend,
                            size: size,
                            isEnabled: usesClaudeCli
                                ? !viewModel.isSending &&
                                      modelViewModel.isClaudeReady
                                : modelViewModel.hasSelectedModel &&
                                      !viewModel.isSending,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
