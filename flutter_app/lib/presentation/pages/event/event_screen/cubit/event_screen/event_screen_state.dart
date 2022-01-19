part of 'event_screen_cubit.dart';

@freezed
class EventScreenState with _$EventScreenState {
  const factory EventScreenState.loading() = LoadInProgress;
  const factory EventScreenState.loaded({required Event event}) = Loaded;

  const factory EventScreenState.addEditItemFailute({required Event event, required NetWorkFailure failure}) = AddEditItemFailure;
  const factory EventScreenState.error({required NetWorkFailure failure}) =
      _LoadFailure; //TODO here it's not a failure anymore

}
