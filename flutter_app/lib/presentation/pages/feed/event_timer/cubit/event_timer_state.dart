part of 'event_timer_cubit.dart';

@freezed
class EventTimerState with _$EventTimerState{

  factory EventTimerState.initial() = _Initial;
  factory EventTimerState.loading() = _LoadInProgress;
  factory EventTimerState.loaded({Event? event}) = _Loaded;
  factory EventTimerState.error({required String error}) = _LoadFailure;

}
