import 'package:flutter/foundation.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workjournel/models/local_llm_model.dart';
import 'dart:io';

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
    CancelToken? cancelToken,
  }) async {
    await _ensureDownloadPaths();
    final source = _resolveSource(model);
    if (source == null) {
      throw UnsupportedError(
        '${model.name} is not supported on this platform.',
      );
    }
    var downloadBuilder = FlutterGemma.installModel(
      modelType: model.modelType,
    ).fromNetwork(source);
    if (cancelToken != null) {
      downloadBuilder = downloadBuilder.withCancelToken(cancelToken);
    }
    await downloadBuilder.withProgress((progress) {
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
    await _ensureDownloadPaths();
    final installed = await isModelInstalled(model);
    if (!installed) {
      throw StateError('${model.name} has not been downloaded yet.');
    }
    final spec = InferenceModelSpec.fromLegacyUrl(
      name: model.id,
      modelUrl: source,
      modelType: model.modelType,
      fileType: _resolveFileType(source),
      replacePolicy: ModelReplacePolicy.keep,
    );
    FlutterGemmaPlugin.instance.modelManager.setActiveModel(spec);
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

  static ModelFileType _resolveFileType(String source) {
    if (source.endsWith('.bin') || source.endsWith('.tflite')) {
      return ModelFileType.binary;
    }
    return ModelFileType.task;
  }

  static Future<void> _ensureDownloadPaths() async {
    if (defaultTargetPlatform != TargetPlatform.macOS &&
        defaultTargetPlatform != TargetPlatform.windows &&
        defaultTargetPlatform != TargetPlatform.linux) {
      return;
    }
    final cacheDir = await getApplicationCacheDirectory();
    await cacheDir.create(recursive: true);
    await Directory(
      '${cacheDir.path}/com.bbflight.background_downloader',
    ).create(recursive: true);
  }
}
