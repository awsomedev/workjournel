import 'dart:async';
import 'package:flutter/material.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    // Simulate initialization (e.g., loading preferences, checking auth)
    await Future.delayed(const Duration(seconds: 3));
    _isInitialized = true;
    notifyListeners();
  }
}
