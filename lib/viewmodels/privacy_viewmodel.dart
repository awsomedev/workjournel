import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PrivacyViewModel extends ChangeNotifier {
  BuildContext? _context;

  void initialize() {}

  void attachContext(BuildContext context) {
    _context = context;
  }

  void onContinue() {
    if (_context != null) {
      _context!.go('/home');
    }
  }

  void onExportData() {
    // Export data logic
  }

  void onDeleteHistory() {
    // Delete history logic
  }
}
