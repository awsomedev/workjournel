import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:workjournel/models/log_entry.dart';
import 'package:workjournel/services/journal_storage_service.dart';

class LogsViewModel extends ChangeNotifier {
  LogEntry? _selectedLog;
  List<LogEntry> _logs = const [];
  StreamSubscription<dynamic>? _watchSubscription;
  bool _isInitialized = false;

  LogEntry? get selectedLog => _selectedLog;
  bool get hasSelection => _selectedLog != null;
  List<LogEntry> get logs => List.unmodifiable(_logs);

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }
    _isInitialized = true;
    await refresh();
    _watchSubscription = JournalStorageService.watch().listen((_) {
      refresh();
    });
  }

  Future<void> refresh() async {
    final records = JournalStorageService.getEntries();
    _logs = records.map(LogEntry.fromRecord).toList(growable: false);
    if (_selectedLog != null &&
        _logs.indexWhere((log) => log.id == _selectedLog!.id) < 0) {
      _selectedLog = null;
    }
    notifyListeners();
  }

  void selectLog(LogEntry log) {
    _selectedLog = log;
    notifyListeners();
  }

  void clearSelection() {
    _selectedLog = null;
    notifyListeners();
  }

  Future<void> deleteLog(String id) async {
    await JournalStorageService.deleteEntry(id);
  }

  @override
  void dispose() {
    _watchSubscription?.cancel();
    super.dispose();
  }
}
