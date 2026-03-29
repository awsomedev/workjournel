import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

class ClaudeCliStatus {
  final bool isAvailable;
  final bool isAuthenticated;
  final String? version;
  final String? errorMessage;

  const ClaudeCliStatus({
    required this.isAvailable,
    required this.isAuthenticated,
    this.version,
    this.errorMessage,
  });

  bool get isReady => isAvailable && isAuthenticated;

  String get userMessage {
    if (!isAvailable) {
      return 'Claude Code CLI is not available on this Mac.';
    }
    if (!isAuthenticated) {
      return 'Open Terminal and run `claude` to authenticate, then try again.';
    }
    return errorMessage ?? 'Claude Code is unavailable right now.';
  }
}

class ClaudeCliService {
  static const String defaultModel = 'claude-haiku-4-5-20251001';

  final String executable;
  final String model;

  const ClaudeCliService({
    this.executable = 'claude',
    this.model = defaultModel,
  });

  bool get isSupportedPlatform =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;

  Future<ClaudeCliStatus> getStatus() async {
    if (!isSupportedPlatform) {
      return const ClaudeCliStatus(
        isAvailable: false,
        isAuthenticated: false,
        errorMessage: 'Claude Code is only enabled on macOS.',
      );
    }
    final versionResult = await _run([
      '--version',
    ], timeout: const Duration(seconds: 8));
    if (versionResult.exitCode != 0) {
      return ClaudeCliStatus(
        isAvailable: false,
        isAuthenticated: false,
        errorMessage: _buildError('Could not run Claude CLI.', versionResult),
      );
    }
    final version = _extractFirstLine(versionResult.stdout);
    // Verify authentication by running a minimal prompt.
    final authResult = await _run([
      '-p',
      'hi',
      '--model',
      model,
      '--max-turns',
      '1',
    ], timeout: const Duration(seconds: 15));
    final isAuthenticated = authResult.exitCode == 0;
    return ClaudeCliStatus(
      isAvailable: true,
      isAuthenticated: isAuthenticated,
      version: version.isEmpty ? null : version,
      errorMessage: isAuthenticated
          ? null
          : 'Open Terminal and run `claude` to authenticate, then try again.',
    );
  }

  Future<String> chat(String prompt) async {
    if (!isSupportedPlatform) {
      throw UnsupportedError('Claude Code chat is only supported on macOS.');
    }
    final result = await _run([
      '-p',
      prompt,
      '--model',
      model,
    ], timeout: const Duration(minutes: 3));
    if (result.exitCode != 0) {
      throw StateError(_buildError('Claude chat failed.', result));
    }
    final output = result.stdout.trim();
    if (output.isEmpty) {
      throw StateError('Claude returned an empty response.');
    }
    return output;
  }

  Future<_ClaudeProcessResult> _run(
    List<String> args, {
    required Duration timeout,
  }) async {
    try {
      final result = await Process.run('/usr/bin/env', [
        executable,
        ...args,
      ], environment: _processEnvironment()).timeout(timeout);
      return _ClaudeProcessResult(
        exitCode: result.exitCode,
        stdout: (result.stdout ?? '').toString(),
        stderr: (result.stderr ?? '').toString(),
      );
    } on TimeoutException {
      return const _ClaudeProcessResult(
        exitCode: 124,
        stdout: '',
        stderr: 'Command timed out.',
      );
    } on ProcessException catch (error) {
      return _ClaudeProcessResult(
        exitCode: 127,
        stdout: '',
        stderr: error.message,
      );
    }
  }

  Map<String, String> _processEnvironment() {
    final env = <String, String>{...Platform.environment};
    final home = env['HOME'] ?? Platform.environment['HOME'] ?? '';
    final localBin = home.isNotEmpty ? '$home/.local/bin' : '';
    const extraPaths = '/opt/homebrew/bin:/usr/local/bin';
    const fallbackPath =
        '/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin';
    final existingPath = env['PATH'] ?? '';
    if (existingPath.trim().isEmpty) {
      env['PATH'] = localBin.isNotEmpty
          ? '$localBin:$fallbackPath'
          : fallbackPath;
    } else {
      final additions = <String>[];
      if (localBin.isNotEmpty && !existingPath.contains('.local/bin')) {
        additions.add(localBin);
      }
      if (!existingPath.contains('/opt/homebrew/bin')) {
        additions.add(extraPaths);
      }
      if (additions.isNotEmpty) {
        env['PATH'] = '${additions.join(':')}:$existingPath';
      }
    }
    return env;
  }

  String _extractFirstLine(String value) {
    final lines = value
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty);
    return lines.isEmpty ? '' : lines.first;
  }

  String _buildError(String prefix, _ClaudeProcessResult result) {
    final error = result.stderr.trim();
    final output = result.stdout.trim();
    if (error.isNotEmpty) {
      return '$prefix $error';
    }
    if (output.isNotEmpty) {
      return '$prefix $output';
    }
    return prefix;
  }
}

class _ClaudeProcessResult {
  final int exitCode;
  final String stdout;
  final String stderr;

  const _ClaudeProcessResult({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
  });
}
