import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'notification_stats_state.dart';

class NotificationStatsCubit extends Cubit<NotificationStatsState> {
  NotificationStatsCubit() : super(NotificationStatsInitial());
}
