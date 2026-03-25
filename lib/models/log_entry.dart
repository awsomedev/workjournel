class LogEntry {
  final String id;
  final String title;
  final String subtitle;
  final String date;
  final String body;
  final List<String> tags;

  const LogEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.body,
    required this.tags,
  });
}
