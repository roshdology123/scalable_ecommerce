import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../errors/failures.dart';

/// Base interface for all use cases in the application
///
/// [Type] - The return type of the use case
/// [Params] - The parameters required by the use case
abstract class UseCase<Type, Params> {
  /// The main method that executes the use case logic
  ///
  /// Returns [Either<Failure, Type>] where:
  /// - Left side contains [Failure] if something goes wrong
  /// - Right side contains [Type] if the operation succeeds
  Future<Either<Failure, Type>> call(Params params);
}

/// Base interface for synchronous use cases
///
/// [Type] - The return type of the use case
/// [Params] - The parameters required by the use case
abstract class SyncUseCase<Type, Params> {
  /// The main method that executes the use case logic synchronously
  ///
  /// Returns [Either<Failure, Type>] where:
  /// - Left side contains [Failure] if something goes wrong
  /// - Right side contains [Type] if the operation succeeds
  Either<Failure, Type> call(Params params);
}

/// Base interface for stream-based use cases
///
/// [Type] - The return type of the use case
/// [Params] - The parameters required by the use case
abstract class StreamUseCase<Type, Params> {
  /// The main method that executes the use case logic and returns a stream
  ///
  /// Returns [Stream<Either<Failure, Type>>] where:
  /// - Left side contains [Failure] if something goes wrong
  /// - Right side contains [Type] if the operation succeeds
  Stream<Either<Failure, Type>> call(Params params);
}

/// Use this class when the use case doesn't require any parameters
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}

/// Use this class when the use case only requires an ID parameter
class IdParams extends Equatable {
  final int id;

  const IdParams({required this.id});

  @override
  List<Object?> get props => [id];

  @override
  String toString() => 'IdParams(id: $id)';
}

/// Use this class when the use case only requires a string parameter
class StringParams extends Equatable {
  final String value;

  const StringParams({required this.value});

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'StringParams(value: $value)';
}

/// Use this class for pagination parameters
class PaginationParams extends Equatable {
  final int page;
  final int limit;
  final String? sortBy;
  final String? sortOrder; // 'asc' or 'desc'

  const PaginationParams({
    required this.page,
    required this.limit,
    this.sortBy,
    this.sortOrder = 'asc',
  });

  /// Calculate offset for database queries
  int get offset => (page - 1) * limit;

  /// Check if sorting is enabled
  bool get hasSorting => sortBy != null && sortBy!.isNotEmpty;

  /// Check if sort order is descending
  bool get isDescending => sortOrder?.toLowerCase() == 'desc';

  PaginationParams copyWith({
    int? page,
    int? limit,
    String? sortBy,
    String? sortOrder,
  }) {
    return PaginationParams(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [page, limit, sortBy, sortOrder];

  @override
  String toString() {
    return 'PaginationParams(page: $page, limit: $limit, sortBy: $sortBy, sortOrder: $sortOrder)';
  }
}

/// Use this class for search parameters with optional filters
class SearchParams extends Equatable {
  final String query;
  final Map<String, dynamic>? filters;
  final PaginationParams? pagination;

  const SearchParams({
    required this.query,
    this.filters,
    this.pagination,
  });

  SearchParams copyWith({
    String? query,
    Map<String, dynamic>? filters,
    PaginationParams? pagination,
  }) {
    return SearchParams(
      query: query ?? this.query,
      filters: filters ?? this.filters,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  List<Object?> get props => [query, filters, pagination];

  @override
  String toString() {
    return 'SearchParams(query: $query, filters: $filters, pagination: $pagination)';
  }
}

/// Use this class for filter-only parameters (without search query)
class FilterParams extends Equatable {
  final Map<String, dynamic> filters;
  final PaginationParams? pagination;

  const FilterParams({
    required this.filters,
    this.pagination,
  });

  FilterParams copyWith({
    Map<String, dynamic>? filters,
    PaginationParams? pagination,
  }) {
    return FilterParams(
      filters: filters ?? this.filters,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  List<Object?> get props => [filters, pagination];

  @override
  String toString() {
    return 'FilterParams(filters: $filters, pagination: $pagination)';
  }
}

/// Use this class for date range parameters
class DateRangeParams extends Equatable {
  final DateTime startDate;
  final DateTime endDate;

  const DateRangeParams({
    required this.startDate,
    required this.endDate,
  });

  /// Get the duration between start and end dates
  Duration get duration => endDate.difference(startDate);

  /// Check if the date range is valid (start before end)
  bool get isValid => startDate.isBefore(endDate);

  /// Check if a given date is within this range
  bool contains(DateTime date) {
    return date.isAfter(startDate) && date.isBefore(endDate);
  }

  DateRangeParams copyWith({
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return DateRangeParams(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  List<Object?> get props => [startDate, endDate];

  @override
  String toString() {
    return 'DateRangeParams(startDate: $startDate, endDate: $endDate)';
  }
}

/// Use this class for file upload parameters
class FileUploadParams extends Equatable {
  final String filePath;
  final String? fileName;
  final String? mimeType;
  final Map<String, dynamic>? metadata;

  const FileUploadParams({
    required this.filePath,
    this.fileName,
    this.mimeType,
    this.metadata,
  });

  FileUploadParams copyWith({
    String? filePath,
    String? fileName,
    String? mimeType,
    Map<String, dynamic>? metadata,
  }) {
    return FileUploadParams(
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      mimeType: mimeType ?? this.mimeType,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [filePath, fileName, mimeType, metadata];

  @override
  String toString() {
    return 'FileUploadParams(filePath: $filePath, fileName: $fileName, mimeType: $mimeType)';
  }
}

/// Utility class for creating common parameter objects
class UseCaseParams {
  const UseCaseParams._();

  /// Create an ID parameter
  static IdParams id(int id) => IdParams(id: id);

  /// Create a string parameter
  static StringParams string(String value) => StringParams(value: value);

  /// Create pagination parameters
  static PaginationParams pagination({
    required int page,
    required int limit,
    String? sortBy,
    String? sortOrder,
  }) =>
      PaginationParams(
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

  /// Create search parameters
  static SearchParams search(
      String query, {
        Map<String, dynamic>? filters,
        PaginationParams? pagination,
      }) =>
      SearchParams(
        query: query,
        filters: filters,
        pagination: pagination,
      );

  /// Create filter parameters
  static FilterParams filter(
      Map<String, dynamic> filters, {
        PaginationParams? pagination,
      }) =>
      FilterParams(
        filters: filters,
        pagination: pagination,
      );

  /// Create date range parameters
  static DateRangeParams dateRange(DateTime start, DateTime end) =>
      DateRangeParams(startDate: start, endDate: end);

  /// Create file upload parameters
  static FileUploadParams fileUpload(
      String filePath, {
        String? fileName,
        String? mimeType,
        Map<String, dynamic>? metadata,
      }) =>
      FileUploadParams(
        filePath: filePath,
        fileName: fileName,
        mimeType: mimeType,
        metadata: metadata,
      );
}

/// Extension methods for Either<Failure, T> to make working with use case results easier
extension UseCaseExtensions<T> on Either<Failure, T> {
  /// Get the success value or throw an exception with the failure message
  T getOrThrow() {
    return fold(
          (failure) => throw Exception(failure.message),
          (success) => success,
    );
  }

  /// Get the success value or return a default value
  T getOrElse(T defaultValue) {
    return fold(
          (failure) => defaultValue,
          (success) => success,
    );
  }

  /// Get the success value or return the result of calling orElse function
  T getOrCall(T Function() orElse) {
    return fold(
          (failure) => orElse(),
          (success) => success,
    );
  }

  /// Check if the result is a success
  bool get isSuccess => isRight();

  /// Check if the result is a failure
  bool get isFailure => isLeft();

  /// Get the failure if present, otherwise null
  Failure? get failure => fold(
        (failure) => failure,
        (success) => null,
  );

  /// Get the success value if present, otherwise null
  T? get success => fold(
        (failure) => null,
        (success) => success,
  );

  /// Execute a function if the result is a success
  Either<Failure, T> onSuccess(void Function(T value) onSuccess) {
    return fold(
          (failure) => Left(failure),
          (success) {
        onSuccess(success);
        return Right(success);
      },
    );
  }

  /// Execute a function if the result is a failure
  Either<Failure, T> onFailure(void Function(Failure failure) onFailure) {
    return fold(
          (failure) {
        onFailure(failure);
        return Left(failure);
      },
          (success) => Right(success),
    );
  }
}