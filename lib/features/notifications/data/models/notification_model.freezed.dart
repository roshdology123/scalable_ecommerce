// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return _NotificationModel.fromJson(json);
}

/// @nodoc
mixin _$NotificationModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get title => throw _privateConstructorUsedError;
  @HiveField(2)
  String get body => throw _privateConstructorUsedError;
  @HiveField(3)
  String get type => throw _privateConstructorUsedError;
  @HiveField(4)
  String get priority => throw _privateConstructorUsedError;
  @HiveField(5)
  Map<String, dynamic> get data => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(7)
  String get userId => throw _privateConstructorUsedError;
  @HiveField(8)
  DateTime? get readAt => throw _privateConstructorUsedError;
  @HiveField(9)
  DateTime? get scheduledAt => throw _privateConstructorUsedError;
  @HiveField(10)
  bool get isRead => throw _privateConstructorUsedError;
  @HiveField(11)
  String? get imageUrl => throw _privateConstructorUsedError;
  @HiveField(12)
  String? get actionUrl => throw _privateConstructorUsedError;
  @HiveField(13)
  String? get category => throw _privateConstructorUsedError;
  @HiveField(14)
  List<String> get tags => throw _privateConstructorUsedError;
  @HiveField(15)
  String? get source =>
      throw _privateConstructorUsedError; // 'firebase', 'simulator', 'local'
  @HiveField(16)
  bool get isExpired => throw _privateConstructorUsedError;
  @HiveField(17)
  DateTime? get expiresAt => throw _privateConstructorUsedError;

  /// Serializes this NotificationModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationModelCopyWith<NotificationModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationModelCopyWith<$Res> {
  factory $NotificationModelCopyWith(
          NotificationModel value, $Res Function(NotificationModel) then) =
      _$NotificationModelCopyWithImpl<$Res, NotificationModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) String body,
      @HiveField(3) String type,
      @HiveField(4) String priority,
      @HiveField(5) Map<String, dynamic> data,
      @HiveField(6) DateTime createdAt,
      @HiveField(7) String userId,
      @HiveField(8) DateTime? readAt,
      @HiveField(9) DateTime? scheduledAt,
      @HiveField(10) bool isRead,
      @HiveField(11) String? imageUrl,
      @HiveField(12) String? actionUrl,
      @HiveField(13) String? category,
      @HiveField(14) List<String> tags,
      @HiveField(15) String? source,
      @HiveField(16) bool isExpired,
      @HiveField(17) DateTime? expiresAt});
}

/// @nodoc
class _$NotificationModelCopyWithImpl<$Res, $Val extends NotificationModel>
    implements $NotificationModelCopyWith<$Res> {
  _$NotificationModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? type = null,
    Object? priority = null,
    Object? data = null,
    Object? createdAt = null,
    Object? userId = null,
    Object? readAt = freezed,
    Object? scheduledAt = freezed,
    Object? isRead = null,
    Object? imageUrl = freezed,
    Object? actionUrl = freezed,
    Object? category = freezed,
    Object? tags = null,
    Object? source = freezed,
    Object? isExpired = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      isExpired: null == isExpired
          ? _value.isExpired
          : isExpired // ignore: cast_nullable_to_non_nullable
              as bool,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationModelImplCopyWith<$Res>
    implements $NotificationModelCopyWith<$Res> {
  factory _$$NotificationModelImplCopyWith(_$NotificationModelImpl value,
          $Res Function(_$NotificationModelImpl) then) =
      __$$NotificationModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String title,
      @HiveField(2) String body,
      @HiveField(3) String type,
      @HiveField(4) String priority,
      @HiveField(5) Map<String, dynamic> data,
      @HiveField(6) DateTime createdAt,
      @HiveField(7) String userId,
      @HiveField(8) DateTime? readAt,
      @HiveField(9) DateTime? scheduledAt,
      @HiveField(10) bool isRead,
      @HiveField(11) String? imageUrl,
      @HiveField(12) String? actionUrl,
      @HiveField(13) String? category,
      @HiveField(14) List<String> tags,
      @HiveField(15) String? source,
      @HiveField(16) bool isExpired,
      @HiveField(17) DateTime? expiresAt});
}

/// @nodoc
class __$$NotificationModelImplCopyWithImpl<$Res>
    extends _$NotificationModelCopyWithImpl<$Res, _$NotificationModelImpl>
    implements _$$NotificationModelImplCopyWith<$Res> {
  __$$NotificationModelImplCopyWithImpl(_$NotificationModelImpl _value,
      $Res Function(_$NotificationModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? body = null,
    Object? type = null,
    Object? priority = null,
    Object? data = null,
    Object? createdAt = null,
    Object? userId = null,
    Object? readAt = freezed,
    Object? scheduledAt = freezed,
    Object? isRead = null,
    Object? imageUrl = freezed,
    Object? actionUrl = freezed,
    Object? category = freezed,
    Object? tags = null,
    Object? source = freezed,
    Object? isExpired = null,
    Object? expiresAt = freezed,
  }) {
    return _then(_$NotificationModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as String,
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      readAt: freezed == readAt
          ? _value.readAt
          : readAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      scheduledAt: freezed == scheduledAt
          ? _value.scheduledAt
          : scheduledAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isRead: null == isRead
          ? _value.isRead
          : isRead // ignore: cast_nullable_to_non_nullable
              as bool,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      actionUrl: freezed == actionUrl
          ? _value.actionUrl
          : actionUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      isExpired: null == isExpired
          ? _value.isExpired
          : isExpired // ignore: cast_nullable_to_non_nullable
              as bool,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationModelImpl implements _NotificationModel {
  const _$NotificationModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.title,
      @HiveField(2) required this.body,
      @HiveField(3) required this.type,
      @HiveField(4) required this.priority,
      @HiveField(5) required final Map<String, dynamic> data,
      @HiveField(6) required this.createdAt,
      @HiveField(7) required this.userId,
      @HiveField(8) this.readAt,
      @HiveField(9) this.scheduledAt,
      @HiveField(10) this.isRead = false,
      @HiveField(11) this.imageUrl,
      @HiveField(12) this.actionUrl,
      @HiveField(13) this.category,
      @HiveField(14) final List<String> tags = const [],
      @HiveField(15) this.source,
      @HiveField(16) this.isExpired = false,
      @HiveField(17) this.expiresAt})
      : _data = data,
        _tags = tags;

  factory _$NotificationModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  final String body;
  @override
  @HiveField(3)
  final String type;
  @override
  @HiveField(4)
  final String priority;
  final Map<String, dynamic> _data;
  @override
  @HiveField(5)
  Map<String, dynamic> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  @HiveField(6)
  final DateTime createdAt;
  @override
  @HiveField(7)
  final String userId;
  @override
  @HiveField(8)
  final DateTime? readAt;
  @override
  @HiveField(9)
  final DateTime? scheduledAt;
  @override
  @JsonKey()
  @HiveField(10)
  final bool isRead;
  @override
  @HiveField(11)
  final String? imageUrl;
  @override
  @HiveField(12)
  final String? actionUrl;
  @override
  @HiveField(13)
  final String? category;
  final List<String> _tags;
  @override
  @JsonKey()
  @HiveField(14)
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @HiveField(15)
  final String? source;
// 'firebase', 'simulator', 'local'
  @override
  @JsonKey()
  @HiveField(16)
  final bool isExpired;
  @override
  @HiveField(17)
  final DateTime? expiresAt;

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, body: $body, type: $type, priority: $priority, data: $data, createdAt: $createdAt, userId: $userId, readAt: $readAt, scheduledAt: $scheduledAt, isRead: $isRead, imageUrl: $imageUrl, actionUrl: $actionUrl, category: $category, tags: $tags, source: $source, isExpired: $isExpired, expiresAt: $expiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.readAt, readAt) || other.readAt == readAt) &&
            (identical(other.scheduledAt, scheduledAt) ||
                other.scheduledAt == scheduledAt) &&
            (identical(other.isRead, isRead) || other.isRead == isRead) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.actionUrl, actionUrl) ||
                other.actionUrl == actionUrl) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.isExpired, isExpired) ||
                other.isExpired == isExpired) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      body,
      type,
      priority,
      const DeepCollectionEquality().hash(_data),
      createdAt,
      userId,
      readAt,
      scheduledAt,
      isRead,
      imageUrl,
      actionUrl,
      category,
      const DeepCollectionEquality().hash(_tags),
      source,
      isExpired,
      expiresAt);

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      __$$NotificationModelImplCopyWithImpl<_$NotificationModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationModelImplToJson(
      this,
    );
  }
}

abstract class _NotificationModel implements NotificationModel {
  const factory _NotificationModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String title,
      @HiveField(2) required final String body,
      @HiveField(3) required final String type,
      @HiveField(4) required final String priority,
      @HiveField(5) required final Map<String, dynamic> data,
      @HiveField(6) required final DateTime createdAt,
      @HiveField(7) required final String userId,
      @HiveField(8) final DateTime? readAt,
      @HiveField(9) final DateTime? scheduledAt,
      @HiveField(10) final bool isRead,
      @HiveField(11) final String? imageUrl,
      @HiveField(12) final String? actionUrl,
      @HiveField(13) final String? category,
      @HiveField(14) final List<String> tags,
      @HiveField(15) final String? source,
      @HiveField(16) final bool isExpired,
      @HiveField(17) final DateTime? expiresAt}) = _$NotificationModelImpl;

  factory _NotificationModel.fromJson(Map<String, dynamic> json) =
      _$NotificationModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get title;
  @override
  @HiveField(2)
  String get body;
  @override
  @HiveField(3)
  String get type;
  @override
  @HiveField(4)
  String get priority;
  @override
  @HiveField(5)
  Map<String, dynamic> get data;
  @override
  @HiveField(6)
  DateTime get createdAt;
  @override
  @HiveField(7)
  String get userId;
  @override
  @HiveField(8)
  DateTime? get readAt;
  @override
  @HiveField(9)
  DateTime? get scheduledAt;
  @override
  @HiveField(10)
  bool get isRead;
  @override
  @HiveField(11)
  String? get imageUrl;
  @override
  @HiveField(12)
  String? get actionUrl;
  @override
  @HiveField(13)
  String? get category;
  @override
  @HiveField(14)
  List<String> get tags;
  @override
  @HiveField(15)
  String? get source; // 'firebase', 'simulator', 'local'
  @override
  @HiveField(16)
  bool get isExpired;
  @override
  @HiveField(17)
  DateTime? get expiresAt;

  /// Create a copy of NotificationModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationModelImplCopyWith<_$NotificationModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
