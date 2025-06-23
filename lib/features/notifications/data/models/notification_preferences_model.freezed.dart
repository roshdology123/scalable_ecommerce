// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preferences_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationPreferencesModel _$NotificationPreferencesModelFromJson(
    Map<String, dynamic> json) {
  return _NotificationPreferencesModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationPreferencesModel {
  @HiveField(0)
  String get userId => throw _privateConstructorUsedError;
  @HiveField(1)
  bool get pushNotificationsEnabled => throw _privateConstructorUsedError;
  @HiveField(2)
  bool get emailNotificationsEnabled => throw _privateConstructorUsedError;
  @HiveField(3)
  bool get smsNotificationsEnabled => throw _privateConstructorUsedError;
  @HiveField(4)
  bool get orderUpdatesEnabled => throw _privateConstructorUsedError;
  @HiveField(5)
  bool get promotionsEnabled => throw _privateConstructorUsedError;
  @HiveField(6)
  bool get cartAbandonmentEnabled => throw _privateConstructorUsedError;
  @HiveField(7)
  bool get priceAlertsEnabled => throw _privateConstructorUsedError;
  @HiveField(8)
  bool get stockAlertsEnabled => throw _privateConstructorUsedError;
  @HiveField(9)
  bool get newProductsEnabled => throw _privateConstructorUsedError;
  @HiveField(10)
  String get orderUpdatesFrequency => throw _privateConstructorUsedError;
  @HiveField(11)
  String get promotionsFrequency => throw _privateConstructorUsedError;
  @HiveField(12)
  String get newsletterFrequency => throw _privateConstructorUsedError;
  @HiveField(13)
  bool get quietHoursEnabled => throw _privateConstructorUsedError;
  @HiveField(14)
  String get quietHoursStart => throw _privateConstructorUsedError;
  @HiveField(15)
  String get quietHoursEnd => throw _privateConstructorUsedError;
  @HiveField(16)
  List<String> get subscribedTopics => throw _privateConstructorUsedError;
  @HiveField(17)
  List<String> get mutedCategories => throw _privateConstructorUsedError;
  @HiveField(18)
  String get soundPreference =>
      throw _privateConstructorUsedError; // 'all', 'important', 'none'
  @HiveField(19)
  String get vibrationPreference =>
      throw _privateConstructorUsedError; // 'all', 'important', 'none'
  @HiveField(20)
  bool get showOnLockScreen => throw _privateConstructorUsedError;
  @HiveField(21)
  bool get showPreview => throw _privateConstructorUsedError;
  @HiveField(22)
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  /// Serializes this NotificationPreferencesModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationPreferencesModelCopyWith<NotificationPreferencesModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPreferencesModelCopyWith<$Res> {
  factory $NotificationPreferencesModelCopyWith(
          NotificationPreferencesModel value,
          $Res Function(NotificationPreferencesModel) then) =
      _$NotificationPreferencesModelCopyWithImpl<$Res,
          NotificationPreferencesModel>;
  @useResult
  $Res call(
      {@HiveField(0) String userId,
      @HiveField(1) bool pushNotificationsEnabled,
      @HiveField(2) bool emailNotificationsEnabled,
      @HiveField(3) bool smsNotificationsEnabled,
      @HiveField(4) bool orderUpdatesEnabled,
      @HiveField(5) bool promotionsEnabled,
      @HiveField(6) bool cartAbandonmentEnabled,
      @HiveField(7) bool priceAlertsEnabled,
      @HiveField(8) bool stockAlertsEnabled,
      @HiveField(9) bool newProductsEnabled,
      @HiveField(10) String orderUpdatesFrequency,
      @HiveField(11) String promotionsFrequency,
      @HiveField(12) String newsletterFrequency,
      @HiveField(13) bool quietHoursEnabled,
      @HiveField(14) String quietHoursStart,
      @HiveField(15) String quietHoursEnd,
      @HiveField(16) List<String> subscribedTopics,
      @HiveField(17) List<String> mutedCategories,
      @HiveField(18) String soundPreference,
      @HiveField(19) String vibrationPreference,
      @HiveField(20) bool showOnLockScreen,
      @HiveField(21) bool showPreview,
      @HiveField(22) DateTime? lastUpdated});
}

/// @nodoc
class _$NotificationPreferencesModelCopyWithImpl<$Res,
        $Val extends NotificationPreferencesModel>
    implements $NotificationPreferencesModelCopyWith<$Res> {
  _$NotificationPreferencesModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? pushNotificationsEnabled = null,
    Object? emailNotificationsEnabled = null,
    Object? smsNotificationsEnabled = null,
    Object? orderUpdatesEnabled = null,
    Object? promotionsEnabled = null,
    Object? cartAbandonmentEnabled = null,
    Object? priceAlertsEnabled = null,
    Object? stockAlertsEnabled = null,
    Object? newProductsEnabled = null,
    Object? orderUpdatesFrequency = null,
    Object? promotionsFrequency = null,
    Object? newsletterFrequency = null,
    Object? quietHoursEnabled = null,
    Object? quietHoursStart = null,
    Object? quietHoursEnd = null,
    Object? subscribedTopics = null,
    Object? mutedCategories = null,
    Object? soundPreference = null,
    Object? vibrationPreference = null,
    Object? showOnLockScreen = null,
    Object? showPreview = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
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
      orderUpdatesEnabled: null == orderUpdatesEnabled
          ? _value.orderUpdatesEnabled
          : orderUpdatesEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      promotionsEnabled: null == promotionsEnabled
          ? _value.promotionsEnabled
          : promotionsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      cartAbandonmentEnabled: null == cartAbandonmentEnabled
          ? _value.cartAbandonmentEnabled
          : cartAbandonmentEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      priceAlertsEnabled: null == priceAlertsEnabled
          ? _value.priceAlertsEnabled
          : priceAlertsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      stockAlertsEnabled: null == stockAlertsEnabled
          ? _value.stockAlertsEnabled
          : stockAlertsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      newProductsEnabled: null == newProductsEnabled
          ? _value.newProductsEnabled
          : newProductsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      orderUpdatesFrequency: null == orderUpdatesFrequency
          ? _value.orderUpdatesFrequency
          : orderUpdatesFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      promotionsFrequency: null == promotionsFrequency
          ? _value.promotionsFrequency
          : promotionsFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      newsletterFrequency: null == newsletterFrequency
          ? _value.newsletterFrequency
          : newsletterFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      quietHoursEnabled: null == quietHoursEnabled
          ? _value.quietHoursEnabled
          : quietHoursEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      quietHoursStart: null == quietHoursStart
          ? _value.quietHoursStart
          : quietHoursStart // ignore: cast_nullable_to_non_nullable
              as String,
      quietHoursEnd: null == quietHoursEnd
          ? _value.quietHoursEnd
          : quietHoursEnd // ignore: cast_nullable_to_non_nullable
              as String,
      subscribedTopics: null == subscribedTopics
          ? _value.subscribedTopics
          : subscribedTopics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mutedCategories: null == mutedCategories
          ? _value.mutedCategories
          : mutedCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      soundPreference: null == soundPreference
          ? _value.soundPreference
          : soundPreference // ignore: cast_nullable_to_non_nullable
              as String,
      vibrationPreference: null == vibrationPreference
          ? _value.vibrationPreference
          : vibrationPreference // ignore: cast_nullable_to_non_nullable
              as String,
      showOnLockScreen: null == showOnLockScreen
          ? _value.showOnLockScreen
          : showOnLockScreen // ignore: cast_nullable_to_non_nullable
              as bool,
      showPreview: null == showPreview
          ? _value.showPreview
          : showPreview // ignore: cast_nullable_to_non_nullable
              as bool,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationPreferencesModelImplCopyWith<$Res>
    implements $NotificationPreferencesModelCopyWith<$Res> {
  factory _$$NotificationPreferencesModelImplCopyWith(
          _$NotificationPreferencesModelImpl value,
          $Res Function(_$NotificationPreferencesModelImpl) then) =
      __$$NotificationPreferencesModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String userId,
      @HiveField(1) bool pushNotificationsEnabled,
      @HiveField(2) bool emailNotificationsEnabled,
      @HiveField(3) bool smsNotificationsEnabled,
      @HiveField(4) bool orderUpdatesEnabled,
      @HiveField(5) bool promotionsEnabled,
      @HiveField(6) bool cartAbandonmentEnabled,
      @HiveField(7) bool priceAlertsEnabled,
      @HiveField(8) bool stockAlertsEnabled,
      @HiveField(9) bool newProductsEnabled,
      @HiveField(10) String orderUpdatesFrequency,
      @HiveField(11) String promotionsFrequency,
      @HiveField(12) String newsletterFrequency,
      @HiveField(13) bool quietHoursEnabled,
      @HiveField(14) String quietHoursStart,
      @HiveField(15) String quietHoursEnd,
      @HiveField(16) List<String> subscribedTopics,
      @HiveField(17) List<String> mutedCategories,
      @HiveField(18) String soundPreference,
      @HiveField(19) String vibrationPreference,
      @HiveField(20) bool showOnLockScreen,
      @HiveField(21) bool showPreview,
      @HiveField(22) DateTime? lastUpdated});
}

/// @nodoc
class __$$NotificationPreferencesModelImplCopyWithImpl<$Res>
    extends _$NotificationPreferencesModelCopyWithImpl<$Res,
        _$NotificationPreferencesModelImpl>
    implements _$$NotificationPreferencesModelImplCopyWith<$Res> {
  __$$NotificationPreferencesModelImplCopyWithImpl(
      _$NotificationPreferencesModelImpl _value,
      $Res Function(_$NotificationPreferencesModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? pushNotificationsEnabled = null,
    Object? emailNotificationsEnabled = null,
    Object? smsNotificationsEnabled = null,
    Object? orderUpdatesEnabled = null,
    Object? promotionsEnabled = null,
    Object? cartAbandonmentEnabled = null,
    Object? priceAlertsEnabled = null,
    Object? stockAlertsEnabled = null,
    Object? newProductsEnabled = null,
    Object? orderUpdatesFrequency = null,
    Object? promotionsFrequency = null,
    Object? newsletterFrequency = null,
    Object? quietHoursEnabled = null,
    Object? quietHoursStart = null,
    Object? quietHoursEnd = null,
    Object? subscribedTopics = null,
    Object? mutedCategories = null,
    Object? soundPreference = null,
    Object? vibrationPreference = null,
    Object? showOnLockScreen = null,
    Object? showPreview = null,
    Object? lastUpdated = freezed,
  }) {
    return _then(_$NotificationPreferencesModelImpl(
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
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
      orderUpdatesEnabled: null == orderUpdatesEnabled
          ? _value.orderUpdatesEnabled
          : orderUpdatesEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      promotionsEnabled: null == promotionsEnabled
          ? _value.promotionsEnabled
          : promotionsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      cartAbandonmentEnabled: null == cartAbandonmentEnabled
          ? _value.cartAbandonmentEnabled
          : cartAbandonmentEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      priceAlertsEnabled: null == priceAlertsEnabled
          ? _value.priceAlertsEnabled
          : priceAlertsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      stockAlertsEnabled: null == stockAlertsEnabled
          ? _value.stockAlertsEnabled
          : stockAlertsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      newProductsEnabled: null == newProductsEnabled
          ? _value.newProductsEnabled
          : newProductsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      orderUpdatesFrequency: null == orderUpdatesFrequency
          ? _value.orderUpdatesFrequency
          : orderUpdatesFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      promotionsFrequency: null == promotionsFrequency
          ? _value.promotionsFrequency
          : promotionsFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      newsletterFrequency: null == newsletterFrequency
          ? _value.newsletterFrequency
          : newsletterFrequency // ignore: cast_nullable_to_non_nullable
              as String,
      quietHoursEnabled: null == quietHoursEnabled
          ? _value.quietHoursEnabled
          : quietHoursEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      quietHoursStart: null == quietHoursStart
          ? _value.quietHoursStart
          : quietHoursStart // ignore: cast_nullable_to_non_nullable
              as String,
      quietHoursEnd: null == quietHoursEnd
          ? _value.quietHoursEnd
          : quietHoursEnd // ignore: cast_nullable_to_non_nullable
              as String,
      subscribedTopics: null == subscribedTopics
          ? _value._subscribedTopics
          : subscribedTopics // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mutedCategories: null == mutedCategories
          ? _value._mutedCategories
          : mutedCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      soundPreference: null == soundPreference
          ? _value.soundPreference
          : soundPreference // ignore: cast_nullable_to_non_nullable
              as String,
      vibrationPreference: null == vibrationPreference
          ? _value.vibrationPreference
          : vibrationPreference // ignore: cast_nullable_to_non_nullable
              as String,
      showOnLockScreen: null == showOnLockScreen
          ? _value.showOnLockScreen
          : showOnLockScreen // ignore: cast_nullable_to_non_nullable
              as bool,
      showPreview: null == showPreview
          ? _value.showPreview
          : showPreview // ignore: cast_nullable_to_non_nullable
              as bool,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationPreferencesModelImpl
    implements _NotificationPreferencesModel {
  const _$NotificationPreferencesModelImpl(
      {@HiveField(0) required this.userId,
      @HiveField(1) this.pushNotificationsEnabled = true,
      @HiveField(2) this.emailNotificationsEnabled = true,
      @HiveField(3) this.smsNotificationsEnabled = false,
      @HiveField(4) this.orderUpdatesEnabled = true,
      @HiveField(5) this.promotionsEnabled = true,
      @HiveField(6) this.cartAbandonmentEnabled = true,
      @HiveField(7) this.priceAlertsEnabled = true,
      @HiveField(8) this.stockAlertsEnabled = true,
      @HiveField(9) this.newProductsEnabled = true,
      @HiveField(10) this.orderUpdatesFrequency = 'immediately',
      @HiveField(11) this.promotionsFrequency = 'daily',
      @HiveField(12) this.newsletterFrequency = 'weekly',
      @HiveField(13) this.quietHoursEnabled = false,
      @HiveField(14) this.quietHoursStart = '22:00',
      @HiveField(15) this.quietHoursEnd = '08:00',
      @HiveField(16) final List<String> subscribedTopics = const [],
      @HiveField(17) final List<String> mutedCategories = const [],
      @HiveField(18) this.soundPreference = 'all',
      @HiveField(19) this.vibrationPreference = 'all',
      @HiveField(20) this.showOnLockScreen = true,
      @HiveField(21) this.showPreview = true,
      @HiveField(22) this.lastUpdated})
      : _subscribedTopics = subscribedTopics,
        _mutedCategories = mutedCategories;

  factory _$NotificationPreferencesModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$NotificationPreferencesModelImplFromJson(json);

  @override
  @HiveField(0)
  final String userId;
  @override
  @JsonKey()
  @HiveField(1)
  final bool pushNotificationsEnabled;
  @override
  @JsonKey()
  @HiveField(2)
  final bool emailNotificationsEnabled;
  @override
  @JsonKey()
  @HiveField(3)
  final bool smsNotificationsEnabled;
  @override
  @JsonKey()
  @HiveField(4)
  final bool orderUpdatesEnabled;
  @override
  @JsonKey()
  @HiveField(5)
  final bool promotionsEnabled;
  @override
  @JsonKey()
  @HiveField(6)
  final bool cartAbandonmentEnabled;
  @override
  @JsonKey()
  @HiveField(7)
  final bool priceAlertsEnabled;
  @override
  @JsonKey()
  @HiveField(8)
  final bool stockAlertsEnabled;
  @override
  @JsonKey()
  @HiveField(9)
  final bool newProductsEnabled;
  @override
  @JsonKey()
  @HiveField(10)
  final String orderUpdatesFrequency;
  @override
  @JsonKey()
  @HiveField(11)
  final String promotionsFrequency;
  @override
  @JsonKey()
  @HiveField(12)
  final String newsletterFrequency;
  @override
  @JsonKey()
  @HiveField(13)
  final bool quietHoursEnabled;
  @override
  @JsonKey()
  @HiveField(14)
  final String quietHoursStart;
  @override
  @JsonKey()
  @HiveField(15)
  final String quietHoursEnd;
  final List<String> _subscribedTopics;
  @override
  @JsonKey()
  @HiveField(16)
  List<String> get subscribedTopics {
    if (_subscribedTopics is EqualUnmodifiableListView)
      return _subscribedTopics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subscribedTopics);
  }

  final List<String> _mutedCategories;
  @override
  @JsonKey()
  @HiveField(17)
  List<String> get mutedCategories {
    if (_mutedCategories is EqualUnmodifiableListView) return _mutedCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mutedCategories);
  }

  @override
  @JsonKey()
  @HiveField(18)
  final String soundPreference;
// 'all', 'important', 'none'
  @override
  @JsonKey()
  @HiveField(19)
  final String vibrationPreference;
// 'all', 'important', 'none'
  @override
  @JsonKey()
  @HiveField(20)
  final bool showOnLockScreen;
  @override
  @JsonKey()
  @HiveField(21)
  final bool showPreview;
  @override
  @HiveField(22)
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'NotificationPreferencesModel(userId: $userId, pushNotificationsEnabled: $pushNotificationsEnabled, emailNotificationsEnabled: $emailNotificationsEnabled, smsNotificationsEnabled: $smsNotificationsEnabled, orderUpdatesEnabled: $orderUpdatesEnabled, promotionsEnabled: $promotionsEnabled, cartAbandonmentEnabled: $cartAbandonmentEnabled, priceAlertsEnabled: $priceAlertsEnabled, stockAlertsEnabled: $stockAlertsEnabled, newProductsEnabled: $newProductsEnabled, orderUpdatesFrequency: $orderUpdatesFrequency, promotionsFrequency: $promotionsFrequency, newsletterFrequency: $newsletterFrequency, quietHoursEnabled: $quietHoursEnabled, quietHoursStart: $quietHoursStart, quietHoursEnd: $quietHoursEnd, subscribedTopics: $subscribedTopics, mutedCategories: $mutedCategories, soundPreference: $soundPreference, vibrationPreference: $vibrationPreference, showOnLockScreen: $showOnLockScreen, showPreview: $showPreview, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPreferencesModelImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.pushNotificationsEnabled, pushNotificationsEnabled) ||
                other.pushNotificationsEnabled == pushNotificationsEnabled) &&
            (identical(other.emailNotificationsEnabled, emailNotificationsEnabled) ||
                other.emailNotificationsEnabled == emailNotificationsEnabled) &&
            (identical(other.smsNotificationsEnabled, smsNotificationsEnabled) ||
                other.smsNotificationsEnabled == smsNotificationsEnabled) &&
            (identical(other.orderUpdatesEnabled, orderUpdatesEnabled) ||
                other.orderUpdatesEnabled == orderUpdatesEnabled) &&
            (identical(other.promotionsEnabled, promotionsEnabled) ||
                other.promotionsEnabled == promotionsEnabled) &&
            (identical(other.cartAbandonmentEnabled, cartAbandonmentEnabled) ||
                other.cartAbandonmentEnabled == cartAbandonmentEnabled) &&
            (identical(other.priceAlertsEnabled, priceAlertsEnabled) ||
                other.priceAlertsEnabled == priceAlertsEnabled) &&
            (identical(other.stockAlertsEnabled, stockAlertsEnabled) ||
                other.stockAlertsEnabled == stockAlertsEnabled) &&
            (identical(other.newProductsEnabled, newProductsEnabled) ||
                other.newProductsEnabled == newProductsEnabled) &&
            (identical(other.orderUpdatesFrequency, orderUpdatesFrequency) ||
                other.orderUpdatesFrequency == orderUpdatesFrequency) &&
            (identical(other.promotionsFrequency, promotionsFrequency) ||
                other.promotionsFrequency == promotionsFrequency) &&
            (identical(other.newsletterFrequency, newsletterFrequency) ||
                other.newsletterFrequency == newsletterFrequency) &&
            (identical(other.quietHoursEnabled, quietHoursEnabled) ||
                other.quietHoursEnabled == quietHoursEnabled) &&
            (identical(other.quietHoursStart, quietHoursStart) ||
                other.quietHoursStart == quietHoursStart) &&
            (identical(other.quietHoursEnd, quietHoursEnd) ||
                other.quietHoursEnd == quietHoursEnd) &&
            const DeepCollectionEquality()
                .equals(other._subscribedTopics, _subscribedTopics) &&
            const DeepCollectionEquality()
                .equals(other._mutedCategories, _mutedCategories) &&
            (identical(other.soundPreference, soundPreference) ||
                other.soundPreference == soundPreference) &&
            (identical(other.vibrationPreference, vibrationPreference) ||
                other.vibrationPreference == vibrationPreference) &&
            (identical(other.showOnLockScreen, showOnLockScreen) ||
                other.showOnLockScreen == showOnLockScreen) &&
            (identical(other.showPreview, showPreview) ||
                other.showPreview == showPreview) &&
            (identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        userId,
        pushNotificationsEnabled,
        emailNotificationsEnabled,
        smsNotificationsEnabled,
        orderUpdatesEnabled,
        promotionsEnabled,
        cartAbandonmentEnabled,
        priceAlertsEnabled,
        stockAlertsEnabled,
        newProductsEnabled,
        orderUpdatesFrequency,
        promotionsFrequency,
        newsletterFrequency,
        quietHoursEnabled,
        quietHoursStart,
        quietHoursEnd,
        const DeepCollectionEquality().hash(_subscribedTopics),
        const DeepCollectionEquality().hash(_mutedCategories),
        soundPreference,
        vibrationPreference,
        showOnLockScreen,
        showPreview,
        lastUpdated
      ]);

  /// Create a copy of NotificationPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationPreferencesModelImplCopyWith<
          _$NotificationPreferencesModelImpl>
      get copyWith => __$$NotificationPreferencesModelImplCopyWithImpl<
          _$NotificationPreferencesModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationPreferencesModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationPreferencesModel
    implements NotificationPreferencesModel {
  const factory _NotificationPreferencesModel(
          {@HiveField(0) required final String userId,
          @HiveField(1) final bool pushNotificationsEnabled,
          @HiveField(2) final bool emailNotificationsEnabled,
          @HiveField(3) final bool smsNotificationsEnabled,
          @HiveField(4) final bool orderUpdatesEnabled,
          @HiveField(5) final bool promotionsEnabled,
          @HiveField(6) final bool cartAbandonmentEnabled,
          @HiveField(7) final bool priceAlertsEnabled,
          @HiveField(8) final bool stockAlertsEnabled,
          @HiveField(9) final bool newProductsEnabled,
          @HiveField(10) final String orderUpdatesFrequency,
          @HiveField(11) final String promotionsFrequency,
          @HiveField(12) final String newsletterFrequency,
          @HiveField(13) final bool quietHoursEnabled,
          @HiveField(14) final String quietHoursStart,
          @HiveField(15) final String quietHoursEnd,
          @HiveField(16) final List<String> subscribedTopics,
          @HiveField(17) final List<String> mutedCategories,
          @HiveField(18) final String soundPreference,
          @HiveField(19) final String vibrationPreference,
          @HiveField(20) final bool showOnLockScreen,
          @HiveField(21) final bool showPreview,
          @HiveField(22) final DateTime? lastUpdated}) =
      _$NotificationPreferencesModelImpl;

  factory _NotificationPreferencesModel.fromJson(Map<String, dynamic> json) =
      _$NotificationPreferencesModelImpl.fromJson;

  @override
  @HiveField(0)
  String get userId;
  @override
  @HiveField(1)
  bool get pushNotificationsEnabled;
  @override
  @HiveField(2)
  bool get emailNotificationsEnabled;
  @override
  @HiveField(3)
  bool get smsNotificationsEnabled;
  @override
  @HiveField(4)
  bool get orderUpdatesEnabled;
  @override
  @HiveField(5)
  bool get promotionsEnabled;
  @override
  @HiveField(6)
  bool get cartAbandonmentEnabled;
  @override
  @HiveField(7)
  bool get priceAlertsEnabled;
  @override
  @HiveField(8)
  bool get stockAlertsEnabled;
  @override
  @HiveField(9)
  bool get newProductsEnabled;
  @override
  @HiveField(10)
  String get orderUpdatesFrequency;
  @override
  @HiveField(11)
  String get promotionsFrequency;
  @override
  @HiveField(12)
  String get newsletterFrequency;
  @override
  @HiveField(13)
  bool get quietHoursEnabled;
  @override
  @HiveField(14)
  String get quietHoursStart;
  @override
  @HiveField(15)
  String get quietHoursEnd;
  @override
  @HiveField(16)
  List<String> get subscribedTopics;
  @override
  @HiveField(17)
  List<String> get mutedCategories;
  @override
  @HiveField(18)
  String get soundPreference; // 'all', 'important', 'none'
  @override
  @HiveField(19)
  String get vibrationPreference; // 'all', 'important', 'none'
  @override
  @HiveField(20)
  bool get showOnLockScreen;
  @override
  @HiveField(21)
  bool get showPreview;
  @override
  @HiveField(22)
  DateTime? get lastUpdated;

  /// Create a copy of NotificationPreferencesModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationPreferencesModelImplCopyWith<
          _$NotificationPreferencesModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
