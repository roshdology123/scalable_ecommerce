import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'notification_sync_state.dart';

class NotificationSyncCubit extends Cubit<NotificationSyncState> {
  NotificationSyncCubit() : super(NotificationSyncInitial());
}
