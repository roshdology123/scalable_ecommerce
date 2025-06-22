import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? profileImageUrl;
  final String? bio;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? address;
  final String? city;
  final String? country;
  final String? postalCode;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Profile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.profileImageUrl,
    this.bio,
    this.dateOfBirth,
    this.gender,
    this.address,
    this.city,
    this.country,
    this.postalCode,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get full name combining first and last name
  String get fullName => '$firstName $lastName'.trim();

  /// Get initials from first and last name
  String get initials {
    final firstInitial = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstInitial$lastInitial';
  }

  /// Check if profile has complete essential information
  bool get hasCompleteProfile {
    return firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        phoneNumber != null &&
        phoneNumber!.isNotEmpty &&
        address != null &&
        address!.isNotEmpty;
  }

  /// Check if user has verified contact information
  bool get hasVerifiedContact {
    return isEmailVerified || isPhoneVerified;
  }

  /// Get profile completion percentage
  double get profileCompletionPercentage {
    int completedFields = 0;
    int totalFields = 10;

    if (firstName.isNotEmpty) completedFields++;
    if (lastName.isNotEmpty) completedFields++;
    if (phoneNumber != null && phoneNumber!.isNotEmpty) completedFields++;
    if (profileImageUrl != null && profileImageUrl!.isNotEmpty) completedFields++;
    if (bio != null && bio!.isNotEmpty) completedFields++;
    if (dateOfBirth != null) completedFields++;
    if (gender != null && gender!.isNotEmpty) completedFields++;
    if (address != null && address!.isNotEmpty) completedFields++;
    if (city != null && city!.isNotEmpty) completedFields++;
    if (postalCode != null && postalCode!.isNotEmpty) completedFields++;

    return (completedFields / totalFields) * 100;
  }

  /// Get age from date of birth
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.parse('2025-06-22 08:17:00');
    final age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      return age - 1;
    }
    return age;
  }

  /// Get formatted address string
  String? get formattedAddress {
    final addressParts = <String>[];

    if (address != null && address!.isNotEmpty) {
      addressParts.add(address!);
    }
    if (city != null && city!.isNotEmpty) {
      addressParts.add(city!);
    }
    if (country != null && country!.isNotEmpty) {
      addressParts.add(country!);
    }
    if (postalCode != null && postalCode!.isNotEmpty) {
      addressParts.add(postalCode!);
    }

    return addressParts.isEmpty ? null : addressParts.join(', ');
  }

  /// Get membership duration in days
  int get membershipDurationInDays {
    final now = DateTime.parse('2025-06-22 08:17:00');
    return now.difference(createdAt).inDays;
  }

  /// Get formatted membership duration
  String get membershipDuration {
    final days = membershipDurationInDays;

    if (days < 30) {
      return '$days day${days == 1 ? '' : 's'}';
    } else if (days < 365) {
      final months = (days / 30).floor();
      return '$months month${months == 1 ? '' : 's'}';
    } else {
      final years = (days / 365).floor();
      return '$years year${years == 1 ? '' : 's'}';
    }
  }

  /// Check if profile was recently updated (within last 7 days)
  bool get isRecentlyUpdated {
    final now = DateTime.parse('2025-06-22 08:17:00');
    final daysSinceUpdate = now.difference(updatedAt).inDays;
    return daysSinceUpdate <= 7;
  }

  /// Create a copy of profile with updated fields
  Profile copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? profileImageUrl,
    String? bio,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    String? city,
    String? country,
    String? postalCode,
    bool? isEmailVerified,
    bool? isPhoneVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Profile(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPhoneVerified: isPhoneVerified ?? this.isPhoneVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.parse('2025-06-22 08:17:00'),
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    phoneNumber,
    profileImageUrl,
    bio,
    dateOfBirth,
    gender,
    address,
    city,
    country,
    postalCode,
    isEmailVerified,
    isPhoneVerified,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() => 'Profile(id: $id, email: $email, name: $fullName, completion: ${profileCompletionPercentage.toStringAsFixed(1)}%)';
}