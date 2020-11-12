import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

import 'package:flutter_frontend/domain/auth/user.dart';
import 'package:flutter_frontend/domain/auth/auth_failure.dart';
import 'package:flutter_frontend/domain/auth/i_auth_facade.dart';
import 'package:flutter_frontend/infrastructure/auth/user_dto.dart';

class FirebaseAuthFacade implements IAuthFacade {
  final FirebaseAuth _firebaseAuth;
  final GoogleAuthProvider _googleAuthProvider;

  const FirebaseAuthFacade(
      this._firebaseAuth,
      this._googleAuthProvider
  );

  @override
  Option<User> getSignedInUser() 
    => optionOf(UserDto.fromFirebase(_firebaseAuth.currentUser).toDomain());

  @override
  Future<Either<AuthFailure, Unit>> signInWithApple() {
    // TODO: implement signInWithApple
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithGoogle() {
    // try {
    //   final googleUser = await _googleSignIn.signIn();

    //   if (googleUser == null) {
    //     return left(const AuthFailure.cancelledByUser());
    //   }

    //   final googleAuthentication = await googleUser.authentication;
    //   final authCredential = GoogleAuthProvider.getCredential(
    //     accessToken: googleAuthentication.accessToken,
    //     idToken: googleAuthentication.idToken,
    //   );
    //   return _firebaseAuth
    //       .signInWithCredential(authCredential)
    //       .then((r) => right(unit));
    // } on PlatformException catch (_) {
    //   return left(const AuthFailure.serverError());
    // }
  }

  @override
  Future<Either<AuthFailure, Unit>> startPhoneNumberSignInFlow({String phoneNumber}) {
    // TODO: implement startPhoneNumberSignInFlow
    throw UnimplementedError();
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithReceivedSmsCode({@required String smsCode}) {
    // TODO: implement signInWithReceivedSmsCode
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

}

