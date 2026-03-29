import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:workjournel/services/onboarding_service.dart';

class PrivacyViewModel extends ChangeNotifier {
  BuildContext? _context;

  void initialize() {}

  void attachContext(BuildContext context) {
    _context = context;
  }

  void onContinue() {
    if (_context != null) {
      OnboardingService.markOnboardingComplete();
      _context!.go('/chat');
    }
  }

  void onExportData() {
    // Export data logic
  }

  void onDeleteHistory() {
    // Delete history logic
  }
}
