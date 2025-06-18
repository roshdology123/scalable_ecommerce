// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_summary_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartSummaryModelAdapter extends TypeAdapter<CartSummaryModel> {
  @override
  final int typeId = 11;

  @override
  CartSummaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartSummaryModel(
      subtotal: fields[0] as double,
      totalDiscount: fields[1] as double,
      totalTax: fields[2] as double,
      shippingCost: fields[3] as double,
      total: fields[4] as double,
      totalItems: fields[5] as int,
      totalQuantity: fields[6] as int,
      appliedCouponCode: fields[7] as String?,
      couponDiscount: fields[8] as double?,
      couponDescription: fields[9] as String?,
      selectedShippingMethod: fields[10] as String?,
      shippingMethodDescription: fields[11] as String?,
      estimatedDeliveryDays: fields[12] as double?,
      taxRate: fields[13] as double,
      isFreeShipping: fields[14] as bool,
      freeShippingThreshold: fields[15] as double?,
      amountToFreeShipping: fields[16] as double?,
      taxBreakdown: (fields[17] as Map?)?.cast<String, double>(),
      discountBreakdown: (fields[18] as Map?)?.cast<String, double>(),
      lastCalculated: fields[19] as DateTime?,
      currency: fields[20] as String?,
      currencyCode: fields[21] as String,
      metadata: (fields[22] as Map?)?.cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, CartSummaryModel obj) {
    writer
      ..writeByte(23)
      ..writeByte(0)
      ..write(obj.subtotal)
      ..writeByte(1)
      ..write(obj.totalDiscount)
      ..writeByte(2)
      ..write(obj.totalTax)
      ..writeByte(3)
      ..write(obj.shippingCost)
      ..writeByte(4)
      ..write(obj.total)
      ..writeByte(5)
      ..write(obj.totalItems)
      ..writeByte(6)
      ..write(obj.totalQuantity)
      ..writeByte(7)
      ..write(obj.appliedCouponCode)
      ..writeByte(8)
      ..write(obj.couponDiscount)
      ..writeByte(9)
      ..write(obj.couponDescription)
      ..writeByte(10)
      ..write(obj.selectedShippingMethod)
      ..writeByte(11)
      ..write(obj.shippingMethodDescription)
      ..writeByte(12)
      ..write(obj.estimatedDeliveryDays)
      ..writeByte(13)
      ..write(obj.taxRate)
      ..writeByte(14)
      ..write(obj.isFreeShipping)
      ..writeByte(15)
      ..write(obj.freeShippingThreshold)
      ..writeByte(16)
      ..write(obj.amountToFreeShipping)
      ..writeByte(17)
      ..write(obj.taxBreakdown)
      ..writeByte(18)
      ..write(obj.discountBreakdown)
      ..writeByte(19)
      ..write(obj.lastCalculated)
      ..writeByte(20)
      ..write(obj.currency)
      ..writeByte(21)
      ..write(obj.currencyCode)
      ..writeByte(22)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartSummaryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
