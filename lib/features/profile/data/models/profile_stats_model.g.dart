// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_stats_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileStatsModelAdapter extends TypeAdapter<ProfileStatsModel> {
  @override
  final int typeId = 6;

  @override
  ProfileStatsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileStatsModel(
      userId: fields[0] as String,
      totalOrders: fields[1] as int,
      completedOrders: fields[2] as int,
      cancelledOrders: fields[3] as int,
      totalSpent: fields[4] as double,
      totalReviews: fields[5] as int,
      averageRating: fields[6] as double,
      favoritesCount: fields[7] as int,
      wishlistItems: fields[8] as int,
      memberSince: fields[9] as DateTime,
      loyaltyPoints: fields[10] as int,
      membershipTier: fields[11] as String,
      lastOrderDate: fields[12] as DateTime,
      lastLoginDate: fields[13] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileStatsModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.totalOrders)
      ..writeByte(2)
      ..write(obj.completedOrders)
      ..writeByte(3)
      ..write(obj.cancelledOrders)
      ..writeByte(4)
      ..write(obj.totalSpent)
      ..writeByte(5)
      ..write(obj.totalReviews)
      ..writeByte(6)
      ..write(obj.averageRating)
      ..writeByte(7)
      ..write(obj.favoritesCount)
      ..writeByte(8)
      ..write(obj.wishlistItems)
      ..writeByte(9)
      ..write(obj.memberSince)
      ..writeByte(10)
      ..write(obj.loyaltyPoints)
      ..writeByte(11)
      ..write(obj.membershipTier)
      ..writeByte(12)
      ..write(obj.lastOrderDate)
      ..writeByte(13)
      ..write(obj.lastLoginDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileStatsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
