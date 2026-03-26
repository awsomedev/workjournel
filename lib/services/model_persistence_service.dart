import 'package:shared_preferences/shared_preferences.dart';

class ModelPersistenceService {
  static const _selectedModelIdKey = 'selected_model_id';
  static const _installedModelIdsKey = 'installed_model_ids';

  static Future<SharedPreferences> _prefs() {
    return SharedPreferences.getInstance();
  }

  static Future<String?> loadSelectedModelId() async {
    final prefs = await _prefs();
    return prefs.getString(_selectedModelIdKey);
  }

  static Future<Set<String>> loadInstalledModelIds() async {
    final prefs = await _prefs();
    final ids = prefs.getStringList(_installedModelIdsKey) ?? const <String>[];
    return ids.toSet();
  }

  static Future<void> saveSelectedModelId(String? modelId) async {
    final prefs = await _prefs();
    if (modelId == null || modelId.isEmpty) {
      await prefs.remove(_selectedModelIdKey);
      return;
    }
    await prefs.setString(_selectedModelIdKey, modelId);
  }

  static Future<void> saveInstalledModelIds(Iterable<String> modelIds) async {
    final prefs = await _prefs();
    await prefs.setStringList(_installedModelIdsKey, modelIds.toSet().toList());
  }
}
