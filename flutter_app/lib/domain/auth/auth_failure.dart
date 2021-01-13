import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'auth_failure.freezed.dart';

@freezed
abstract class AuthFailure with _$AuthFailure {
  const factory AuthFailure.cancelledByUser() = CancelledByUser;
  const factory AuthFailure.serverError() = ServerError;
  const factory AuthFailure.appleSignInNotSupported() = AppleSignInNotSupported;
  const factory AuthFailure.appleSignInAuthError() = AppleSignInAuthError;
  const factory AuthFailure.invalidCredential() = InvalidCredential;
  const factory AuthFailure.invalidVerificationCode() = InvalidVerificationCode;
  const factory AuthFailure.invalidVerificationId() = InvalidVerificationId;
  const factory AuthFailure.autoPhoneAuthFailed() = AutoPhoneAuthFailed;
  const factory AuthFailure.badPhoneNumber() = BadPhoneNumber;
  const factory AuthFailure.unknownFirebaseAuthException() = 
    UnknownFirebaseAuthException;
}
