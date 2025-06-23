import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'notification_preferences_state.dart';

class NotificationPreferencesCubit extends Cubit<NotificationPreferencesState> {
  NotificationPreferencesCubit() : super(NotificationPreferencesInitial());
}
