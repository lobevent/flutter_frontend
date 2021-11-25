part of 'profile_page_cubit.dart';

@freezed
class ProfilePageState with _$ProfilePageState {
  factory ProfilePageState.loading() = ProfileLoadInProgress;
  factory ProfilePageState.loaded(
      {required Profile profile, List<Profile>? friends}) = _ProfilePageLoaded;
  factory ProfilePageState.error({required String error}) = _ProfilePageError;
}
