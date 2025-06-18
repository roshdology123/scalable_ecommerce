// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemModelAdapter extends TypeAdapter<CartItemModel> {
  @override
  final int typeId = 10;

  @override
  CartItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemModel(
      id: fields[0] as String,
      productId: fields[1] as int,
      productTitle: fields[2] as String,
      productImage: fields[3] as String,
      price: fields[4] as double,
      originalPrice: fields[5] as double,
      quantity: fields[6] as int,
      maxQuantity: fields[7] as int,
      selectedColor: fields[8] as String?,
      selectedSize: fields[9] as String?,
      selectedVariants: (fields[10] as Map).cast<String, String>(),
      isAvailable: fields[11] as bool,
      inStock: fields[12] as bool,
      brand: fields[13] as String?,
      category: fields[14] as String?,
      sku: fields[15] as String?,
      discountPercentage: fields[16] as double?,
      discountAmount: fields[17] as double?,
      addedAt: fields[18] as DateTime,
      updatedAt: fields[19] as DateTime?,
      lastPriceCheck: fields[20] as DateTime?,
      priceChanged: fields[21] as bool,
      previousPrice: fields[22] as double?,
      isSelected: fields[23] as bool,
      specialOfferId: fields[24] as String?,
      metadata: (fields[25] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, CartItemModel obj) {
    writer
      ..writeByte(26)
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
      ..write(obj.quantity)
      ..writeByte(7)
      ..write(obj.maxQuantity)
      ..writeByte(8)
      ..write(obj.selectedColor)
      ..writeByte(9)
      ..write(obj.selectedSize)
      ..writeByte(10)
      ..write(obj.selectedVariants)
      ..writeByte(11)
      ..write(obj.isAvailable)
      ..writeByte(12)
      ..write(obj.inStock)
      ..writeByte(13)
      ..write(obj.brand)
      ..writeByte(14)
      ..write(obj.category)
      ..writeByte(15)
      ..write(obj.sku)
      ..writeByte(16)
      ..write(obj.discountPercentage)
      ..writeByte(17)
      ..write(obj.discountAmount)
      ..writeByte(18)
      ..write(obj.addedAt)
      ..writeByte(19)
      ..write(obj.updatedAt)
      ..writeByte(20)
      ..write(obj.lastPriceCheck)
      ..writeByte(21)
      ..write(obj.priceChanged)
      ..writeByte(22)
      ..write(obj.previousPrice)
      ..writeByte(23)
      ..write(obj.isSelected)
      ..writeByte(24)
      ..write(obj.specialOfferId)
      ..writeByte(25)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
