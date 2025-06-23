// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotificationPreferencesModelAdapter
    extends TypeAdapter<NotificationPreferencesModel> {
  @override
  final int typeId = 4;

  @override
  NotificationPreferencesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationPreferencesModel(
      userId: fields[0] as String,
      pushNotificationsEnabled: fields[1] as bool,
      emailNotificationsEnabled: fields[2] as bool,
      smsNotificationsEnabled: fields[3] as bool,
      orderUpdatesEnabled: fields[4] as bool,
      promotionsEnabled: fields[5] as bool,
      cartAbandonmentEnabled: fields[6] as bool,
      priceAlertsEnabled: fields[7] as bool,
      stockAlertsEnabled: fields[8] as bool,
      newProductsEnabled: fields[9] as bool,
      orderUpdatesFrequency: fields[10] as String,
      promotionsFrequency: fields[11] as String,
      newsletterFrequency: fields[12] as String,
      quietHoursEnabled: fields[13] as bool,
      quietHoursStart: fields[14] as String,
      quietHoursEnd: fields[15] as String,
      subscribedTopics: (fields[16] as List).cast<String>(),
      mutedCategories: (fields[17] as List).cast<String>(),
      soundPreference: fields[18] as String,
      vibrationPreference: fields[19] as String,
      showOnLockScreen: fields[20] as bool,
      showPreview: fields[21] as bool,
      lastUpdated: fields[22] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationPreferencesModel obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.pushNotificationsEnabled)
      ..writeByte(2)
      ..write(obj.emailNotificationsEnabled)
      ..writeByte(3)
      ..write(obj.smsNotificationsEnabled)
      ..writeByte(4)
      ..write(obj.orderUpdatesEnabled)
      ..writeByte(5)
      ..write(obj.promotionsEnabled)
      ..writeByte(6)
      ..write(obj.cartAbandonmentEnabled)
      ..writeByte(7)
      ..write(obj.priceAlertsEnabled)
      ..writeByte(8)
      ..write(obj.stockAlertsEnabled)
      ..writeByte(9)
      ..write(obj.newProductsEnabled)
      ..writeByte(10)
      ..write(obj.orderUpdatesFrequency)
      ..writeByte(11)
      ..write(obj.promotionsFrequency)
      ..writeByte(12)
      ..write(obj.newsletterFrequency)
      ..writeByte(13)
      ..write(obj.quietHoursEnabled)
      ..writeByte(14)
      ..write(obj.quietHoursStart)
      ..writeByte(15)
      ..write(obj.quietHoursEnd)
      ..writeByte(16)
      ..write(obj.subscribedTopics)
      ..writeByte(17)
      ..write(obj.mutedCategories)
      ..writeByte(18)
      ..write(obj.soundPreference)
      ..writeByte(19)
      ..write(obj.vibrationPreference)
      ..writeByte(20)
      ..write(obj.showOnLockScreen)
      ..writeByte(21)
      ..write(obj.showPreview)
      ..writeByte(22)
      ..write(obj.lastUpdated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationPreferencesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationPreferencesModelImpl _$$NotificationPreferencesModelImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationPreferencesModelImpl(
      userId: json['userId'] as String,
      pushNotificationsEnabled:
          json['pushNotificationsEnabled'] as bool? ?? true,
      emailNotificationsEnabled:
          json['emailNotificationsEnabled'] as bool? ?? true,
      smsNotificationsEnabled:
          json['smsNotificationsEnabled'] as bool? ?? false,
      orderUpdatesEnabled: json['orderUpdatesEnabled'] as bool? ?? true,
      promotionsEnabled: json['promotionsEnabled'] as bool? ?? true,
      cartAbandonmentEnabled: json['cartAbandonmentEnabled'] as bool? ?? true,
      priceAlertsEnabled: json['priceAlertsEnabled'] as bool? ?? true,
      stockAlertsEnabled: json['stockAlertsEnabled'] as bool? ?? true,
      newProductsEnabled: json['newProductsEnabled'] as bool? ?? true,
      orderUpdatesFrequency:
          json['orderUpdatesFrequency'] as String? ?? 'immediately',
      promotionsFrequency: json['promotionsFrequency'] as String? ?? 'daily',
      newsletterFrequency: json['newsletterFrequency'] as String? ?? 'weekly',
      quietHoursEnabled: json['quietHoursEnabled'] as bool? ?? false,
      quietHoursStart: json['quietHoursStart'] as String? ?? '22:00',
      quietHoursEnd: json['quietHoursEnd'] as String? ?? '08:00',
      subscribedTopics: (json['subscribedTopics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      mutedCategories: (json['mutedCategories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      soundPreference: json['soundPreference'] as String? ?? 'all',
      vibrationPreference: json['vibrationPreference'] as String? ?? 'all',
      showOnLockScreen: json['showOnLockScreen'] as bool? ?? true,
      showPreview: json['showPreview'] as bool? ?? true,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$NotificationPreferencesModelImplToJson(
        _$NotificationPreferencesModelImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'pushNotificationsEnabled': instance.pushNotificationsEnabled,
      'emailNotificationsEnabled': instance.emailNotificationsEnabled,
      'smsNotificationsEnabled': instance.smsNotificationsEnabled,
      'orderUpdatesEnabled': instance.orderUpdatesEnabled,
      'promotionsEnabled': instance.promotionsEnabled,
      'cartAbandonmentEnabled': instance.cartAbandonmentEnabled,
      'priceAlertsEnabled': instance.priceAlertsEnabled,
      'stockAlertsEnabled': instance.stockAlertsEnabled,
      'newProductsEnabled': instance.newProductsEnabled,
      'orderUpdatesFrequency': instance.orderUpdatesFrequency,
      'promotionsFrequency': instance.promotionsFrequency,
      'newsletterFrequency': instance.newsletterFrequency,
      'quietHoursEnabled': instance.quietHoursEnabled,
      'quietHoursStart': instance.quietHoursStart,
      'quietHoursEnd': instance.quietHoursEnd,
      'subscribedTopics': instance.subscribedTopics,
      'mutedCategories': instance.mutedCategories,
      'soundPreference': instance.soundPreference,
      'vibrationPreference': instance.vibrationPreference,
      'showOnLockScreen': instance.showOnLockScreen,
      'showPreview': instance.showPreview,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };
