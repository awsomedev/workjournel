import 'package:flutter/foundation.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:workjournel/models/local_llm_model.dart';
import 'package:workjournel/services/claude_cli_service.dart';
import 'package:workjournel/services/local_llm_service.dart';
import 'package:workjournel/services/model_persistence_service.dart';

class ModelSelectionViewModel extends ChangeNotifier {
  static const String claudeCodeOptionId = 'claude_code_cli';
  static final ModelSelectionViewModel _instance =
      ModelSelectionViewModel._internal();

  factory ModelSelectionViewModel() {
    return _instance;
  }

  ModelSelectionViewModel._internal();

  final List<LocalLlmModel> _models = [
    const LocalLlmModel(
      id: 'gemma_3_270m',
      name: 'Gemma 3 270M',
      family: 'Gemma',
      sizeLabel: '0.3GB',
      sizeInMb: 300,
      summary: 'Fast everyday local model for concise journaling support.',
      modelType: ModelType.gemmaIt,
      androidUrl:
          'https://huggingface.co/litert-community/gemma-3-270m-it/resolve/main/gemma3-270m-it-q8.task',
      iosUrl:
          'https://huggingface.co/litert-community/gemma-3-270m-it/resolve/main/gemma3-270m-it-q8.task',
      desktopUrl:
          'https://huggingface.co/litert-community/gemma-3-270m-it/resolve/main/gemma3-270m-it-q8.litertlm',
      status: ModelInstallStatus.notInstalled,
    ),
    const LocalLlmModel(
      id: 'function_gemma_270m',
      name: 'FunctionGemma 270M',
      family: 'FunctionGemma',
      sizeLabel: '284MB',
      sizeInMb: 284,
      summary: 'Optimized for tool and function-calling workflows.',
      modelType: ModelType.functionGemma,
      androidUrl:
          'https://huggingface.co/sasha-denisov/function-gemma-270M-it/resolve/main/functiongemma-270M-it.task',
      iosUrl:
          'https://huggingface.co/sasha-denisov/function-gemma-270M-it/resolve/main/functiongemma-270M-it.task',
      desktopUrl:
          'https://huggingface.co/sasha-denisov/function-gemma-270M-it/resolve/main/functiongemma-270M-it.litertlm',
      status: ModelInstallStatus.notInstalled,
    ),
    const LocalLlmModel(
      id: 'qwen3_0_6b',
      name: 'Qwen3 0.6B',
      family: 'Qwen',
      sizeLabel: '586MB',
      sizeInMb: 586,
      summary: 'Best speed and accuracy balance for daily chat assistance.',
      modelType: ModelType.qwen,
      androidUrl:
          'https://huggingface.co/litert-community/Qwen3-0.6B/resolve/main/Qwen3-0.6B.litertlm',
      desktopUrl:
          'https://huggingface.co/litert-community/Qwen3-0.6B/resolve/main/Qwen3-0.6B.litertlm',
      status: ModelInstallStatus.notInstalled,
    ),
    const LocalLlmModel(
      id: 'deepseek_r1_1_5b',
      name: 'DeepSeek R1 Distill 1.5B',
      family: 'DeepSeek',
      sizeLabel: '1.7GB',
      sizeInMb: 1700,
      summary: 'Reasoning-focused model for deeper multi-step responses.',
      modelType: ModelType.deepSeek,
      androidUrl:
          'https://huggingface.co/litert-community/DeepSeek-R1-Distill-Qwen-1.5B/resolve/main/deepseek_q8_ekv1280.task',
      iosUrl:
          'https://huggingface.co/litert-community/DeepSeek-R1-Distill-Qwen-1.5B/resolve/main/deepseek_q8_ekv1280.task',
      desktopUrl:
          'https://huggingface.co/litert-community/DeepSeek-R1-Distill-Qwen-1.5B/resolve/main/DeepSeek-R1-Distill-Qwen-1.5B_multi-prefill-seq_q8_ekv4096.litertlm',
      status: ModelInstallStatus.notInstalled,
    ),
  ];

  bool _isInitialized = false;
  String? _selectedModelId;
  bool _hasUserSelected = false;
  ClaudeCliStatus? _claudeStatus;
  bool _isCheckingClaudeStatus = false;
  final ClaudeCliService _claudeCliService = const ClaudeCliService();
  final Map<String, CancelToken> _cancelTokens = {};
  final Map<String, int> _downloadSessionIds = {};
  String? _activeDownloadModelId;

  List<LocalLlmModel> get models => List.unmodifiable(_models);

  String? get selectedModelId => _selectedModelId;

  bool get hasSelectedModel => _selectedModelId != null;
  bool get supportsClaudeOption =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;
  bool get isCheckingClaudeStatus => _isCheckingClaudeStatus;
  ClaudeCliStatus? get claudeStatus => _claudeStatus;
  bool get isClaudeSelected => _selectedModelId == claudeCodeOptionId;
  bool get isClaudeReady => _claudeStatus?.isReady ?? false;
  bool get hasInstalledLocalModels => _models.any((model) => model.isInstalled);
  bool get shouldUseClaudeCli =>
      supportsClaudeOption &&
      (isClaudeSelected ||
          (_selectedModelId == null && !hasInstalledLocalModels && isClaudeReady));
  String? get claudeVersion => _claudeStatus?.version;
  String get claudeStatusMessage {
    if (!supportsClaudeOption) {
      return 'Claude Code is only available on macOS.';
    }
    if (_isCheckingClaudeStatus) {
      return 'Checking Claude Code status...';
    }
    final status = _claudeStatus;
    if (status == null) {
      return 'Claude Code status is unavailable.';
    }
    if (status.isReady) {
      final version = status.version;
      if (version == null || version.isEmpty) {
        return 'Claude Code is ready.';
      }
      return 'Claude Code is ready ($version).';
    }
    return status.userMessage;
  }

  LocalLlmModel? get activeModel {
    if (_selectedModelId == null) {
      return null;
    }
    for (final model in _models) {
      if (model.id == _selectedModelId) {
        return model;
      }
    }
    return null;
  }

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;
    await _restorePersistedState();
    await refreshStates();
  }

  Future<void> applyStartupSelection() async {
    await initialize();
    if (!_hasUserSelected &&
        _selectedModelId == null &&
        !hasInstalledLocalModels &&
        isClaudeReady) {
      _selectedModelId = claudeCodeOptionId;
      _hasUserSelected = true;
      await _persistModelState();
      notifyListeners();
    }
  }

  Future<void> refreshStates() async {
    for (var i = 0; i < _models.length; i++) {
      final model = _models[i];
      if (!LocalLlmService.isSupportedOnCurrentPlatform(model)) {
        _models[i] = model.copyWith(status: ModelInstallStatus.unavailable);
        continue;
      }
      final installed = await LocalLlmService.isModelInstalled(model);
      _models[i] = model.copyWith(
        status: installed
            ? ModelInstallStatus.installed
            : ModelInstallStatus.notInstalled,
        progress: installed ? 100 : 0,
        clearError: true,
      );
    }
    await _refreshClaudeStatus();
    // Only clear selection if a local model was uninstalled.
    if (_selectedModelId != null &&
        _selectedModelId != claudeCodeOptionId &&
        !_isInstalled(_selectedModelId!)) {
      _selectedModelId = null;
      _hasUserSelected = false;
    }
    // Activate the selected local model if it's installed.
    if (_selectedModelId != null && _selectedModelId != claudeCodeOptionId) {
      final selected = activeModel;
      if (selected != null && selected.isInstalled) {
        try {
          await LocalLlmService.activateModel(selected);
        } catch (_) {
          // Keep the selection — activation can be retried.
        }
      }
    }
    // Only auto-select Claude if user has never made a choice.
    if (!_hasUserSelected &&
        _selectedModelId == null &&
        !hasInstalledLocalModels &&
        isClaudeReady) {
      _selectedModelId = claudeCodeOptionId;
      _hasUserSelected = true;
    }
    await _persistModelState();
    notifyListeners();
  }

  bool isSelected(String modelId) {
    return _selectedModelId == modelId;
  }

  Future<void> downloadModel(String modelId) async {
    final index = _indexForModel(modelId);
    if (index < 0) {
      return;
    }
    if (_activeDownloadModelId != null && _activeDownloadModelId != modelId) {
      return;
    }
    final model = _models[index];
    if (model.status == ModelInstallStatus.downloading ||
        model.status == ModelInstallStatus.unavailable) {
      return;
    }
    final sessionId = (_downloadSessionIds[model.id] ?? 0) + 1;
    _downloadSessionIds[model.id] = sessionId;
    _activeDownloadModelId = model.id;
    _models[index] = model.copyWith(
      status: ModelInstallStatus.downloading,
      progress: 0,
      clearError: true,
    );
    notifyListeners();

    try {
      final cancelToken = CancelToken();
      _cancelTokens[model.id] = cancelToken;
      await LocalLlmService.downloadModel(
        model,
        cancelToken: cancelToken,
        onProgress: (progress) {
          if (!_isSessionActive(model.id, sessionId) || cancelToken.isCancelled) {
            return;
          }
          final normalizedProgress = progress.clamp(0, 100);
          _models[index] = _models[index].copyWith(
            progress: normalizedProgress,
          );
          notifyListeners();
        },
      );
      if (!_isSessionActive(model.id, sessionId) || cancelToken.isCancelled) {
        cancelToken.throwIfCancelled();
      }
      final installed = await LocalLlmService.isModelInstalled(_models[index]);
      if (!installed) {
        throw StateError('${_models[index].name} was not installed.');
      }
      if (!_isSessionActive(model.id, sessionId)) {
        return;
      }
      _models[index] = _models[index].copyWith(
        status: ModelInstallStatus.installed,
        progress: 100,
        clearError: true,
      );
      _selectedModelId = model.id;
      _hasUserSelected = true;
      await _persistModelState();
      notifyListeners();
      _cancelTokens.remove(model.id);
    } catch (error) {
      _cancelTokens.remove(model.id);
      if (!_isSessionActive(model.id, sessionId)) {
        return;
      }
      if (CancelToken.isCancel(error)) {
        _models[index] = _models[index].copyWith(
          status: ModelInstallStatus.notInstalled,
          progress: 0,
          clearError: true,
        );
        await _persistModelState();
        notifyListeners();
        return;
      }
      _models[index] = _models[index].copyWith(
        status: ModelInstallStatus.failed,
        errorMessage: error.toString(),
      );
      await _persistModelState();
      notifyListeners();
      rethrow;
    } finally {
      if (_isSessionActive(model.id, sessionId)) {
        _downloadSessionIds.remove(model.id);
      }
      if (_activeDownloadModelId == model.id) {
        _activeDownloadModelId = null;
      }
    }
  }

  Future<void> cancelDownload(String modelId) async {
    final index = _indexForModel(modelId);
    if (index < 0) {
      return;
    }
    if (_models[index].status != ModelInstallStatus.downloading) {
      return;
    }
    final model = _models[index];
    final nextSessionId = (_downloadSessionIds[modelId] ?? 0) + 1;
    _downloadSessionIds[modelId] = nextSessionId;
    _cancelTokens[modelId]?.cancel('User cancelled download');
    await LocalLlmService.cancelModelDownload(model);
    _cancelTokens.remove(modelId);
    if (_activeDownloadModelId == modelId) {
      _activeDownloadModelId = null;
    }
    _models[index] = _models[index].copyWith(
      status: ModelInstallStatus.notInstalled,
      progress: 0,
      clearError: true,
    );
    await _persistModelState();
    notifyListeners();
  }

  Future<void> selectModel(String modelId) async {
    if (modelId == claudeCodeOptionId) {
      await selectClaudeCode();
      return;
    }
    final index = _indexForModel(modelId);
    if (index < 0) {
      return;
    }
    final model = _models[index];
    if (!model.isInstalled) {
      return;
    }
    await LocalLlmService.activateModel(model);
    _selectedModelId = model.id;
    _hasUserSelected = true;
    await _persistModelState();
    notifyListeners();
  }

  Future<void> selectClaudeCode() async {
    await _refreshClaudeStatus();
    if (!isClaudeReady) {
      throw StateError(claudeStatusMessage);
    }
    _selectedModelId = claudeCodeOptionId;
    _hasUserSelected = true;
    await _persistModelState();
    notifyListeners();
  }

  List<LocalLlmModel> get dropdownModels {
    return _models
        .where((model) => model.status != ModelInstallStatus.unavailable)
        .toList(growable: false);
  }

  bool _isInstalled(String modelId) {
    final index = _indexForModel(modelId);
    if (index < 0) {
      return false;
    }
    return _models[index].isInstalled;
  }

  int _indexForModel(String modelId) {
    return _models.indexWhere((model) => model.id == modelId);
  }

  bool _isSessionActive(String modelId, int sessionId) {
    return _downloadSessionIds[modelId] == sessionId;
  }

  Future<void> _restorePersistedState() async {
    final selectedModelId = await ModelPersistenceService.loadSelectedModelId();
    final installedModelIds =
        await ModelPersistenceService.loadInstalledModelIds();
    _hasUserSelected = await ModelPersistenceService.loadHasUserSelected();

    for (var i = 0; i < _models.length; i++) {
      final model = _models[i];
      if (!LocalLlmService.isSupportedOnCurrentPlatform(model)) {
        _models[i] = model.copyWith(status: ModelInstallStatus.unavailable);
        continue;
      }
      final isPersistedInstalled = installedModelIds.contains(model.id);
      _models[i] = model.copyWith(
        status: isPersistedInstalled
            ? ModelInstallStatus.installed
            : ModelInstallStatus.notInstalled,
        progress: isPersistedInstalled ? 100 : 0,
        clearError: true,
      );
    }

    _selectedModelId = null;
    if (selectedModelId != null && selectedModelId.isNotEmpty) {
      if (selectedModelId == claudeCodeOptionId && supportsClaudeOption) {
        _selectedModelId = selectedModelId;
      } else if (_indexForModel(selectedModelId) >= 0) {
        _selectedModelId = selectedModelId;
      }
    }

    notifyListeners();
  }

  Future<void> _refreshClaudeStatus() async {
    if (!supportsClaudeOption) {
      _claudeStatus = null;
      _isCheckingClaudeStatus = false;
      return;
    }
    _isCheckingClaudeStatus = true;
    notifyListeners();
    try {
      _claudeStatus = await _claudeCliService.getStatus();
    } catch (error) {
      _claudeStatus = ClaudeCliStatus(
        isAvailable: true,
        isAuthenticated: false,
        errorMessage: error.toString(),
      );
    } finally {
      _isCheckingClaudeStatus = false;
    }
  }

  Future<void> _persistModelState() async {
    final installedModelIds = _models
        .where((model) => model.status == ModelInstallStatus.installed)
        .map((model) => model.id)
        .toList(growable: false);
    await ModelPersistenceService.saveInstalledModelIds(installedModelIds);
    await ModelPersistenceService.saveSelectedModelId(_selectedModelId);
    await ModelPersistenceService.saveHasUserSelected(_hasUserSelected);
  }
}
