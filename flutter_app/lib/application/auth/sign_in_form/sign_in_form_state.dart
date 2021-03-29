part of 'sign_in_form_cubit.dart';

@freezed
class SignInFormState with _$SignInFormState {
  const factory SignInFormState({
    required PhoneNumberPrefix phoneNumberPrefix,
    required PhoneNumber phoneNumber,
    required bool showErrorMessages,
    required bool isSubmitting,
    required Option<Either<AuthFailure, Unit>> authFailureOrSuccessOption,
  }) = _SignInFormState;

  factory SignInFormState.initial() => SignInFormState(
    phoneNumberPrefix: PhoneNumberPrefix("+49"),
    phoneNumber: PhoneNumber(""),
    showErrorMessages: false,
    isSubmitting: false,
    authFailureOrSuccessOption: none(),
  );
}