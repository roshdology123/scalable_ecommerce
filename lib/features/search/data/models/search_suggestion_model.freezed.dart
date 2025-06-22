// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_suggestion_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SearchSuggestionModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get text => throw _privateConstructorUsedError;
  @HiveField(2)
  SuggestionType get type => throw _privateConstructorUsedError;
  @HiveField(3)
  int get searchCount => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime get lastUsed => throw _privateConstructorUsedError;
  @HiveField(5)
  String? get category => throw _privateConstructorUsedError;
  @HiveField(6)
  String? get imageUrl => throw _privateConstructorUsedError;

  /// Create a copy of SearchSuggestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchSuggestionModelCopyWith<SearchSuggestionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchSuggestionModelCopyWith<$Res> {
  factory $SearchSuggestionModelCopyWith(SearchSuggestionModel value,
          $Res Function(SearchSuggestionModel) then) =
      _$SearchSuggestionModelCopyWithImpl<$Res, SearchSuggestionModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String text,
      @HiveField(2) SuggestionType type,
      @HiveField(3) int searchCount,
      @HiveField(4) DateTime lastUsed,
      @HiveField(5) String? category,
      @HiveField(6) String? imageUrl});
}

/// @nodoc
class _$SearchSuggestionModelCopyWithImpl<$Res,
        $Val extends SearchSuggestionModel>
    implements $SearchSuggestionModelCopyWith<$Res> {
  _$SearchSuggestionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchSuggestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? type = null,
    Object? searchCount = null,
    Object? lastUsed = null,
    Object? category = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SuggestionType,
      searchCount: null == searchCount
          ? _value.searchCount
          : searchCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastUsed: null == lastUsed
          ? _value.lastUsed
          : lastUsed // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchSuggestionModelImplCopyWith<$Res>
    implements $SearchSuggestionModelCopyWith<$Res> {
  factory _$$SearchSuggestionModelImplCopyWith(
          _$SearchSuggestionModelImpl value,
          $Res Function(_$SearchSuggestionModelImpl) then) =
      __$$SearchSuggestionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String text,
      @HiveField(2) SuggestionType type,
      @HiveField(3) int searchCount,
      @HiveField(4) DateTime lastUsed,
      @HiveField(5) String? category,
      @HiveField(6) String? imageUrl});
}

/// @nodoc
class __$$SearchSuggestionModelImplCopyWithImpl<$Res>
    extends _$SearchSuggestionModelCopyWithImpl<$Res,
        _$SearchSuggestionModelImpl>
    implements _$$SearchSuggestionModelImplCopyWith<$Res> {
  __$$SearchSuggestionModelImplCopyWithImpl(_$SearchSuggestionModelImpl _value,
      $Res Function(_$SearchSuggestionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchSuggestionModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? type = null,
    Object? searchCount = null,
    Object? lastUsed = null,
    Object? category = freezed,
    Object? imageUrl = freezed,
  }) {
    return _then(_$SearchSuggestionModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SuggestionType,
      searchCount: null == searchCount
          ? _value.searchCount
          : searchCount // ignore: cast_nullable_to_non_nullable
              as int,
      lastUsed: null == lastUsed
          ? _value.lastUsed
          : lastUsed // ignore: cast_nullable_to_non_nullable
              as DateTime,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$SearchSuggestionModelImpl implements _SearchSuggestionModel {
  const _$SearchSuggestionModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.text,
      @HiveField(2) required this.type,
      @HiveField(3) this.searchCount = 0,
      @HiveField(4) required this.lastUsed,
      @HiveField(5) this.category,
      @HiveField(6) this.imageUrl});

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String text;
  @override
  @HiveField(2)
  final SuggestionType type;
  @override
  @JsonKey()
  @HiveField(3)
  final int searchCount;
  @override
  @HiveField(4)
  final DateTime lastUsed;
  @override
  @HiveField(5)
  final String? category;
  @override
  @HiveField(6)
  final String? imageUrl;

  @override
  String toString() {
    return 'SearchSuggestionModel(id: $id, text: $text, type: $type, searchCount: $searchCount, lastUsed: $lastUsed, category: $category, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchSuggestionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.searchCount, searchCount) ||
                other.searchCount == searchCount) &&
            (identical(other.lastUsed, lastUsed) ||
                other.lastUsed == lastUsed) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, id, text, type, searchCount, lastUsed, category, imageUrl);

  /// Create a copy of SearchSuggestionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchSuggestionModelImplCopyWith<_$SearchSuggestionModelImpl>
      get copyWith => __$$SearchSuggestionModelImplCopyWithImpl<
          _$SearchSuggestionModelImpl>(this, _$identity);
}

abstract class _SearchSuggestionModel implements SearchSuggestionModel {
  const factory _SearchSuggestionModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String text,
      @HiveField(2) required final SuggestionType type,
      @HiveField(3) final int searchCount,
      @HiveField(4) required final DateTime lastUsed,
      @HiveField(5) final String? category,
      @HiveField(6) final String? imageUrl}) = _$SearchSuggestionModelImpl;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get text;
  @override
  @HiveField(2)
  SuggestionType get type;
  @override
  @HiveField(3)
  int get searchCount;
  @override
  @HiveField(4)
  DateTime get lastUsed;
  @override
  @HiveField(5)
  String? get category;
  @override
  @HiveField(6)
  String? get imageUrl;

  /// Create a copy of SearchSuggestionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchSuggestionModelImplCopyWith<_$SearchSuggestionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
