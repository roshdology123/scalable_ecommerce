// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ProfileModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get email => throw _privateConstructorUsedError;
  @HiveField(2)
  String get username => throw _privateConstructorUsedError;
  @HiveField(3)
  String get firstName => throw _privateConstructorUsedError;
  @HiveField(4)
  String get lastName => throw _privateConstructorUsedError;
  @HiveField(5)
  String? get phone => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get profileImageUrl => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get bio => throw _privateConstructorUsedError;
  @HiveField(8)
  DateTime? get dateOfBirth => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get gender => throw _privateConstructorUsedError;
  @HiveField(10)
  AddressModel? get address => throw _privateConstructorUsedError;
  @HiveField(11)
  bool get isEmailVerified => throw _privateConstructorUsedError;
  @HiveField(12)
  bool get isPhoneVerified => throw _privateConstructorUsedError;
  @HiveField(13)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(14)
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileModelCopyWith<ProfileModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileModelCopyWith<$Res> {
  factory $ProfileModelCopyWith(
          ProfileModel value, $Res Function(ProfileModel) then) =
      _$ProfileModelCopyWithImpl<$Res, ProfileModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String email,
      @HiveField(2) String username,
      @HiveField(3) String firstName,
      @HiveField(4) String lastName,
      @HiveField(5) String? phone,
      @HiveField(6) String? profileImageUrl,
      @HiveField(7) String? bio,
      @HiveField(8) DateTime? dateOfBirth,
      @HiveField(9) String? gender,
      @HiveField(10) AddressModel? address,
      @HiveField(11) bool isEmailVerified,
      @HiveField(12) bool isPhoneVerified,
      @HiveField(13) DateTime createdAt,
      @HiveField(14) DateTime updatedAt});

  $AddressModelCopyWith<$Res>? get address;
}

/// @nodoc
class _$ProfileModelCopyWithImpl<$Res, $Val extends ProfileModel>
    implements $ProfileModelCopyWith<$Res> {
  _$ProfileModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = freezed,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? address = freezed,
    Object? isEmailVerified = null,
    Object? isPhoneVerified = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isPhoneVerified: null == isPhoneVerified
          ? _value.isPhoneVerified
          : isPhoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AddressModelCopyWith<$Res>? get address {
    if (_value.address == null) {
      return null;
    }

    return $AddressModelCopyWith<$Res>(_value.address!, (value) {
      return _then(_value.copyWith(address: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProfileModelImplCopyWith<$Res>
    implements $ProfileModelCopyWith<$Res> {
  factory _$$ProfileModelImplCopyWith(
          _$ProfileModelImpl value, $Res Function(_$ProfileModelImpl) then) =
      __$$ProfileModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String email,
      @HiveField(2) String username,
      @HiveField(3) String firstName,
      @HiveField(4) String lastName,
      @HiveField(5) String? phone,
      @HiveField(6) String? profileImageUrl,
      @HiveField(7) String? bio,
      @HiveField(8) DateTime? dateOfBirth,
      @HiveField(9) String? gender,
      @HiveField(10) AddressModel? address,
      @HiveField(11) bool isEmailVerified,
      @HiveField(12) bool isPhoneVerified,
      @HiveField(13) DateTime createdAt,
      @HiveField(14) DateTime updatedAt});

  @override
  $AddressModelCopyWith<$Res>? get address;
}

/// @nodoc
class __$$ProfileModelImplCopyWithImpl<$Res>
    extends _$ProfileModelCopyWithImpl<$Res, _$ProfileModelImpl>
    implements _$$ProfileModelImplCopyWith<$Res> {
  __$$ProfileModelImplCopyWithImpl(
      _$ProfileModelImpl _value, $Res Function(_$ProfileModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? firstName = null,
    Object? lastName = null,
    Object? phone = freezed,
    Object? profileImageUrl = freezed,
    Object? bio = freezed,
    Object? dateOfBirth = freezed,
    Object? gender = freezed,
    Object? address = freezed,
    Object? isEmailVerified = null,
    Object? isPhoneVerified = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ProfileModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      bio: freezed == bio
          ? _value.bio
          : bio // ignore: cast_nullable_to_non_nullable
              as String?,
      dateOfBirth: freezed == dateOfBirth
          ? _value.dateOfBirth
          : dateOfBirth // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      gender: freezed == gender
          ? _value.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as AddressModel?,
      isEmailVerified: null == isEmailVerified
          ? _value.isEmailVerified
          : isEmailVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      isPhoneVerified: null == isPhoneVerified
          ? _value.isPhoneVerified
          : isPhoneVerified // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$ProfileModelImpl implements _ProfileModel {
  const _$ProfileModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.email,
      @HiveField(2) required this.username,
      @HiveField(3) required this.firstName,
      @HiveField(4) required this.lastName,
      @HiveField(5) this.phone,
      @HiveField(6) this.profileImageUrl,
      @HiveField(7) this.bio,
      @HiveField(8) this.dateOfBirth,
      @HiveField(9) this.gender,
      @HiveField(10) this.address,
      @HiveField(11) this.isEmailVerified = false,
      @HiveField(12) this.isPhoneVerified = false,
      @HiveField(13) required this.createdAt,
      @HiveField(14) required this.updatedAt});

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String email;
  @override
  @HiveField(2)
  final String username;
  @override
  @HiveField(3)
  final String firstName;
  @override
  @HiveField(4)
  final String lastName;
  @override
  @HiveField(5)
  final String? phone;
  @override
  @HiveField(6)
  final String? profileImageUrl;
  @override
  @HiveField(7)
  final String? bio;
  @override
  @HiveField(8)
  final DateTime? dateOfBirth;
  @override
  @HiveField(9)
  final String? gender;
  @override
  @HiveField(10)
  final AddressModel? address;
  @override
  @JsonKey()
  @HiveField(11)
  final bool isEmailVerified;
  @override
  @JsonKey()
  @HiveField(12)
  final bool isPhoneVerified;
  @override
  @HiveField(13)
  final DateTime createdAt;
  @override
  @HiveField(14)
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ProfileModel(id: $id, email: $email, username: $username, firstName: $firstName, lastName: $lastName, phone: $phone, profileImageUrl: $profileImageUrl, bio: $bio, dateOfBirth: $dateOfBirth, gender: $gender, address: $address, isEmailVerified: $isEmailVerified, isPhoneVerified: $isPhoneVerified, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.dateOfBirth, dateOfBirth) ||
                other.dateOfBirth == dateOfBirth) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.isEmailVerified, isEmailVerified) ||
                other.isEmailVerified == isEmailVerified) &&
            (identical(other.isPhoneVerified, isPhoneVerified) ||
                other.isPhoneVerified == isPhoneVerified) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      email,
      username,
      firstName,
      lastName,
      phone,
      profileImageUrl,
      bio,
      dateOfBirth,
      gender,
      address,
      isEmailVerified,
      isPhoneVerified,
      createdAt,
      updatedAt);

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileModelImplCopyWith<_$ProfileModelImpl> get copyWith =>
      __$$ProfileModelImplCopyWithImpl<_$ProfileModelImpl>(this, _$identity);
}

abstract class _ProfileModel implements ProfileModel {
  const factory _ProfileModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String email,
      @HiveField(2) required final String username,
      @HiveField(3) required final String firstName,
      @HiveField(4) required final String lastName,
      @HiveField(5) final String? phone,
      @HiveField(6) final String? profileImageUrl,
      @HiveField(7) final String? bio,
      @HiveField(8) final DateTime? dateOfBirth,
      @HiveField(9) final String? gender,
      @HiveField(10) final AddressModel? address,
      @HiveField(11) final bool isEmailVerified,
      @HiveField(12) final bool isPhoneVerified,
      @HiveField(13) required final DateTime createdAt,
      @HiveField(14) required final DateTime updatedAt}) = _$ProfileModelImpl;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get email;
  @override
  @HiveField(2)
  String get username;
  @override
  @HiveField(3)
  String get firstName;
  @override
  @HiveField(4)
  String get lastName;
  @override
  @HiveField(5)
  String? get phone;
  @override
  @HiveField(6)
  String? get profileImageUrl;
  @override
  @HiveField(7)
  String? get bio;
  @override
  @HiveField(8)
  DateTime? get dateOfBirth;
  @override
  @HiveField(9)
  String? get gender;
  @override
  @HiveField(10)
  AddressModel? get address;
  @override
  @HiveField(11)
  bool get isEmailVerified;
  @override
  @HiveField(12)
  bool get isPhoneVerified;
  @override
  @HiveField(13)
  DateTime get createdAt;
  @override
  @HiveField(14)
  DateTime get updatedAt;

  /// Create a copy of ProfileModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileModelImplCopyWith<_$ProfileModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AddressModel {
  @HiveField(0)
  String? get street => throw _privateConstructorUsedError;
  @HiveField(1)
  String? get number => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get city => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get zipcode => throw _privateConstructorUsedError;
  @HiveField(4)
  GeolocationModel? get geolocation => throw _privateConstructorUsedError;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AddressModelCopyWith<AddressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressModelCopyWith<$Res> {
  factory $AddressModelCopyWith(
          AddressModel value, $Res Function(AddressModel) then) =
      _$AddressModelCopyWithImpl<$Res, AddressModel>;
  @useResult
  $Res call(
      {@HiveField(0) String? street,
      @HiveField(1) String? number,
      @HiveField(2) String? city,
      @HiveField(3) String? zipcode,
      @HiveField(4) GeolocationModel? geolocation});

  $GeolocationModelCopyWith<$Res>? get geolocation;
}

/// @nodoc
class _$AddressModelCopyWithImpl<$Res, $Val extends AddressModel>
    implements $AddressModelCopyWith<$Res> {
  _$AddressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? street = freezed,
    Object? number = freezed,
    Object? city = freezed,
    Object? zipcode = freezed,
    Object? geolocation = freezed,
  }) {
    return _then(_value.copyWith(
      street: freezed == street
          ? _value.street
          : street // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      zipcode: freezed == zipcode
          ? _value.zipcode
          : zipcode // ignore: cast_nullable_to_non_nullable
              as String?,
      geolocation: freezed == geolocation
          ? _value.geolocation
          : geolocation // ignore: cast_nullable_to_non_nullable
              as GeolocationModel?,
    ) as $Val);
  }

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeolocationModelCopyWith<$Res>? get geolocation {
    if (_value.geolocation == null) {
      return null;
    }

    return $GeolocationModelCopyWith<$Res>(_value.geolocation!, (value) {
      return _then(_value.copyWith(geolocation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AddressModelImplCopyWith<$Res>
    implements $AddressModelCopyWith<$Res> {
  factory _$$AddressModelImplCopyWith(
          _$AddressModelImpl value, $Res Function(_$AddressModelImpl) then) =
      __$$AddressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String? street,
      @HiveField(1) String? number,
      @HiveField(2) String? city,
      @HiveField(3) String? zipcode,
      @HiveField(4) GeolocationModel? geolocation});

  @override
  $GeolocationModelCopyWith<$Res>? get geolocation;
}

/// @nodoc
class __$$AddressModelImplCopyWithImpl<$Res>
    extends _$AddressModelCopyWithImpl<$Res, _$AddressModelImpl>
    implements _$$AddressModelImplCopyWith<$Res> {
  __$$AddressModelImplCopyWithImpl(
      _$AddressModelImpl _value, $Res Function(_$AddressModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? street = freezed,
    Object? number = freezed,
    Object? city = freezed,
    Object? zipcode = freezed,
    Object? geolocation = freezed,
  }) {
    return _then(_$AddressModelImpl(
      street: freezed == street
          ? _value.street
          : street // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      zipcode: freezed == zipcode
          ? _value.zipcode
          : zipcode // ignore: cast_nullable_to_non_nullable
              as String?,
      geolocation: freezed == geolocation
          ? _value.geolocation
          : geolocation // ignore: cast_nullable_to_non_nullable
              as GeolocationModel?,
    ));
  }
}

/// @nodoc

class _$AddressModelImpl implements _AddressModel {
  const _$AddressModelImpl(
      {@HiveField(0) this.street,
      @HiveField(1) this.number,
      @HiveField(2) this.city,
      @HiveField(3) this.zipcode,
      @HiveField(4) this.geolocation});

  @override
  @HiveField(0)
  final String? street;
  @override
  @HiveField(1)
  final String? number;
  @override
  @HiveField(2)
  final String? city;
  @override
  @HiveField(3)
  final String? zipcode;
  @override
  @HiveField(4)
  final GeolocationModel? geolocation;

  @override
  String toString() {
    return 'AddressModel(street: $street, number: $number, city: $city, zipcode: $zipcode, geolocation: $geolocation)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressModelImpl &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.zipcode, zipcode) || other.zipcode == zipcode) &&
            (identical(other.geolocation, geolocation) ||
                other.geolocation == geolocation));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, street, number, city, zipcode, geolocation);

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressModelImplCopyWith<_$AddressModelImpl> get copyWith =>
      __$$AddressModelImplCopyWithImpl<_$AddressModelImpl>(this, _$identity);
}

abstract class _AddressModel implements AddressModel {
  const factory _AddressModel(
      {@HiveField(0) final String? street,
      @HiveField(1) final String? number,
      @HiveField(2) final String? city,
      @HiveField(3) final String? zipcode,
      @HiveField(4) final GeolocationModel? geolocation}) = _$AddressModelImpl;

  @override
  @HiveField(0)
  String? get street;
  @override
  @HiveField(1)
  String? get number;
  @override
  @HiveField(2)
  String? get city;
  @override
  @HiveField(3)
  String? get zipcode;
  @override
  @HiveField(4)
  GeolocationModel? get geolocation;

  /// Create a copy of AddressModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddressModelImplCopyWith<_$AddressModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GeolocationModel {
  @HiveField(0)
  String get lat => throw _privateConstructorUsedError;
  @HiveField(1)
  String get long => throw _privateConstructorUsedError;

  /// Create a copy of GeolocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeolocationModelCopyWith<GeolocationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeolocationModelCopyWith<$Res> {
  factory $GeolocationModelCopyWith(
          GeolocationModel value, $Res Function(GeolocationModel) then) =
      _$GeolocationModelCopyWithImpl<$Res, GeolocationModel>;
  @useResult
  $Res call({@HiveField(0) String lat, @HiveField(1) String long});
}

/// @nodoc
class _$GeolocationModelCopyWithImpl<$Res, $Val extends GeolocationModel>
    implements $GeolocationModelCopyWith<$Res> {
  _$GeolocationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeolocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? long = null,
  }) {
    return _then(_value.copyWith(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as String,
      long: null == long
          ? _value.long
          : long // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GeolocationModelImplCopyWith<$Res>
    implements $GeolocationModelCopyWith<$Res> {
  factory _$$GeolocationModelImplCopyWith(_$GeolocationModelImpl value,
          $Res Function(_$GeolocationModelImpl) then) =
      __$$GeolocationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@HiveField(0) String lat, @HiveField(1) String long});
}

/// @nodoc
class __$$GeolocationModelImplCopyWithImpl<$Res>
    extends _$GeolocationModelCopyWithImpl<$Res, _$GeolocationModelImpl>
    implements _$$GeolocationModelImplCopyWith<$Res> {
  __$$GeolocationModelImplCopyWithImpl(_$GeolocationModelImpl _value,
      $Res Function(_$GeolocationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of GeolocationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lat = null,
    Object? long = null,
  }) {
    return _then(_$GeolocationModelImpl(
      lat: null == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as String,
      long: null == long
          ? _value.long
          : long // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$GeolocationModelImpl implements _GeolocationModel {
  const _$GeolocationModelImpl(
      {@HiveField(0) required this.lat, @HiveField(1) required this.long});

  @override
  @HiveField(0)
  final String lat;
  @override
  @HiveField(1)
  final String long;

  @override
  String toString() {
    return 'GeolocationModel(lat: $lat, long: $long)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeolocationModelImpl &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.long, long) || other.long == long));
  }

  @override
  int get hashCode => Object.hash(runtimeType, lat, long);

  /// Create a copy of GeolocationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeolocationModelImplCopyWith<_$GeolocationModelImpl> get copyWith =>
      __$$GeolocationModelImplCopyWithImpl<_$GeolocationModelImpl>(
          this, _$identity);
}

abstract class _GeolocationModel implements GeolocationModel {
  const factory _GeolocationModel(
      {@HiveField(0) required final String lat,
      @HiveField(1) required final String long}) = _$GeolocationModelImpl;

  @override
  @HiveField(0)
  String get lat;
  @override
  @HiveField(1)
  String get long;

  /// Create a copy of GeolocationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeolocationModelImplCopyWith<_$GeolocationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
