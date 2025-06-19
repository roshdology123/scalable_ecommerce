// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteItemModelAdapter extends TypeAdapter<FavoriteItemModel> {
  @override
  final int typeId = 20;

  @override
  FavoriteItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteItemModel(
      id: fields[0] as String,
      productId: fields[1] as int,
      productTitle: fields[2] as String,
      productImage: fields[3] as String,
      price: fields[4] as double,
      originalPrice: fields[5] as double?,
      category: fields[6] as String,
      brand: fields[7] as String?,
      rating: fields[8] as double,
      isAvailable: fields[9] as bool,
      inStock: fields[10] as bool,
      addedAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime?,
      priceUpdatedAt: fields[13] as DateTime?,
      previousPrice: fields[14] as double?,
      priceDropped: fields[15] as bool,
      collectionId: fields[16] as String?,
      tags: (fields[17] as Map).cast<String, String>(),
      viewCount: fields[18] as int,
      lastViewedAt: fields[19] as DateTime?,
      isPriceTrackingEnabled: fields[20] as bool,
      targetPrice: fields[21] as double?,
      notes: fields[22] as String?,
      metadata: (fields[23] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteItemModel obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.productId)
      ..writeByte(2)
      ..write(obj.productTitle)
      ..writeByte(3)
      ..write(obj.productImage)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.originalPrice)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.brand)
      ..writeByte(8)
      ..write(obj.rating)
      ..writeByte(9)
      ..write(obj.isAvailable)
      ..writeByte(10)
      ..write(obj.inStock)
      ..writeByte(11)
      ..write(obj.addedAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.priceUpdatedAt)
      ..writeByte(14)
      ..write(obj.previousPrice)
      ..writeByte(15)
      ..write(obj.priceDropped)
      ..writeByte(16)
      ..write(obj.collectionId)
      ..writeByte(17)
      ..write(obj.tags)
      ..writeByte(18)
      ..write(obj.viewCount)
      ..writeByte(19)
      ..write(obj.lastViewedAt)
      ..writeByte(20)
      ..write(obj.isPriceTrackingEnabled)
      ..writeByte(21)
      ..write(obj.targetPrice)
      ..writeByte(22)
      ..write(obj.notes)
      ..writeByte(23)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
