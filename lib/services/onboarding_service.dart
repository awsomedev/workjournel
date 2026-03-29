import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService {
  static const _onboardingCompleteKey = 'onboarding_complete';

  static Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  static Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
  }
}
