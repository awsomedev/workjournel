import 'package:workjournel/models/journal_entry_record.dart';

class LogEntry {
  final String id;
  final String title;
  final String subtitle;
  final String body;
  final List<String> tags;
  final int createdAtMillis;

  const LogEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.tags,
    required this.createdAtMillis,
  });

  String get date {
    final createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtMillis);
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final startOfCreated = DateTime(
      createdAt.year,
      createdAt.month,
      createdAt.day,
    );
    final dayDiff = startOfToday.difference(startOfCreated).inDays;
    final time = _formatTime(createdAt);
    if (dayDiff == 0) {
      return 'Today, $time';
    }
    if (dayDiff == 1) {
      return 'Yesterday, $time';
    }
    return '${_monthLabel(createdAt.month)} ${createdAt.day}, $time';
  }

  factory LogEntry.fromRecord(JournalEntryRecord record) {
    return LogEntry(
      id: record.id,
      title: record.title,
      subtitle: record.subtitle,
      body: record.body,
      tags: record.tags,
      createdAtMillis: record.createdAtMillis,
    );
  }

  static String _monthLabel(int month) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  static String _formatTime(DateTime dateTime) {
    final hour24 = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour24 >= 12 ? 'PM' : 'AM';
    var hour12 = hour24 % 12;
    if (hour12 == 0) {
      hour12 = 12;
    }
    return '$hour12:$minute $period';
  }
}
