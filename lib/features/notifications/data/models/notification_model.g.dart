// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationModelAdapter extends TypeAdapter<NotificationModel> {
  @override
  final int typeId = 3;

  @override
  NotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationModel(
      id: fields[0] as String,
      title: fields[1] as String,
      body: fields[2] as String,
      type: fields[3] as String,
      priority: fields[4] as String,
      data: (fields[5] as Map).cast<String, dynamic>(),
      createdAt: fields[6] as DateTime,
      userId: fields[7] as String,
      readAt: fields[8] as DateTime?,
      scheduledAt: fields[9] as DateTime?,
      isRead: fields[10] as bool,
      imageUrl: fields[11] as String?,
      actionUrl: fields[12] as String?,
      category: fields[13] as String?,
      tags: (fields[14] as List).cast<String>(),
      source: fields[15] as String?,
      isExpired: fields[16] as bool,
      expiresAt: fields[17] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.data)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.userId)
      ..writeByte(8)
      ..write(obj.readAt)
      ..writeByte(9)
      ..write(obj.scheduledAt)
      ..writeByte(10)
      ..write(obj.isRead)
      ..writeByte(11)
      ..write(obj.imageUrl)
      ..writeByte(12)
      ..write(obj.actionUrl)
      ..writeByte(13)
      ..write(obj.category)
      ..writeByte(14)
      ..write(obj.tags)
      ..writeByte(15)
      ..write(obj.source)
      ..writeByte(16)
      ..write(obj.isExpired)
      ..writeByte(17)
      ..write(obj.expiresAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String,
      priority: json['priority'] as String,
      data: json['data'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      userId: json['userId'] as String,
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      scheduledAt: json['scheduledAt'] == null
          ? null
          : DateTime.parse(json['scheduledAt'] as String),
      isRead: json['isRead'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
      actionUrl: json['actionUrl'] as String?,
      category: json['category'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      source: json['source'] as String?,
      isExpired: json['isExpired'] as bool? ?? false,
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$$NotificationModelImplToJson(
        _$NotificationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'type': instance.type,
      'priority': instance.priority,
      'data': instance.data,
      'createdAt': instance.createdAt.toIso8601String(),
      'userId': instance.userId,
      'readAt': instance.readAt?.toIso8601String(),
      'scheduledAt': instance.scheduledAt?.toIso8601String(),
      'isRead': instance.isRead,
      'imageUrl': instance.imageUrl,
      'actionUrl': instance.actionUrl,
      'category': instance.category,
      'tags': instance.tags,
      'source': instance.source,
      'isExpired': instance.isExpired,
      'expiresAt': instance.expiresAt?.toIso8601String(),
    };
