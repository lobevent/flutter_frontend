part of 'event_screen_cubit.dart';

@freezed
class EventScreenState with _$EventScreenState{

  factory EventScreenState.initial()= _Initial;
  factory EventScreenState.loading()= _LoadInProgress;
  factory EventScreenState.loaded({required Event event})= _Loaded;
  factory EventScreenState.error({required EventFailure failure})= _LoadFailure;

}
