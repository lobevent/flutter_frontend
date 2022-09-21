part of 'profile_page_cubit.dart';

@freezed
class ProfilePageState with _$ProfilePageState {
  factory ProfilePageState.loading() = ProfileLoadInProgress;
  factory ProfilePageState.loaded(
      {required Profile profile,
      List<Profile>? friends,
      @Default([]) List<XFile?> images}) = _ProfilePageLoaded;
  factory ProfilePageState.reloadScore(
      {required Profile profile,
      required String score,
      List<Profile>? friends,
      @Default([]) List<XFile?> images}) = _ProfilePageReloadedScore;
  factory ProfilePageState.error({required String error}) = _ProfilePageError;
}
