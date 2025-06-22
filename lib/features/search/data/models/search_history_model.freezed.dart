// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SearchHistoryModel {
  List<SearchQueryModel> get queries => throw _privateConstructorUsedError;
  List<SearchSuggestionModel> get suggestions =>
      throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  /// Create a copy of SearchHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SearchHistoryModelCopyWith<SearchHistoryModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchHistoryModelCopyWith<$Res> {
  factory $SearchHistoryModelCopyWith(
          SearchHistoryModel value, $Res Function(SearchHistoryModel) then) =
      _$SearchHistoryModelCopyWithImpl<$Res, SearchHistoryModel>;
  @useResult
  $Res call(
      {List<SearchQueryModel> queries,
      List<SearchSuggestionModel> suggestions,
      DateTime lastUpdated});
}

/// @nodoc
class _$SearchHistoryModelCopyWithImpl<$Res, $Val extends SearchHistoryModel>
    implements $SearchHistoryModelCopyWith<$Res> {
  _$SearchHistoryModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SearchHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? queries = null,
    Object? suggestions = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      queries: null == queries
          ? _value.queries
          : queries // ignore: cast_nullable_to_non_nullable
              as List<SearchQueryModel>,
      suggestions: null == suggestions
          ? _value.suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<SearchSuggestionModel>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchHistoryModelImplCopyWith<$Res>
    implements $SearchHistoryModelCopyWith<$Res> {
  factory _$$SearchHistoryModelImplCopyWith(_$SearchHistoryModelImpl value,
          $Res Function(_$SearchHistoryModelImpl) then) =
      __$$SearchHistoryModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SearchQueryModel> queries,
      List<SearchSuggestionModel> suggestions,
      DateTime lastUpdated});
}

/// @nodoc
class __$$SearchHistoryModelImplCopyWithImpl<$Res>
    extends _$SearchHistoryModelCopyWithImpl<$Res, _$SearchHistoryModelImpl>
    implements _$$SearchHistoryModelImplCopyWith<$Res> {
  __$$SearchHistoryModelImplCopyWithImpl(_$SearchHistoryModelImpl _value,
      $Res Function(_$SearchHistoryModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SearchHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? queries = null,
    Object? suggestions = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$SearchHistoryModelImpl(
      queries: null == queries
          ? _value._queries
          : queries // ignore: cast_nullable_to_non_nullable
              as List<SearchQueryModel>,
      suggestions: null == suggestions
          ? _value._suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<SearchSuggestionModel>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$SearchHistoryModelImpl implements _SearchHistoryModel {
  const _$SearchHistoryModelImpl(
      {required final List<SearchQueryModel> queries,
      required final List<SearchSuggestionModel> suggestions,
      required this.lastUpdated})
      : _queries = queries,
        _suggestions = suggestions;

  final List<SearchQueryModel> _queries;
  @override
  List<SearchQueryModel> get queries {
    if (_queries is EqualUnmodifiableListView) return _queries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_queries);
  }

  final List<SearchSuggestionModel> _suggestions;
  @override
  List<SearchSuggestionModel> get suggestions {
    if (_suggestions is EqualUnmodifiableListView) return _suggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestions);
  }

  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'SearchHistoryModel(queries: $queries, suggestions: $suggestions, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchHistoryModelImpl &&
            const DeepCollectionEquality().equals(other._queries, _queries) &&
            const DeepCollectionEquality()
                .equals(other._suggestions, _suggestions) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_queries),
      const DeepCollectionEquality().hash(_suggestions),
      lastUpdated);

  /// Create a copy of SearchHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchHistoryModelImplCopyWith<_$SearchHistoryModelImpl> get copyWith =>
      __$$SearchHistoryModelImplCopyWithImpl<_$SearchHistoryModelImpl>(
          this, _$identity);
}

abstract class _SearchHistoryModel implements SearchHistoryModel {
  const factory _SearchHistoryModel(
      {required final List<SearchQueryModel> queries,
      required final List<SearchSuggestionModel> suggestions,
      required final DateTime lastUpdated}) = _$SearchHistoryModelImpl;

  @override
  List<SearchQueryModel> get queries;
  @override
  List<SearchSuggestionModel> get suggestions;
  @override
  DateTime get lastUpdated;

  /// Create a copy of SearchHistoryModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SearchHistoryModelImplCopyWith<_$SearchHistoryModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
