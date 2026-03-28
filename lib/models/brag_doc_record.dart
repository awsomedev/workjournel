import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class BragDocRecord {
  @HiveField(0)
  final String timeframeKey;

  @HiveField(1)
  final int timeframeStartMillis;

  @HiveField(2)
  final int timeframeEndMillis;

  @HiveField(3)
  final String markdownContent;

  @HiveField(4)
  final int createdAtMillis;

  @HiveField(5)
  final int updatedAtMillis;

  @HiveField(6)
  final String modelId;

  const BragDocRecord({
    required this.timeframeKey,
    required this.timeframeStartMillis,
    required this.timeframeEndMillis,
    required this.markdownContent,
    required this.createdAtMillis,
    required this.updatedAtMillis,
    required this.modelId,
  });
}

class BragDocRecordAdapter extends TypeAdapter<BragDocRecord> {
  @override
  final int typeId = 2;

  @override
  BragDocRecord read(BinaryReader reader) {
    final fieldCount = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < fieldCount; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return BragDocRecord(
      timeframeKey: fields[0] as String,
      timeframeStartMillis: fields[1] as int,
      timeframeEndMillis: fields[2] as int,
      markdownContent: fields[3] as String,
      createdAtMillis: fields[4] as int,
      updatedAtMillis: fields[5] as int,
      modelId: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BragDocRecord obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.timeframeKey)
      ..writeByte(1)
      ..write(obj.timeframeStartMillis)
      ..writeByte(2)
      ..write(obj.timeframeEndMillis)
      ..writeByte(3)
      ..write(obj.markdownContent)
      ..writeByte(4)
      ..write(obj.createdAtMillis)
      ..writeByte(5)
      ..write(obj.updatedAtMillis)
      ..writeByte(6)
      ..write(obj.modelId);
  }
}
