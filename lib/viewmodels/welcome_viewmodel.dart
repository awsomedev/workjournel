import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class WelcomeViewModel extends ChangeNotifier {
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    // Add any necessary initialization logic here
    await Future.delayed(const Duration(milliseconds: 500));
    _isInitialized = true;
    notifyListeners();
  }

  void onGetStarted(BuildContext context) {
    context.go('/privacy');
  }

  void onLogin() {
    // Handle navigation to login
  }
}
