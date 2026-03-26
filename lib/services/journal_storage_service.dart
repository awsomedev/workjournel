import 'package:hive/hive.dart';
import 'package:workjournel/models/journal_entry_record.dart';

class JournalStorageService {
  static const String boxName = 'journal_entries';

  static Future<void> initialize() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(JournalEntryRecordAdapter());
    }
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<JournalEntryRecord>(boxName);
    }
  }

  static Box<JournalEntryRecord> _box() {
    return Hive.box<JournalEntryRecord>(boxName);
  }

  static Future<void> saveEntry(JournalEntryRecord entry) async {
    await _box().put(entry.id, entry);
  }

  static List<JournalEntryRecord> getEntries() {
    final entries = _box().values.toList(growable: false);
    entries.sort((a, b) => b.createdAtMillis.compareTo(a.createdAtMillis));
    return entries;
  }

  static List<JournalEntryRecord> getEntriesByDate(DateTime date) {
    final start = _startOfDay(date);
    final end = start.add(const Duration(days: 1));
    return _box()
        .values
        .where(
          (entry) =>
              entry.createdAtMillis >= start.millisecondsSinceEpoch &&
              entry.createdAtMillis < end.millisecondsSinceEpoch,
        )
        .toList(growable: false)
      ..sort((a, b) => b.createdAtMillis.compareTo(a.createdAtMillis));
  }

  static List<JournalEntryRecord> getEntriesByDateRange(
    DateTime start,
    DateTime end,
  ) {
    final normalizedStart = _startOfDay(start);
    final normalizedEnd = _startOfDay(end).add(const Duration(days: 1));
    return _box()
        .values
        .where(
          (entry) =>
              entry.createdAtMillis >= normalizedStart.millisecondsSinceEpoch &&
              entry.createdAtMillis < normalizedEnd.millisecondsSinceEpoch,
        )
        .toList(growable: false)
      ..sort((a, b) => b.createdAtMillis.compareTo(a.createdAtMillis));
  }

  static Future<void> deleteEntry(String id) async {
    await _box().delete(id);
  }

  static Stream<BoxEvent> watch() {
    return _box().watch();
  }

  static DateTime _startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
