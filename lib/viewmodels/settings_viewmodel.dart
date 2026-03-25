class SettingsViewModel {
  static bool _preferGpu = true;
  static bool _localOnlyMode = true;
  static bool _autoDownloadOnWifi = false;

  bool get preferGpu => _preferGpu;
  bool get localOnlyMode => _localOnlyMode;
  bool get autoDownloadOnWifi => _autoDownloadOnWifi;

  void setPreferGpu(bool value) {
    _preferGpu = value;
  }

  void setLocalOnlyMode(bool value) {
    _localOnlyMode = value;
  }

  void setAutoDownloadOnWifi(bool value) {
    _autoDownloadOnWifi = value;
  }
}
