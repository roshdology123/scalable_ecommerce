// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPreferencesModelAdapter extends TypeAdapter<UserPreferencesModel> {
  @override
  final int typeId = 5;

  @override
  UserPreferencesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPreferencesModel(
      userId: fields[0] as String,
      themeMode: fields[1] as ThemeMode,
      language: fields[2] as Language,
      pushNotificationsEnabled: fields[3] as bool,
      emailNotificationsEnabled: fields[4] as bool,
      smsNotificationsEnabled: fields[5] as bool,
      orderUpdates: fields[6] as NotificationFrequency,
      promotionalEmails: fields[7] as NotificationFrequency,
      newsletterSubscription: fields[8] as NotificationFrequency,
      biometricAuthEnabled: fields[9] as bool,
      twoFactorAuthEnabled: fields[10] as bool,
      shareDataForAnalytics: fields[11] as bool,
      shareDataForMarketing: fields[12] as bool,
      currency: fields[13] as String,
      timeZone: fields[14] as String,
      autoBackup: fields[15] as bool,
      updatedAt: fields[16] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserPreferencesModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.themeMode)
      ..writeByte(2)
      ..write(obj.language)
      ..writeByte(3)
      ..write(obj.pushNotificationsEnabled)
      ..writeByte(4)
      ..write(obj.emailNotificationsEnabled)
      ..writeByte(5)
      ..write(obj.smsNotificationsEnabled)
      ..writeByte(6)
      ..write(obj.orderUpdates)
      ..writeByte(7)
      ..write(obj.promotionalEmails)
      ..writeByte(8)
      ..write(obj.newsletterSubscription)
      ..writeByte(9)
      ..write(obj.biometricAuthEnabled)
      ..writeByte(10)
      ..write(obj.twoFactorAuthEnabled)
      ..writeByte(11)
      ..write(obj.shareDataForAnalytics)
      ..writeByte(12)
      ..write(obj.shareDataForMarketing)
      ..writeByte(13)
      ..write(obj.currency)
      ..writeByte(14)
      ..write(obj.timeZone)
      ..writeByte(15)
      ..write(obj.autoBackup)
      ..writeByte(16)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPreferencesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
