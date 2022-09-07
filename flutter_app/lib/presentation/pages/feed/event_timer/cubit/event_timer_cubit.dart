  import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'event_timer_state.dart';

class EventTimerCubit extends Cubit<EventTimerState> {
  EventTimerCubit() : super(EventTimerInitial());
}
