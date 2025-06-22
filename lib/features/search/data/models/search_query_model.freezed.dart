// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_query_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SearchQueryModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get query => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get category => throw _privateConstructorUsedError;
  @HiveField(3)
  double? get minPrice => throw _privateConstructorUsedError;
  @HiveField(4)
  double? get maxPrice => throw _privateConstructorUsedError;
  @HiveField(5)
  double? get minRating => throw _privateConstructorUsedError;
  @HiveField(6)
  DateTime get timestamp => throw _privateConstructorUsedError;
  @HiveField(7)
  int get resultCount => throw _privateConstructorUsedError;

  /// Create a copy of SearchQueryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchQueryModelCopyWith<SearchQueryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchQueryModelCopyWith<$Res> {
  factory $SearchQueryModelCopyWith(
          SearchQueryModel value, $Res Function(SearchQueryModel) then) =
      _$SearchQueryModelCopyWithImpl<$Res, SearchQueryModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String query,
      @HiveField(2) String? category,
      @HiveField(3) double? minPrice,
      @HiveField(4) double? maxPrice,
      @HiveField(5) double? minRating,
      @HiveField(6) DateTime timestamp,
      @HiveField(7) int resultCount});
}

/// @nodoc
class _$SearchQueryModelCopyWithImpl<$Res, $Val extends SearchQueryModel>
    implements $SearchQueryModelCopyWith<$Res> {
  _$SearchQueryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchQueryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? query = null,
    Object? category = freezed,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
    Object? minRating = freezed,
    Object? timestamp = null,
    Object? resultCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      minPrice: freezed == minPrice
          ? _value.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      maxPrice: freezed == maxPrice
          ? _value.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      minRating: freezed == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      resultCount: null == resultCount
          ? _value.resultCount
          : resultCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchQueryModelImplCopyWith<$Res>
    implements $SearchQueryModelCopyWith<$Res> {
  factory _$$SearchQueryModelImplCopyWith(_$SearchQueryModelImpl value,
          $Res Function(_$SearchQueryModelImpl) then) =
      __$$SearchQueryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String query,
      @HiveField(2) String? category,
      @HiveField(3) double? minPrice,
      @HiveField(4) double? maxPrice,
      @HiveField(5) double? minRating,
      @HiveField(6) DateTime timestamp,
      @HiveField(7) int resultCount});
}

/// @nodoc
class __$$SearchQueryModelImplCopyWithImpl<$Res>
    extends _$SearchQueryModelCopyWithImpl<$Res, _$SearchQueryModelImpl>
    implements _$$SearchQueryModelImplCopyWith<$Res> {
  __$$SearchQueryModelImplCopyWithImpl(_$SearchQueryModelImpl _value,
      $Res Function(_$SearchQueryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchQueryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? query = null,
    Object? category = freezed,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
    Object? minRating = freezed,
    Object? timestamp = null,
    Object? resultCount = null,
  }) {
    return _then(_$SearchQueryModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      minPrice: freezed == minPrice
          ? _value.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      maxPrice: freezed == maxPrice
          ? _value.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      minRating: freezed == minRating
          ? _value.minRating
          : minRating // ignore: cast_nullable_to_non_nullable
              as double?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      resultCount: null == resultCount
          ? _value.resultCount
          : resultCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$SearchQueryModelImpl implements _SearchQueryModel {
  const _$SearchQueryModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.query,
      @HiveField(2) this.category,
      @HiveField(3) this.minPrice,
      @HiveField(4) this.maxPrice,
      @HiveField(5) this.minRating,
      @HiveField(6) required this.timestamp,
      @HiveField(7) required this.resultCount});

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String query;
  @override
  @HiveField(2)
  final String? category;
  @override
  @HiveField(3)
  final double? minPrice;
  @override
  @HiveField(4)
  final double? maxPrice;
  @override
  @HiveField(5)
  final double? minRating;
  @override
  @HiveField(6)
  final DateTime timestamp;
  @override
  @HiveField(7)
  final int resultCount;

  @override
  String toString() {
    return 'SearchQueryModel(id: $id, query: $query, category: $category, minPrice: $minPrice, maxPrice: $maxPrice, minRating: $minRating, timestamp: $timestamp, resultCount: $resultCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchQueryModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.query, query) || other.query == query) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice) &&
            (identical(other.minRating, minRating) ||
                other.minRating == minRating) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.resultCount, resultCount) ||
                other.resultCount == resultCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, query, category, minPrice,
      maxPrice, minRating, timestamp, resultCount);

  /// Create a copy of SearchQueryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchQueryModelImplCopyWith<_$SearchQueryModelImpl> get copyWith =>
      __$$SearchQueryModelImplCopyWithImpl<_$SearchQueryModelImpl>(
          this, _$identity);
}

abstract class _SearchQueryModel implements SearchQueryModel {
  const factory _SearchQueryModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String query,
      @HiveField(2) final String? category,
      @HiveField(3) final double? minPrice,
      @HiveField(4) final double? maxPrice,
      @HiveField(5) final double? minRating,
      @HiveField(6) required final DateTime timestamp,
      @HiveField(7) required final int resultCount}) = _$SearchQueryModelImpl;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get query;
  @override
  @HiveField(2)
  String? get category;
  @override
  @HiveField(3)
  double? get minPrice;
  @override
  @HiveField(4)
  double? get maxPrice;
  @override
  @HiveField(5)
  double? get minRating;
  @override
  @HiveField(6)
  DateTime get timestamp;
  @override
  @HiveField(7)
  int get resultCount;

  /// Create a copy of SearchQueryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchQueryModelImplCopyWith<_$SearchQueryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
