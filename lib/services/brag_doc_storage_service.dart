import 'package:hive/hive.dart';
import 'package:workjournel/models/brag_doc_record.dart';

class BragDocStorageService {
  static const String boxName = 'brag_docs';
  static const String _latestKey = 'latest';

  static Future<void> initialize() async {
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(BragDocRecordAdapter());
    }
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<BragDocRecord>(boxName);
    }
  }

  static Box<BragDocRecord> _box() {
    return Hive.box<BragDocRecord>(boxName);
  }

  static BragDocRecord? getLatest() {
    return _box().get(_latestKey);
  }

  static Future<void> upsert({
    required DateTime fromDate,
    required DateTime toDate,
    required String markdownContent,
    required String modelId,
  }) async {
    final start = DateTime(
      fromDate.year,
      fromDate.month,
      fromDate.day,
    ).millisecondsSinceEpoch;
    final end = DateTime(
      toDate.year,
      toDate.month,
      toDate.day,
    ).add(const Duration(days: 1)).millisecondsSinceEpoch;
    final now = DateTime.now().millisecondsSinceEpoch;
    final existing = _box().get(_latestKey);
    final record = BragDocRecord(
      timeframeKey: _latestKey,
      timeframeStartMillis: start,
      timeframeEndMillis: end,
      markdownContent: markdownContent,
      createdAtMillis: existing?.createdAtMillis ?? now,
      updatedAtMillis: now,
      modelId: modelId,
    );
    await _box().put(_latestKey, record);
  }
}
