import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'auth_failure.freezed.dart';

@freezed
abstract class AuthFailure with _$AuthFailure {
  const factory AuthFailure.cancelledByUser() = CancelledByUser;
  const factory AuthFailure.serverError() = ServerError;
  const factory AuthFailure.emailAlreadyInUse() = EmailAlreadyInUse;
  const factory AuthFailure.invalidEmailAndPasswordCombination() =
    InvalidEmailAndPasswordCombination;

  const factory AuthFailure.autoPhoneAuthFailed() = AutoPhoneAuthFailed;
  const factory AuthFailure.badPhoneNumber() = BadPhoneNumber;
  const factory AuthFailure.unknownFirebaseAuthException() = 
    UnknownFirebaseAuthException;
}
