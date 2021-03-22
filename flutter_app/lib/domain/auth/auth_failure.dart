import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'auth_failure.freezed.dart';

@freezed
class AuthFailure with _$AuthFailure {
  const factory AuthFailure.cancelledByUser() = _CancelledByUser;
  const factory AuthFailure.serverError() = _ServerError;
  const factory AuthFailure.appleSignInNotSupported() = _AppleSignInNotSupported;
  const factory AuthFailure.appleSignInAuthError() = _AppleSignInAuthError;
  const factory AuthFailure.invalidCredential() = _InvalidCredential;
  const factory AuthFailure.autoPhoneAuthFailed() = _AutoPhoneAuthFailed;
  const factory AuthFailure.badPhoneNumber() = _BadPhoneNumber;
  const factory AuthFailure.unknownFirebaseAuthException({
    required String code,
  }) = _UnknownFirebaseAuthException;
}
