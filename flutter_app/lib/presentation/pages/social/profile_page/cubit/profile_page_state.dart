part of 'profile_page_cubit.dart';

@freezed
class ProfilePageState with _$ProfilePageState {
  factory ProfilePageState.loading() = ProfileLoadInProgress;
  factory ProfilePageState.loaded({required Profile profile, List<Profile>? friends, @Default([]) List<XFile?> images}) = _ProfilePageLoaded;
  factory ProfilePageState.error({required String error}) = _ProfilePageError;
}
