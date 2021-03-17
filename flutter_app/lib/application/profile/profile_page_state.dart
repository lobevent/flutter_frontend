part of 'profile_page_cubit.dart';

@freezed
abstract class ProfilePageState with _$ProfilePageState {
  const factory ProfilePageState({
    @required Profile profile,
    @required bool showErrorMessages,
    @required bool isSubmitting,
    @required Option<Either<ProfileFailure, Unit>> showFailureOrSuccessOption
  }) = _ProfilePageState;


  factory ProfilePageState.initial() =>
      ProfilePageState(
        profile: Profile(id: null, name: null), //todo
        showErrorMessages: false,
        isSubmitting: false,
        showFailureOrSuccessOption: none(),
      );
}