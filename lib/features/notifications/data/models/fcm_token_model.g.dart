// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_token_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FCMTokenModelAdapter extends TypeAdapter<FCMTokenModel> {
  @override
  final int typeId = 5;

  @override
  FCMTokenModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FCMTokenModel(
      token: fields[0] as String,
      userId: fields[1] as String,
      deviceId: fields[2] as String,
      platform: fields[3] as String,
      createdAt: fields[4] as DateTime,
      lastUpdated: fields[5] as DateTime,
      isActive: fields[6] as bool,
      appVersion: fields[7] as String?,
      deviceModel: fields[8] as String?,
      osVersion: fields[9] as String?,
      subscribedTopics: (fields[10] as List).cast<String>(),
      lastSyncedAt: fields[11] as DateTime?,
      needsSync: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FCMTokenModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.token)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.deviceId)
      ..writeByte(3)
      ..write(obj.platform)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.lastUpdated)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.appVersion)
      ..writeByte(8)
      ..write(obj.deviceModel)
      ..writeByte(9)
      ..write(obj.osVersion)
      ..writeByte(10)
      ..write(obj.subscribedTopics)
      ..writeByte(11)
      ..write(obj.lastSyncedAt)
      ..writeByte(12)
      ..write(obj.needsSync);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FCMTokenModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FCMTokenModelImpl _$$FCMTokenModelImplFromJson(Map<String, dynamic> json) =>
    _$FCMTokenModelImpl(
      token: json['token'] as String,
      userId: json['userId'] as String,
      deviceId: json['deviceId'] as String,
      platform: json['platform'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      isActive: json['isActive'] as bool? ?? true,
      appVersion: json['appVersion'] as String?,
      deviceModel: json['deviceModel'] as String?,
      osVersion: json['osVersion'] as String?,
      subscribedTopics: (json['subscribedTopics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      lastSyncedAt: json['lastSyncedAt'] == null
          ? null
          : DateTime.parse(json['lastSyncedAt'] as String),
      needsSync: json['needsSync'] as bool? ?? false,
    );

Map<String, dynamic> _$$FCMTokenModelImplToJson(_$FCMTokenModelImpl instance) =>
    <String, dynamic>{
      'token': instance.token,
      'userId': instance.userId,
      'deviceId': instance.deviceId,
      'platform': instance.platform,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'isActive': instance.isActive,
      'appVersion': instance.appVersion,
      'deviceModel': instance.deviceModel,
      'osVersion': instance.osVersion,
      'subscribedTopics': instance.subscribedTopics,
      'lastSyncedAt': instance.lastSyncedAt?.toIso8601String(),
      'needsSync': instance.needsSync,
    };
