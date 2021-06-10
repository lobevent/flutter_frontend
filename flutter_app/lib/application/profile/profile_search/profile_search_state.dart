part of 'profile_search_cubit.dart';

@freezed
class ProfileSearchState with _$ProfileSearchState {


  factory ProfileSearchState.initial() = _Initial;

  factory ProfileSearchState.loading() =
      _LoadingProgress;

  factory ProfileSearchState.loaded({required List<Profile> profiles}) =
      _Loaded;

  factory ProfileSearchState.error({required String error}) = _LoadFailure;
}
