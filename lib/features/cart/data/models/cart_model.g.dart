// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartModelAdapter extends TypeAdapter<CartModel> {
  @override
  final int typeId = 12;

  @override
  CartModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartModel(
      id: fields[0] as String,
      userId: fields[1] as String?,
      items: (fields[2] as List).cast<CartItemModel>(),
      summary: fields[3] as CartSummaryModel,
      createdAt: fields[4] as DateTime,
      updatedAt: fields[5] as DateTime,
      lastSyncedAt: fields[6] as DateTime?,
      isSynced: fields[7] as bool,
      hasPendingChanges: fields[8] as bool,
      status: fields[9] as String,
      sessionId: fields[10] as String?,
      appliedCoupons: (fields[11] as Map?)?.cast<String, String>(),
      shippingAddress: fields[12] as String?,
      billingAddress: fields[13] as String?,
      metadata: (fields[14] as Map?)?.cast<String, dynamic>(),
      abandonedAt: fields[15] as DateTime?,
      version: fields[16] as int,
      conflictingFields: (fields[17] as List?)?.cast<String>(),
      expiresAt: fields[18] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, CartModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.items)
      ..writeByte(3)
      ..write(obj.summary)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.lastSyncedAt)
      ..writeByte(7)
      ..write(obj.isSynced)
      ..writeByte(8)
      ..write(obj.hasPendingChanges)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.sessionId)
      ..writeByte(11)
      ..write(obj.appliedCoupons)
      ..writeByte(12)
      ..write(obj.shippingAddress)
      ..writeByte(13)
      ..write(obj.billingAddress)
      ..writeByte(14)
      ..write(obj.metadata)
      ..writeByte(15)
      ..write(obj.abandonedAt)
      ..writeByte(16)
      ..write(obj.version)
      ..writeByte(17)
      ..write(obj.conflictingFields)
      ..writeByte(18)
      ..write(obj.expiresAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
