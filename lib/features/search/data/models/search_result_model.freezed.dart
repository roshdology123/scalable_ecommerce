// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SearchResultModel {
  String get query => throw _privateConstructorUsedError;
  List<ProductModel> get products => throw _privateConstructorUsedError;
  List<String> get categories => throw _privateConstructorUsedError;
  int get totalResults => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  Map<String, int> get categoryCount => throw _privateConstructorUsedError;
  double? get averagePrice => throw _privateConstructorUsedError;
  double? get averageRating => throw _privateConstructorUsedError;

  /// Create a copy of SearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchResultModelCopyWith<SearchResultModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResultModelCopyWith<$Res> {
  factory $SearchResultModelCopyWith(
          SearchResultModel value, $Res Function(SearchResultModel) then) =
      _$SearchResultModelCopyWithImpl<$Res, SearchResultModel>;
  @useResult
  $Res call(
      {String query,
      List<ProductModel> products,
      List<String> categories,
      int totalResults,
      DateTime timestamp,
      Map<String, int> categoryCount,
      double? averagePrice,
      double? averageRating});
}

/// @nodoc
class _$SearchResultModelCopyWithImpl<$Res, $Val extends SearchResultModel>
    implements $SearchResultModelCopyWith<$Res> {
  _$SearchResultModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? products = null,
    Object? categories = null,
    Object? totalResults = null,
    Object? timestamp = null,
    Object? categoryCount = null,
    Object? averagePrice = freezed,
    Object? averageRating = freezed,
  }) {
    return _then(_value.copyWith(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      products: null == products
          ? _value.products
          : products // ignore: cast_nullable_to_non_nullable
              as List<ProductModel>,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalResults: null == totalResults
          ? _value.totalResults
          : totalResults // ignore: cast_nullable_to_non_nullable
              as int,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      categoryCount: null == categoryCount
          ? _value.categoryCount
          : categoryCount // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      averagePrice: freezed == averagePrice
          ? _value.averagePrice
          : averagePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      averageRating: freezed == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchResultModelImplCopyWith<$Res>
    implements $SearchResultModelCopyWith<$Res> {
  factory _$$SearchResultModelImplCopyWith(_$SearchResultModelImpl value,
          $Res Function(_$SearchResultModelImpl) then) =
      __$$SearchResultModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String query,
      List<ProductModel> products,
      List<String> categories,
      int totalResults,
      DateTime timestamp,
      Map<String, int> categoryCount,
      double? averagePrice,
      double? averageRating});
}

/// @nodoc
class __$$SearchResultModelImplCopyWithImpl<$Res>
    extends _$SearchResultModelCopyWithImpl<$Res, _$SearchResultModelImpl>
    implements _$$SearchResultModelImplCopyWith<$Res> {
  __$$SearchResultModelImplCopyWithImpl(_$SearchResultModelImpl _value,
      $Res Function(_$SearchResultModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? query = null,
    Object? products = null,
    Object? categories = null,
    Object? totalResults = null,
    Object? timestamp = null,
    Object? categoryCount = null,
    Object? averagePrice = freezed,
    Object? averageRating = freezed,
  }) {
    return _then(_$SearchResultModelImpl(
      query: null == query
          ? _value.query
          : query // ignore: cast_nullable_to_non_nullable
              as String,
      products: null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<ProductModel>,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      totalResults: null == totalResults
          ? _value.totalResults
          : totalResults // ignore: cast_nullable_to_non_nullable
              as int,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      categoryCount: null == categoryCount
          ? _value._categoryCount
          : categoryCount // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      averagePrice: freezed == averagePrice
          ? _value.averagePrice
          : averagePrice // ignore: cast_nullable_to_non_nullable
              as double?,
      averageRating: freezed == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$SearchResultModelImpl implements _SearchResultModel {
  const _$SearchResultModelImpl(
      {required this.query,
      required final List<ProductModel> products,
      required final List<String> categories,
      required this.totalResults,
      required this.timestamp,
      final Map<String, int> categoryCount = const {},
      this.averagePrice,
      this.averageRating})
      : _products = products,
        _categories = categories,
        _categoryCount = categoryCount;

  @override
  final String query;
  final List<ProductModel> _products;
  @override
  List<ProductModel> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  final List<String> _categories;
  @override
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  final int totalResults;
  @override
  final DateTime timestamp;
  final Map<String, int> _categoryCount;
  @override
  @JsonKey()
  Map<String, int> get categoryCount {
    if (_categoryCount is EqualUnmodifiableMapView) return _categoryCount;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryCount);
  }

  @override
  final double? averagePrice;
  @override
  final double? averageRating;

  @override
  String toString() {
    return 'SearchResultModel(query: $query, products: $products, categories: $categories, totalResults: $totalResults, timestamp: $timestamp, categoryCount: $categoryCount, averagePrice: $averagePrice, averageRating: $averageRating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResultModelImpl &&
            (identical(other.query, query) || other.query == query) &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.totalResults, totalResults) ||
                other.totalResults == totalResults) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality()
                .equals(other._categoryCount, _categoryCount) &&
            (identical(other.averagePrice, averagePrice) ||
                other.averagePrice == averagePrice) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      query,
      const DeepCollectionEquality().hash(_products),
      const DeepCollectionEquality().hash(_categories),
      totalResults,
      timestamp,
      const DeepCollectionEquality().hash(_categoryCount),
      averagePrice,
      averageRating);

  /// Create a copy of SearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResultModelImplCopyWith<_$SearchResultModelImpl> get copyWith =>
      __$$SearchResultModelImplCopyWithImpl<_$SearchResultModelImpl>(
          this, _$identity);
}

abstract class _SearchResultModel implements SearchResultModel {
  const factory _SearchResultModel(
      {required final String query,
      required final List<ProductModel> products,
      required final List<String> categories,
      required final int totalResults,
      required final DateTime timestamp,
      final Map<String, int> categoryCount,
      final double? averagePrice,
      final double? averageRating}) = _$SearchResultModelImpl;

  @override
  String get query;
  @override
  List<ProductModel> get products;
  @override
  List<String> get categories;
  @override
  int get totalResults;
  @override
  DateTime get timestamp;
  @override
  Map<String, int> get categoryCount;
  @override
  double? get averagePrice;
  @override
  double? get averageRating;

  /// Create a copy of SearchResultModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchResultModelImplCopyWith<_$SearchResultModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
