// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_collection_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoritesCollectionModelAdapter
    extends TypeAdapter<FavoritesCollectionModel> {
  @override
  final int typeId = 21;

  @override
  FavoritesCollectionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoritesCollectionModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      icon: fields[3] as String?,
      color: fields[4] as String?,
      productIds: (fields[5] as List).cast<String>(),
      isDefault: fields[6] as bool,
      isSmartCollection: fields[7] as bool,
      smartRules: (fields[8] as Map?)?.cast<String, dynamic>(),
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime,
      isPublic: fields[11] as bool,
      shareToken: fields[12] as String?,
      sortOrder: fields[13] as int,
      tags: (fields[14] as Map).cast<String, String>(),
      metadata: (fields[15] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, FavoritesCollectionModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.color)
      ..writeByte(5)
      ..write(obj.productIds)
      ..writeByte(6)
      ..write(obj.isDefault)
      ..writeByte(7)
      ..write(obj.isSmartCollection)
      ..writeByte(8)
      ..write(obj.smartRules)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt)
      ..writeByte(11)
      ..write(obj.isPublic)
      ..writeByte(12)
      ..write(obj.shareToken)
      ..writeByte(13)
      ..write(obj.sortOrder)
      ..writeByte(14)
      ..write(obj.tags)
      ..writeByte(15)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritesCollectionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
