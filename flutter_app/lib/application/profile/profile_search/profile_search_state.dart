part of 'profile_search_cubit.dart';

@freezed
class ProfileSearchState with _$ProfileSearchState {


  factory ProfileSearchState.initial() = _Initial;

  factory ProfileSearchState.loading() =
      _LoadingProgress;

  factory ProfileSearchState.loadedProfiles({required List<Profile> profiles}) =
  _LoadedProfiles;

  factory ProfileSearchState.loadedEvents({required List<Event> events}) =
  _LoadedEvents;

  factory ProfileSearchState.loadedBoth({required List<Profile> profiles, required List<Event> events}) =
      _Loaded;

  factory ProfileSearchState.error({required String error}) = _LoadFailure;
}
