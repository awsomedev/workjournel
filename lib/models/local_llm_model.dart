import 'package:flutter_gemma/flutter_gemma.dart';

enum ModelInstallStatus {
  notInstalled,
  downloading,
  installed,
  failed,
  unavailable,
}

class LocalLlmModel {
  final String id;
  final String name;
  final String family;
  final String sizeLabel;
  final int sizeInMb;
  final String summary;
  final ModelType modelType;
  final String? androidUrl;
  final String? iosUrl;
  final String? desktopUrl;
  final ModelInstallStatus status;
  final int progress;
  final String? errorMessage;

  const LocalLlmModel({
    required this.id,
    required this.name,
    required this.family,
    required this.sizeLabel,
    required this.sizeInMb,
    required this.summary,
    required this.modelType,
    required this.status,
    this.androidUrl,
    this.iosUrl,
    this.desktopUrl,
    this.progress = 0,
    this.errorMessage,
  });

  bool get isInstalled => status == ModelInstallStatus.installed;

  LocalLlmModel copyWith({
    ModelInstallStatus? status,
    int? progress,
    String? errorMessage,
    bool clearError = false,
  }) {
    return LocalLlmModel(
      id: id,
      name: name,
      family: family,
      sizeLabel: sizeLabel,
      sizeInMb: sizeInMb,
      summary: summary,
      modelType: modelType,
      androidUrl: androidUrl,
      iosUrl: iosUrl,
      desktopUrl: desktopUrl,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
