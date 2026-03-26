import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class JournalEntryRecord {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String subtitle;

  @HiveField(3)
  final String body;

  @HiveField(4)
  final List<String> tags;

  @HiveField(5)
  final int createdAtMillis;

  const JournalEntryRecord({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.tags,
    required this.createdAtMillis,
  });
}

class JournalEntryRecordAdapter extends TypeAdapter<JournalEntryRecord> {
  @override
  final int typeId = 1;

  @override
  JournalEntryRecord read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < fieldCount; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return JournalEntryRecord(
      id: fields[0] as String,
      title: fields[1] as String,
      subtitle: fields[2] as String,
      body: fields[3] as String,
      tags: (fields[4] as List).cast<String>(),
      createdAtMillis: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntryRecord obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.subtitle)
      ..writeByte(3)
      ..write(obj.body)
      ..writeByte(4)
      ..write(obj.tags)
      ..writeByte(5)
      ..write(obj.createdAtMillis);
  }
}
