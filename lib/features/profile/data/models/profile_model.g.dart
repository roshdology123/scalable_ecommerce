// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileModelAdapter extends TypeAdapter<ProfileModel> {
  @override
  final int typeId = 4;

  @override
  ProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileModel(
      id: fields[0] as String,
      email: fields[1] as String,
      username: fields[2] as String,
      firstName: fields[3] as String,
      lastName: fields[4] as String,
      phone: fields[5] as String?,
      profileImageUrl: fields[6] as String?,
      bio: fields[7] as String?,
      dateOfBirth: fields[8] as DateTime?,
      gender: fields[9] as String?,
      address: fields[10] as AddressModel?,
      isEmailVerified: fields[11] as bool,
      isPhoneVerified: fields[12] as bool,
      createdAt: fields[13] as DateTime,
      updatedAt: fields[14] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileModel obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.username)
      ..writeByte(3)
      ..write(obj.firstName)
      ..writeByte(4)
      ..write(obj.lastName)
      ..writeByte(5)
      ..write(obj.phone)
      ..writeByte(6)
      ..write(obj.profileImageUrl)
      ..writeByte(7)
      ..write(obj.bio)
      ..writeByte(8)
      ..write(obj.dateOfBirth)
      ..writeByte(9)
      ..write(obj.gender)
      ..writeByte(10)
      ..write(obj.address)
      ..writeByte(11)
      ..write(obj.isEmailVerified)
      ..writeByte(12)
      ..write(obj.isPhoneVerified)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AddressModelAdapter extends TypeAdapter<AddressModel> {
  @override
  final int typeId = 7;

  @override
  AddressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddressModel(
      street: fields[0] as String?,
      number: fields[1] as String?,
      city: fields[2] as String?,
      zipcode: fields[3] as String?,
      geolocation: fields[4] as GeolocationModel?,
    );
  }

  @override
  void write(BinaryWriter writer, AddressModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.street)
      ..writeByte(1)
      ..write(obj.number)
      ..writeByte(2)
      ..write(obj.city)
      ..writeByte(3)
      ..write(obj.zipcode)
      ..writeByte(4)
      ..write(obj.geolocation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GeolocationModelAdapter extends TypeAdapter<GeolocationModel> {
  @override
  final int typeId = 8;

  @override
  GeolocationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GeolocationModel(
      lat: fields[0] as String,
      long: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GeolocationModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.long);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeolocationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
