// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
      nameModel: json['name'] == null
          ? null
          : NameModel.fromJson(json['name'] as Map<String, dynamic>),
      addressModel: json['address'] == null
          ? null
          : AddressModel.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isEmailVerified': instance.isEmailVerified,
      'isActive': instance.isActive,
      'additionalData': instance.additionalData,
      'name': instance.nameModel,
      'address': instance.addressModel,
    };

NameModel _$NameModelFromJson(Map<String, dynamic> json) => NameModel(
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
    );

Map<String, dynamic> _$NameModelToJson(NameModel instance) => <String, dynamic>{
      'firstname': instance.firstname,
      'lastname': instance.lastname,
    };

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
      geolocation: GeolocationModel.fromJson(
          json['geolocation'] as Map<String, dynamic>),
      city: json['city'] as String,
      street: json['street'] as String,
      number: (json['number'] as num).toInt(),
      zipcode: json['zipcode'] as String,
    );

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'geolocation': instance.geolocation,
      'city': instance.city,
      'street': instance.street,
      'number': instance.number,
      'zipcode': instance.zipcode,
    };

GeolocationModel _$GeolocationModelFromJson(Map<String, dynamic> json) =>
    GeolocationModel(
      lat: json['lat'] as String,
      long: json['long'] as String,
    );

Map<String, dynamic> _$GeolocationModelToJson(GeolocationModel instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'long': instance.long,
    };
