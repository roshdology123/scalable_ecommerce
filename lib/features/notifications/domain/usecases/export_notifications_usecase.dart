import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/app_logger.dart';
import '../entities/notification.dart';
import '../repositories/notification_repository.dart';

@injectable
class ExportNotificationsUseCase implements UseCase<String, ExportNotificationsParams> {
  final NotificationsRepository _repository;
  final AppLogger _logger = AppLogger();

  ExportNotificationsUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(ExportNotificationsParams params) async {
    _logger.logBusinessLogic(
      'export_notifications_usecase_started',
      'usecase_execution',
      {
        'user_id': params.userId,
        'format': params.format,
        'include_read': params.includeRead,
        'from_date': params.fromDate?.toIso8601String(),
        'to_date': params.toDate?.toIso8601String(),
        'user': 'roshdology123',
        'timestamp': '2025-06-23 08:39:37',
      },
    );

    try {
      // Get notifications based on parameters
      final result = await _repository.getNotifications(
        userId: params.userId,
        since: params.fromDate,
        // Apply date filter in post-processing since repository doesn't support toDate
      );

      return result.fold(
            (failure) {
          _logger.logErrorWithContext(
            'ExportNotificationsUseCase - GetNotifications',
            failure,
            StackTrace.current,
            {
              'user_id': params.userId,
              'failure_type': failure.runtimeType.toString(),
              'user': 'roshdology123',
              'timestamp': '2025-06-23 08:39:37',
            },
          );
          return Left(failure);
        },
            (notifications) {
          // Filter notifications based on parameters
          var filteredNotifications = notifications;

          // Filter by read status
          if (!params.includeRead) {
            filteredNotifications = filteredNotifications.where((n) => !n.isRead).toList();
          }

          // Filter by date range
          if (params.toDate != null) {
            filteredNotifications = filteredNotifications
                .where((n) => n.createdAt.isBefore(params.toDate!.add(const Duration(days: 1))))
                .toList();
          }

          // Export to specified format
          final exportedData = _exportToFormat(filteredNotifications, params.format);

          _logger.logBusinessLogic(
            'export_notifications_usecase_success',
            'usecase_execution',
            {
              'user_id': params.userId,
              'format': params.format,
              'exported_notifications_count': filteredNotifications.length,
              'export_size_bytes': exportedData.length,
              'user': 'roshdology123',
              'timestamp': '2025-06-23 08:39:37',
            },
          );

          return Right(exportedData);
        },
      );
    } catch (e) {
      _logger.logErrorWithContext(
        'ExportNotificationsUseCase',
        e,
        StackTrace.current,
        {
          'user_id': params.userId,
          'format': params.format,
          'user': 'roshdology123',
          'timestamp': '2025-06-23 08:39:37',
        },
      );
      return const Left(ServerFailure(message: 'Failed to export notifications'));
    }
  }

  String _exportToFormat(List<AppNotification> notifications, ExportFormat format) {
    switch (format) {
      case ExportFormat.json:
        return _exportToJson(notifications);
      case ExportFormat.csv:
        return _exportToCsv(notifications);
      case ExportFormat.txt:
        return _exportToText(notifications);
    }
  }

  String _exportToJson(List<AppNotification> notifications) {
    final exportData = {
      'export_info': {
        'exported_at': '2025-06-23 08:39:37',
        'total_notifications': notifications.length,
        'exported_by': 'roshdology123',
        'format': 'json',
      },
      'notifications': notifications.map((notification) => {
        'id': notification.id,
        'title': notification.title,
        'body': notification.body,
        'type': notification.type.name,
        'priority': notification.priority.name,
        'created_at': notification.createdAt.toIso8601String(),
        'is_read': notification.isRead,
        'read_at': notification.readAt?.toIso8601String(),
        'image_url': notification.imageUrl,
        'action_url': notification.actionUrl,
        'category': notification.category,
        'tags': notification.tags,
        'data': notification.data,
      }).toList(),
    };

    return const JsonEncoder.withIndent('  ').convert(exportData);
  }

  String _exportToCsv(List<AppNotification> notifications) {
    final buffer = StringBuffer();

    // CSV Header
    buffer.writeln('ID,Title,Body,Type,Priority,Created At,Is Read,Read At,Category,Tags');

    // CSV Data
    for (final notification in notifications) {
      buffer.writeln([
        _csvEscape(notification.id),
        _csvEscape(notification.title),
        _csvEscape(notification.body),
        _csvEscape(notification.type.name),
        _csvEscape(notification.priority.name),
        _csvEscape(notification.createdAt.toIso8601String()),
        notification.isRead,
        _csvEscape(notification.readAt?.toIso8601String() ?? ''),
        _csvEscape(notification.category ?? ''),
        _csvEscape(notification.tags.join('; ')),
      ].join(','));
    }

    return buffer.toString();
  }

  String _exportToText(List<AppNotification> notifications) {
    final buffer = StringBuffer();

    buffer.writeln('=== NOTIFICATION EXPORT ===');
    buffer.writeln('Exported at: 2025-06-23 08:39:37');
    buffer.writeln('Total notifications: ${notifications.length}');
    buffer.writeln('Exported by: roshdology123');
    buffer.writeln('');

    for (int i = 0; i < notifications.length; i++) {
      final notification = notifications[i];
      buffer.writeln('--- Notification ${i + 1} ---');
      buffer.writeln('ID: ${notification.id}');
      buffer.writeln('Title: ${notification.title}');
      buffer.writeln('Body: ${notification.body}');
      buffer.writeln('Type: ${notification.type.name}');
      buffer.writeln('Priority: ${notification.priority.name}');
      buffer.writeln('Created: ${notification.createdAt}');
      buffer.writeln('Read: ${notification.isRead}');
      if (notification.readAt != null) {
        buffer.writeln('Read At: ${notification.readAt}');
      }
      if (notification.category != null) {
        buffer.writeln('Category: ${notification.category}');
      }
      if (notification.tags.isNotEmpty) {
        buffer.writeln('Tags: ${notification.tags.join(', ')}');
      }
      buffer.writeln('');
    }

    return buffer.toString();
  }

  String _csvEscape(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}

enum ExportFormat {
  json,
  csv,
  txt,
}

class ExportNotificationsParams extends Equatable {
  final String userId;
  final ExportFormat format;
  final bool includeRead;
  final DateTime? fromDate;
  final DateTime? toDate;

  const ExportNotificationsParams({
    required this.userId,
    this.format = ExportFormat.json,
    this.includeRead = true,
    this.fromDate,
    this.toDate,
  });

  @override
  List<Object?> get props => [userId, format, includeRead, fromDate, toDate];
}