// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_preferences_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserPreferencesModel {
  @HiveField(0)
  String get userId => throw _privateConstructorUsedError;
  @HiveField(1)
  ThemeMode get themeMode => throw _privateConstructorUsedError;
  @HiveField(2)
  Language get language => throw _privateConstructorUsedError;
  @HiveField(3)
  bool get pushNotificationsEnabled => throw _privateConstructorUsedError;
  @HiveField(4)
  bool get emailNotificationsEnabled => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get smsNotificationsEnabled => throw _privateConstructorUsedError;
  @HiveField(6)
  NotificationFrequency get orderUpdates => throw _privateConstructorUsedError;
  @HiveField(7)
  NotificationFrequency get promotionalEmails =>
      throw _privateConstructorUsedError;
  @HiveField(8)
  NotificationFrequency get newsletterSubscription =>
      throw _privateConstructorUsedError;
  @HiveField(9)
  bool get biometricAuthEnabled => throw _privateConstructorUsedError;
  @HiveField(10)
  bool get twoFactorAuthEnabled => throw _privateConstructorUsedError;
  @HiveField(11)
  bool get shareDataForAnalytics => throw _privateConstructorUsedError;
  @HiveField(12)
  bool get shareDataForMarketing => throw _privateConstructorUsedError;
  @HiveField(13)
  String get currency => throw _privateConstructorUsedError;
  @HiveField(14)
  String get timeZone => throw _privateConstructorUsedError;
  @HiveField(15)
  bool get autoBackup => throw _privateConstructorUsedError;
  @HiveField(16)
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Create a copy of UserPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserPreferencesModelCopyWith<UserPreferencesModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserPreferencesModelCopyWith<$Res> {
  factory $UserPreferencesModelCopyWith(UserPreferencesModel value,
          $Res Function(UserPreferencesModel) then) =
      _$UserPreferencesModelCopyWithImpl<$Res, UserPreferencesModel>;
  @useResult
  $Res call(
      {@HiveField(0) String userId,
      @HiveField(1) ThemeMode themeMode,
      @HiveField(2) Language language,
      @HiveField(3) bool pushNotificationsEnabled,
      @HiveField(4) bool emailNotificationsEnabled,
      @HiveField(5) bool smsNotificationsEnabled,
      @HiveField(6) NotificationFrequency orderUpdates,
      @HiveField(7) NotificationFrequency promotionalEmails,
      @HiveField(8) NotificationFrequency newsletterSubscription,
      @HiveField(9) bool biometricAuthEnabled,
      @HiveField(10) bool twoFactorAuthEnabled,
      @HiveField(11) bool shareDataForAnalytics,
      @HiveField(12) bool shareDataForMarketing,
      @HiveField(13) String currency,
      @HiveField(14) String timeZone,
      @HiveField(15) bool autoBackup,
      @HiveField(16) DateTime updatedAt});
}

/// @nodoc
class _$UserPreferencesModelCopyWithImpl<$Res,
        $Val extends UserPreferencesModel>
    implements $UserPreferencesModelCopyWith<$Res> {
  _$UserPreferencesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? themeMode = null,
    Object? language = null,
    Object? pushNotificationsEnabled = null,
    Object? emailNotificationsEnabled = null,
    Object? smsNotificationsEnabled = null,
    Object? orderUpdates = null,
    Object? promotionalEmails = null,
    Object? newsletterSubscription = null,
    Object? biometricAuthEnabled = null,
    Object? twoFactorAuthEnabled = null,
    Object? shareDataForAnalytics = null,
    Object? shareDataForMarketing = null,
    Object? currency = null,
    Object? timeZone = null,
    Object? autoBackup = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as Language,
      pushNotificationsEnabled: null == pushNotificationsEnabled
          ? _value.pushNotificationsEnabled
          : pushNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailNotificationsEnabled: null == emailNotificationsEnabled
          ? _value.emailNotificationsEnabled
          : emailNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      smsNotificationsEnabled: null == smsNotificationsEnabled
          ? _value.smsNotificationsEnabled
          : smsNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      orderUpdates: null == orderUpdates
          ? _value.orderUpdates
          : orderUpdates // ignore: cast_nullable_to_non_nullable
              as NotificationFrequency,
      promotionalEmails: null == promotionalEmails
          ? _value.promotionalEmails
          : promotionalEmails // ignore: cast_nullable_to_non_nullable
              as NotificationFrequency,
      newsletterSubscription: null == newsletterSubscription
          ? _value.newsletterSubscription
          : newsletterSubscription // ignore: cast_nullable_to_non_nullable
              as NotificationFrequency,
      biometricAuthEnabled: null == biometricAuthEnabled
          ? _value.biometricAuthEnabled
          : biometricAuthEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      twoFactorAuthEnabled: null == twoFactorAuthEnabled
          ? _value.twoFactorAuthEnabled
          : twoFactorAuthEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      shareDataForAnalytics: null == shareDataForAnalytics
          ? _value.shareDataForAnalytics
          : shareDataForAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
      shareDataForMarketing: null == shareDataForMarketing
          ? _value.shareDataForMarketing
          : shareDataForMarketing // ignore: cast_nullable_to_non_nullable
              as bool,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      timeZone: null == timeZone
          ? _value.timeZone
          : timeZone // ignore: cast_nullable_to_non_nullable
              as String,
      autoBackup: null == autoBackup
          ? _value.autoBackup
          : autoBackup // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserPreferencesModelImplCopyWith<$Res>
    implements $UserPreferencesModelCopyWith<$Res> {
  factory _$$UserPreferencesModelImplCopyWith(_$UserPreferencesModelImpl value,
          $Res Function(_$UserPreferencesModelImpl) then) =
      __$$UserPreferencesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String userId,
      @HiveField(1) ThemeMode themeMode,
      @HiveField(2) Language language,
      @HiveField(3) bool pushNotificationsEnabled,
      @HiveField(4) bool emailNotificationsEnabled,
      @HiveField(5) bool smsNotificationsEnabled,
      @HiveField(6) NotificationFrequency orderUpdates,
      @HiveField(7) NotificationFrequency promotionalEmails,
      @HiveField(8) NotificationFrequency newsletterSubscription,
      @HiveField(9) bool biometricAuthEnabled,
      @HiveField(10) bool twoFactorAuthEnabled,
      @HiveField(11) bool shareDataForAnalytics,
      @HiveField(12) bool shareDataForMarketing,
      @HiveField(13) String currency,
      @HiveField(14) String timeZone,
      @HiveField(15) bool autoBackup,
      @HiveField(16) DateTime updatedAt});
}

/// @nodoc
class __$$UserPreferencesModelImplCopyWithImpl<$Res>
    extends _$UserPreferencesModelCopyWithImpl<$Res, _$UserPreferencesModelImpl>
    implements _$$UserPreferencesModelImplCopyWith<$Res> {
  __$$UserPreferencesModelImplCopyWithImpl(_$UserPreferencesModelImpl _value,
      $Res Function(_$UserPreferencesModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? themeMode = null,
    Object? language = null,
    Object? pushNotificationsEnabled = null,
    Object? emailNotificationsEnabled = null,
    Object? smsNotificationsEnabled = null,
    Object? orderUpdates = null,
    Object? promotionalEmails = null,
    Object? newsletterSubscription = null,
    Object? biometricAuthEnabled = null,
    Object? twoFactorAuthEnabled = null,
    Object? shareDataForAnalytics = null,
    Object? shareDataForMarketing = null,
    Object? currency = null,
    Object? timeZone = null,
    Object? autoBackup = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UserPreferencesModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      themeMode: null == themeMode
          ? _value.themeMode
          : themeMode // ignore: cast_nullable_to_non_nullable
              as ThemeMode,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as Language,
      pushNotificationsEnabled: null == pushNotificationsEnabled
          ? _value.pushNotificationsEnabled
          : pushNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      emailNotificationsEnabled: null == emailNotificationsEnabled
          ? _value.emailNotificationsEnabled
          : emailNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      smsNotificationsEnabled: null == smsNotificationsEnabled
          ? _value.smsNotificationsEnabled
          : smsNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      orderUpdates: null == orderUpdates
          ? _value.orderUpdates
          : orderUpdates // ignore: cast_nullable_to_non_nullable
              as NotificationFrequency,
      promotionalEmails: null == promotionalEmails
          ? _value.promotionalEmails
          : promotionalEmails // ignore: cast_nullable_to_non_nullable
              as NotificationFrequency,
      newsletterSubscription: null == newsletterSubscription
          ? _value.newsletterSubscription
          : newsletterSubscription // ignore: cast_nullable_to_non_nullable
              as NotificationFrequency,
      biometricAuthEnabled: null == biometricAuthEnabled
          ? _value.biometricAuthEnabled
          : biometricAuthEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      twoFactorAuthEnabled: null == twoFactorAuthEnabled
          ? _value.twoFactorAuthEnabled
          : twoFactorAuthEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      shareDataForAnalytics: null == shareDataForAnalytics
          ? _value.shareDataForAnalytics
          : shareDataForAnalytics // ignore: cast_nullable_to_non_nullable
              as bool,
      shareDataForMarketing: null == shareDataForMarketing
          ? _value.shareDataForMarketing
          : shareDataForMarketing // ignore: cast_nullable_to_non_nullable
              as bool,
      currency: null == currency
          ? _value.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      timeZone: null == timeZone
          ? _value.timeZone
          : timeZone // ignore: cast_nullable_to_non_nullable
              as String,
      autoBackup: null == autoBackup
          ? _value.autoBackup
          : autoBackup // ignore: cast_nullable_to_non_nullable
              as bool,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$UserPreferencesModelImpl implements _UserPreferencesModel {
  const _$UserPreferencesModelImpl(
      {@HiveField(0) required this.userId,
      @HiveField(1) this.themeMode = ThemeMode.system,
      @HiveField(2) this.language = Language.english,
      @HiveField(3) this.pushNotificationsEnabled = true,
      @HiveField(4) this.emailNotificationsEnabled = true,
      @HiveField(5) this.smsNotificationsEnabled = false,
      @HiveField(6) this.orderUpdates = NotificationFrequency.instant,
      @HiveField(7) this.promotionalEmails = NotificationFrequency.weekly,
      @HiveField(8) this.newsletterSubscription = NotificationFrequency.weekly,
      @HiveField(9) this.biometricAuthEnabled = false,
      @HiveField(10) this.twoFactorAuthEnabled = false,
      @HiveField(11) this.shareDataForAnalytics = true,
      @HiveField(12) this.shareDataForMarketing = false,
      @HiveField(13) this.currency = 'USD',
      @HiveField(14) this.timeZone = 'UTC',
      @HiveField(15) this.autoBackup = true,
      @HiveField(16) required this.updatedAt});

  @override
  @HiveField(0)
  final String userId;
  @override
  @JsonKey()
  @HiveField(1)
  final ThemeMode themeMode;
  @override
  @JsonKey()
  @HiveField(2)
  final Language language;
  @override
  @JsonKey()
  @HiveField(3)
  final bool pushNotificationsEnabled;
  @override
  @JsonKey()
  @HiveField(4)
  final bool emailNotificationsEnabled;
  @override
  @JsonKey()
  @HiveField(5)
  final bool smsNotificationsEnabled;
  @override
  @JsonKey()
  @HiveField(6)
  final NotificationFrequency orderUpdates;
  @override
  @JsonKey()
  @HiveField(7)
  final NotificationFrequency promotionalEmails;
  @override
  @JsonKey()
  @HiveField(8)
  final NotificationFrequency newsletterSubscription;
  @override
  @JsonKey()
  @HiveField(9)
  final bool biometricAuthEnabled;
  @override
  @JsonKey()
  @HiveField(10)
  final bool twoFactorAuthEnabled;
  @override
  @JsonKey()
  @HiveField(11)
  final bool shareDataForAnalytics;
  @override
  @JsonKey()
  @HiveField(12)
  final bool shareDataForMarketing;
  @override
  @JsonKey()
  @HiveField(13)
  final String currency;
  @override
  @JsonKey()
  @HiveField(14)
  final String timeZone;
  @override
  @JsonKey()
  @HiveField(15)
  final bool autoBackup;
  @override
  @HiveField(16)
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserPreferencesModel(userId: $userId, themeMode: $themeMode, language: $language, pushNotificationsEnabled: $pushNotificationsEnabled, emailNotificationsEnabled: $emailNotificationsEnabled, smsNotificationsEnabled: $smsNotificationsEnabled, orderUpdates: $orderUpdates, promotionalEmails: $promotionalEmails, newsletterSubscription: $newsletterSubscription, biometricAuthEnabled: $biometricAuthEnabled, twoFactorAuthEnabled: $twoFactorAuthEnabled, shareDataForAnalytics: $shareDataForAnalytics, shareDataForMarketing: $shareDataForMarketing, currency: $currency, timeZone: $timeZone, autoBackup: $autoBackup, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserPreferencesModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(
                    other.pushNotificationsEnabled, pushNotificationsEnabled) ||
                other.pushNotificationsEnabled == pushNotificationsEnabled) &&
            (identical(other.emailNotificationsEnabled,
                    emailNotificationsEnabled) ||
                other.emailNotificationsEnabled == emailNotificationsEnabled) &&
            (identical(
                    other.smsNotificationsEnabled, smsNotificationsEnabled) ||
                other.smsNotificationsEnabled == smsNotificationsEnabled) &&
            (identical(other.orderUpdates, orderUpdates) ||
                other.orderUpdates == orderUpdates) &&
            (identical(other.promotionalEmails, promotionalEmails) ||
                other.promotionalEmails == promotionalEmails) &&
            (identical(other.newsletterSubscription, newsletterSubscription) ||
                other.newsletterSubscription == newsletterSubscription) &&
            (identical(other.biometricAuthEnabled, biometricAuthEnabled) ||
                other.biometricAuthEnabled == biometricAuthEnabled) &&
            (identical(other.twoFactorAuthEnabled, twoFactorAuthEnabled) ||
                other.twoFactorAuthEnabled == twoFactorAuthEnabled) &&
            (identical(other.shareDataForAnalytics, shareDataForAnalytics) ||
                other.shareDataForAnalytics == shareDataForAnalytics) &&
            (identical(other.shareDataForMarketing, shareDataForMarketing) ||
                other.shareDataForMarketing == shareDataForMarketing) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.timeZone, timeZone) ||
                other.timeZone == timeZone) &&
            (identical(other.autoBackup, autoBackup) ||
                other.autoBackup == autoBackup) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      userId,
      themeMode,
      language,
      pushNotificationsEnabled,
      emailNotificationsEnabled,
      smsNotificationsEnabled,
      orderUpdates,
      promotionalEmails,
      newsletterSubscription,
      biometricAuthEnabled,
      twoFactorAuthEnabled,
      shareDataForAnalytics,
      shareDataForMarketing,
      currency,
      timeZone,
      autoBackup,
      updatedAt);

  /// Create a copy of UserPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserPreferencesModelImplCopyWith<_$UserPreferencesModelImpl>
      get copyWith =>
          __$$UserPreferencesModelImplCopyWithImpl<_$UserPreferencesModelImpl>(
              this, _$identity);
}

abstract class _UserPreferencesModel implements UserPreferencesModel {
  const factory _UserPreferencesModel(
          {@HiveField(0) required final String userId,
          @HiveField(1) final ThemeMode themeMode,
          @HiveField(2) final Language language,
          @HiveField(3) final bool pushNotificationsEnabled,
          @HiveField(4) final bool emailNotificationsEnabled,
          @HiveField(5) final bool smsNotificationsEnabled,
          @HiveField(6) final NotificationFrequency orderUpdates,
          @HiveField(7) final NotificationFrequency promotionalEmails,
          @HiveField(8) final NotificationFrequency newsletterSubscription,
          @HiveField(9) final bool biometricAuthEnabled,
          @HiveField(10) final bool twoFactorAuthEnabled,
          @HiveField(11) final bool shareDataForAnalytics,
          @HiveField(12) final bool shareDataForMarketing,
          @HiveField(13) final String currency,
          @HiveField(14) final String timeZone,
          @HiveField(15) final bool autoBackup,
          @HiveField(16) required final DateTime updatedAt}) =
      _$UserPreferencesModelImpl;

  @override
  @HiveField(0)
  String get userId;
  @override
  @HiveField(1)
  ThemeMode get themeMode;
  @override
  @HiveField(2)
  Language get language;
  @override
  @HiveField(3)
  bool get pushNotificationsEnabled;
  @override
  @HiveField(4)
  bool get emailNotificationsEnabled;
  @override
  @HiveField(5)
  bool get smsNotificationsEnabled;
  @override
  @HiveField(6)
  NotificationFrequency get orderUpdates;
  @override
  @HiveField(7)
  NotificationFrequency get promotionalEmails;
  @override
  @HiveField(8)
  NotificationFrequency get newsletterSubscription;
  @override
  @HiveField(9)
  bool get biometricAuthEnabled;
  @override
  @HiveField(10)
  bool get twoFactorAuthEnabled;
  @override
  @HiveField(11)
  bool get shareDataForAnalytics;
  @override
  @HiveField(12)
  bool get shareDataForMarketing;
  @override
  @HiveField(13)
  String get currency;
  @override
  @HiveField(14)
  String get timeZone;
  @override
  @HiveField(15)
  bool get autoBackup;
  @override
  @HiveField(16)
  DateTime get updatedAt;

  /// Create a copy of UserPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserPreferencesModelImplCopyWith<_$UserPreferencesModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
