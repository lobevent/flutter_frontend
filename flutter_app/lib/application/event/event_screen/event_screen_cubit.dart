import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'event_screen_state.dart';

class EventScreenCubit extends Cubit<EventScreenState> {
  EventScreenCubit() : super(EventScreenInitial());
}
