import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
  @JsonKey(name: 'name')
  final NameModel? nameModel;

  @JsonKey(name: 'address')
  final AddressModel? addressModel;

  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    required super.firstName,
    required super.lastName,
    super.phone,
    super.avatar,
    super.createdAt,
    super.updatedAt,
    super.isEmailVerified,
    super.isActive,
    super.additionalData,
    this.nameModel,
    this.addressModel,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle Fake Store API response format
    String firstName = '';
    String lastName = '';

    if (json['name'] != null) {
      if (json['name'] is Map) {
        // API returns: {"name": {"firstname": "john", "lastname": "doe"}}
        final nameData = json['name'] as Map<String, dynamic>;
        firstName = nameData['firstname']?.toString() ?? '';
        lastName = nameData['lastname']?.toString() ?? '';
      } else if (json['name'] is String) {
        // Fallback for string name
        final nameParts = (json['name'] as String).split(' ');
        firstName = nameParts.isNotEmpty ? nameParts.first : '';
        lastName = nameParts.length > 1 ? nameParts.last : '';
      }
    }

    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      username: json['username'] as String,
      firstName: firstName,
      lastName: lastName,
      phone: json['phone'] as String?,
      avatar: json['avatar'] as String?,
      nameModel: json['name'] != null && json['name'] is Map
          ? NameModel.fromJson(json['name'] as Map<String, dynamic>)
          : null,
      addressModel: json['address'] != null
          ? AddressModel.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      additionalData: {
        if (json['address'] != null) 'address': json['address'],
        if (json['__v'] != null) '__v': json['__v'],
      },
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'id': id,
      'email': email,
      'username': username,
      'phone': phone,
      'name': {
        'firstname': firstName,
        'lastname': lastName,
      },
    };

    if (addressModel != null) {
      json['address'] = addressModel!.toJson();
    }

    return json;
  }

  factory UserModel.fromUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      username: user.username,
      firstName: user.firstName,
      lastName: user.lastName,
      phone: user.phone,
      avatar: user.avatar,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
      isEmailVerified: user.isEmailVerified,
      isActive: user.isActive,
      additionalData: user.additionalData,
    );
  }
}

@JsonSerializable()
class NameModel {
  final String firstname;
  final String lastname;

  const NameModel({
    required this.firstname,
    required this.lastname,
  });

  factory NameModel.fromJson(Map<String, dynamic> json) =>
      _$NameModelFromJson(json);

  Map<String, dynamic> toJson() => _$NameModelToJson(this);
}

@JsonSerializable()
class AddressModel {
  final GeolocationModel geolocation;
  final String city;
  final String street;
  final int number;
  final String zipcode;

  const AddressModel({
    required this.geolocation,
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}

@JsonSerializable()
class GeolocationModel {
  final String lat;
  final String long;

  const GeolocationModel({
    required this.lat,
    required this.long,
  });

  factory GeolocationModel.fromJson(Map<String, dynamic> json) =>
      _$GeolocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeolocationModelToJson(this);
}