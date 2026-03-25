import 'package:flutter/foundation.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:workjournel/models/local_llm_model.dart';

class LocalLlmService {
  static void initialize() {
    const token = String.fromEnvironment('HUGGINGFACE_TOKEN');
    FlutterGemma.initialize(huggingFaceToken: token.isEmpty ? null : token);
  }

  static bool isSupportedOnCurrentPlatform(LocalLlmModel model) {
    return _resolveSource(model) != null;
  }

  static Future<bool> isModelInstalled(LocalLlmModel model) async {
    final source = _resolveSource(model);
    if (source == null) {
      return false;
    }
    final modelFileName = source.split('/').last;
    return FlutterGemma.isModelInstalled(modelFileName);
  }

  static Future<void> downloadModel(
    LocalLlmModel model, {
    required ValueChanged<int> onProgress,
  }) async {
    final source = _resolveSource(model);
    if (source == null) {
      throw UnsupportedError(
        '${model.name} is not supported on this platform.',
      );
    }
    await FlutterGemma.installModel(
      modelType: model.modelType,
    ).fromNetwork(source).withProgress((progress) {
      onProgress(progress);
    }).install();
  }

  static Future<void> activateModel(LocalLlmModel model) async {
    final source = _resolveSource(model);
    if (source == null) {
      throw UnsupportedError(
        '${model.name} is not supported on this platform.',
      );
    }
    final installed = await isModelInstalled(model);
    if (!installed) {
      throw StateError('${model.name} has not been downloaded yet.');
    }
    await FlutterGemma.getActiveModel();
  }

  static String? _resolveSource(LocalLlmModel model) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return model.androidUrl;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return model.iosUrl;
    }
    if (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return model.desktopUrl;
    }
    return null;
  }
}
