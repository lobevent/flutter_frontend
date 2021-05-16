part of 'profile_page_cubit.dart';

@freezed
class ProfilePageState with _$ProfilePageState {
  factory ProfilePageState.initial() = _ProfilePageInitial;
  factory ProfilePageState.loaded({required Profile profile}) = _ProfilePageLoaded;
  factory ProfilePageState.error({required String error}) = _ProfilePageError;

}