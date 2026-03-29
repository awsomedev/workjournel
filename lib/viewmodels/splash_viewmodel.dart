import 'dart:async';
import 'package:flutter/material.dart';
import 'package:workjournel/services/onboarding_service.dart';

class SplashViewModel extends ChangeNotifier {
  bool _isInitialized = false;
  bool _onboardingComplete = false;

  bool get isInitialized => _isInitialized;
  bool get onboardingComplete => _onboardingComplete;

  Future<void> initialize() async {
    _onboardingComplete = await OnboardingService.isOnboardingComplete();
    await Future.delayed(const Duration(seconds: 2));
    _isInitialized = true;
    notifyListeners();
  }
}
