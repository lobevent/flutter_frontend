part of 'event_screen_cubit.dart';

@freezed
class EventScreenState with _$EventScreenState {
  factory EventScreenState.loading() = LoadInProgress;
  factory EventScreenState.loaded({required Event event}) = Loaded;
  factory EventScreenState.addEditItemFailute({required Event event, required NetWorkFailure failure}) = AddEditItemFailure;
  factory EventScreenState.error({required NetWorkFailure failure}) =
      _LoadFailure; //TODO here it's not a failure anymore

}
