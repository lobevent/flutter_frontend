part of 'profile_search_cubit.dart';

@freezed
class ProfileSearchState with _$ProfileSearchState{
  const factory ProfileSearchState({
    required String? profileName,
    required List<Profile> profiles,
    required bool showErrorMessages,
    required bool isSubmitting,
}) = _ProfileSearchState;


  //in the initial state we can show the old profilenamesearchqueries from the user like in https://resocoder.com/2021/01/23/search-bar-in-flutter-logic-material-ui/
  factory ProfileSearchState.initial() =>
      ProfileSearchState(
          profileName: '',
          profiles: List.empty(), //todo implement searchhistory
          showErrorMessages: false,
          isSubmitting: false);

  factory ProfileSearchState.loading({required String profileName}) = _LoadingProgress;

  factory ProfileSearchState.loaded({required List<Profile> profiles}) = _Loaded;

  factory ProfileSearchState.error({required ProfileFailure failure}) = _LoadFailure;



}

