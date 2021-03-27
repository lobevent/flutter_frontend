part of 'event_screen_cubit.dart';

@freezed
class EventScreenState with _$EventScreenState{


  factory EventScreenState.loading()= LoadInProgress;
  factory EventScreenState.loaded({required Event event})= _Loaded;
  factory EventScreenState.error({required EventFailure failure})= _LoadFailure;

}
