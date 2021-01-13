import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_frontend/domain/auth/user.dart';

import 'auth_failure.dart';

abstract class IAuthFacade {
  Option<User> getSignedInUser();
  Future<Either<AuthFailure, Unit>> startPhoneNumberSignInFlow({
    @required String phoneNumber
  });
  Future<Either<AuthFailure, Unit>> resendSmsCode();
  Future<Either<AuthFailure, Unit>> signInWithReceivedSmsCode({
    @required String smsCode
  });
  Future<Either<AuthFailure, Unit>> signInWithGoogle();
  Future<bool> signInWithAppleAvailable();
  Future<Either<AuthFailure, Unit>> signInWithApple();
  Future<void> signOut();
}
