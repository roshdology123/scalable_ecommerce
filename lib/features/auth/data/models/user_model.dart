import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/user.dart';


part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends User {
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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle Fake Store API response format
    if (json.containsKey('name')) {
      final nameParts = (json['name'] as String).split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : '';
      final lastName = nameParts.length > 1 ? nameParts.last : '';

      return UserModel(
        id: json['id'] as int,
        email: json['email'] as String,
        username: json['username'] as String,
        firstName: firstName,
        lastName: lastName,
        phone: json['phone'] as String?,
        avatar: json['avatar'] as String?,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'] as String)
            : null,
        isEmailVerified: json['isEmailVerified'] as bool? ?? false,
        isActive: json['isActive'] as bool? ?? true,
        additionalData: json['additionalData'] as Map<String, dynamic>?,
      );
    }

    return _$UserModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

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

  UserModel copyWith({
    int? id,
    String? email,
    String? username,
    String? firstName,
    String? lastName,
    String? phone,
    String? avatar,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEmailVerified,
    bool? isActive,
    Map<String, dynamic>? additionalData,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isActive: isActive ?? this.isActive,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}