import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/profile.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
@HiveType(typeId: 4)
class ProfileModel with _$ProfileModel {
  const factory ProfileModel({
    @HiveField(0) required String id,
    @HiveField(1) required String email,
    @HiveField(2) required String username,
    @HiveField(3) required String firstName,
    @HiveField(4) required String lastName,
    @HiveField(5) String? phone,
    @HiveField(6) String? profileImageUrl,
    @HiveField(7) String? bio,
    @HiveField(8) DateTime? dateOfBirth,
    @HiveField(9) String? gender,
    @HiveField(10) AddressModel? address,
    @HiveField(11) @Default(false) bool isEmailVerified,
    @HiveField(12) @Default(false) bool isPhoneVerified,
    @HiveField(13) required DateTime createdAt,
    @HiveField(14) required DateTime updatedAt,
  }) = _ProfileModel;

  // Factory from FakeStoreAPI User response
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final now = DateTime.parse('2025-06-22 08:11:58');

    return ProfileModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      firstName: _extractFirstName(json),
      lastName: _extractLastName(json),
      phone: json['phone']?.toString(),
      profileImageUrl: _generateProfileImage(json['username']?.toString() ?? ''),
      bio: json['bio']?.toString(),
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.tryParse(json['dateOfBirth'].toString())
          : null,
      gender: json['gender']?.toString(),
      address: json['address'] != null
          ? AddressModel.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isPhoneVerified: json['isPhoneVerified'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : now,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'].toString())
          : now,
    );
  }


  // Factory for roshdology123 user (current user with correct timestamp)
  factory ProfileModel.roshdology123() {
    final now = DateTime.parse('2025-06-22 08:11:58');

    return ProfileModel(
      id: '11', // Next available ID after existing FakeStore users
      email: 'roshdology123@example.com',
      username: 'roshdology123',
      firstName: 'Ahmed',
      lastName: 'Hassan',
      phone: '+20-12-3456-7890',
      profileImageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
      bio: 'Passionate about e-commerce and discovering new products. Love shopping and tech innovations.',
      dateOfBirth: DateTime(1990, 5, 15),
      gender: 'male',
      address: AddressModel.cairo(),
      isEmailVerified: true,
      isPhoneVerified: false,
      createdAt: now.subtract(const Duration(days: 365)), // Member for 1 year
      updatedAt: now,
    );
  }

  static String _extractFirstName(Map<String, dynamic> json) {
    // FakeStoreAPI has name object with firstname and lastname
    if (json['name'] != null) {
      return json['name']['firstname']?.toString() ?? '';
    }
    return json['firstname']?.toString() ?? json['firstName']?.toString() ?? '';
  }

  static String _extractLastName(Map<String, dynamic> json) {
    // FakeStoreAPI has name object with firstname and lastname
    if (json['name'] != null) {
      return json['name']['lastname']?.toString() ?? '';
    }
    return json['lastname']?.toString() ?? json['lastName']?.toString() ?? '';
  }

  static String _generateProfileImage(String username) {
    // Generate consistent profile images based on username
    final imageMap = {
      'mor_2314': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      'kevinryan': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
      'donero': 'https://images.unsplash.com/photo-1494790108755-2616b332c5f5?w=400',
      'derek': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
      'david_r': 'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?w=400',
      'roshdology123': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=400',
    };

    return imageMap[username] ?? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400';
  }

  factory ProfileModel.fromProfile(Profile profile) {
      return ProfileModel(
        id: profile.id,
        email: profile.email,
        username: profile.fullName,
        firstName: profile.firstName,
        lastName: profile.lastName,
        phone: profile.phoneNumber,
        profileImageUrl: profile.profileImageUrl,
        bio: profile.bio,
        dateOfBirth: profile.dateOfBirth,
        gender: profile.gender,
        address: profile.address != null || profile.city != null
            ? AddressModel(
                street: profile.address,
                city: profile.city,
                zipcode: profile.postalCode,
              )
            : null,
        isEmailVerified: profile.isEmailVerified,
        isPhoneVerified: profile.isPhoneVerified,
        createdAt: profile.createdAt,
        updatedAt: profile.updatedAt,
      );
    }
}

@freezed
@HiveType(typeId: 7)
class AddressModel with _$AddressModel {
  const factory AddressModel({
    @HiveField(0) String? street,
    @HiveField(1) String? number,
    @HiveField(2) String? city,
    @HiveField(3) String? zipcode,
    @HiveField(4) GeolocationModel? geolocation,
  }) = _AddressModel;

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      street: json['street']?.toString(),
      number: json['number']?.toString(),
      city: json['city']?.toString(),
      zipcode: json['zipcode']?.toString(),
      geolocation: json['geolocation'] != null
          ? GeolocationModel.fromJson(json['geolocation'] as Map<String, dynamic>)
          : null,
    );
  }

  // Factory for Cairo address (roshdology123)
  factory AddressModel.cairo() {
    return const AddressModel(
      street: 'El Tahrir Square',
      number: '123',
      city: 'Cairo',
      zipcode: '11511',
      geolocation: GeolocationModel(
        lat: '30.0444',
        long: '31.2357',
      ),
    );
  }


}

@freezed
@HiveType(typeId: 8)
class GeolocationModel with _$GeolocationModel {
  const factory GeolocationModel({
    @HiveField(0) required String lat,
    @HiveField(1) required String long,
  }) = _GeolocationModel;

  factory GeolocationModel.fromJson(Map<String, dynamic> json) {
    return GeolocationModel(
      lat: json['lat']?.toString() ?? '0',
      long: json['long']?.toString() ?? '0',
    );
  }

}

// Extension for ProfileModel
extension ProfileModelExtension on ProfileModel {
  Profile toProfile() {
    return Profile(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phone,
      profileImageUrl: profileImageUrl,
      bio: bio,
      dateOfBirth: dateOfBirth,
      gender: gender,
      address: _formatAddress(),
      city: address?.city,
      country: _getCountryFromCity(address?.city),
      postalCode: address?.zipcode,
      isEmailVerified: isEmailVerified,
      isPhoneVerified: isPhoneVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  String? _formatAddress() {
    if (address == null) return null;
    final parts = <String>[];
    if (address!.number != null) parts.add(address!.number!);
    if (address!.street != null) parts.add(address!.street!);
    return parts.isEmpty ? null : parts.join(' ');
  }

  String? _getCountryFromCity(String? city) {
    final cityCountryMap = {
      'cairo': 'Egypt',
      'kilcoole': 'Ireland',
      'san antonio': 'USA',
      'el paso': 'USA',
      'minneapolis': 'USA',
    };

    return cityCountryMap[city?.toLowerCase()] ?? 'Unknown';
  }

  // Convert to FakeStoreAPI format for updates
  Map<String, dynamic> toFakeStoreJson() {
    return {
      'email': email,
      'username': username,
      'password': 'password123',
      'name': {
        'firstname': firstName,
        'lastname': lastName,
      },
      'address': {
        'street': address?.street,
        'number': address?.number,
        'city': address?.city,
        'zipcode': address?.zipcode,
        'geolocation': {
          'lat': address?.geolocation?.lat ?? '0',
          'long': address?.geolocation?.long ?? '0',
        },
      },
      'phone': phone,
    };
  }

  String get fullName => '$firstName $lastName';

  String get initials {
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  bool get hasCompleteProfile {
    return firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        phone != null &&
        phone!.isNotEmpty &&
        address != null;
  }
}