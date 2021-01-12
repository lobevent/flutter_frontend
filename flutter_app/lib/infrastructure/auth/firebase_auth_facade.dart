import 'dart:async';

import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

import 'package:flutter_frontend/domain/auth/user.dart';
import 'package:flutter_frontend/domain/auth/auth_failure.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/auth/i_auth_facade.dart';
import 'package:flutter_frontend/infrastructure/auth/user_dto.dart';

class FirebaseAuthFacade implements IAuthFacade {
  final FirebaseAuth _firebaseAuth;
  final GoogleAuthProvider _googleAuthProvider;

  Option<String> _lastPhoneNumber = none();
  Option<String> _lastPhoneVerificationId = none();
  Option<int> _lastPhoneResendToken = none();

  FirebaseAuthFacade(
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
    return Future.value(right(unit));
  }

  /// This function starts the PhoneNumberAuthProcess BUT
  /// on Android:
  /// it tries to auto authenticate the phone number for 30s if this works
  /// the function will return with right(unit). If after 30s no SMS could be 
  /// used to auto authenticate the phone number, than this function returns
  /// AutoPhoneAuthFailed. Now the SMS code has to be manually entered
  /// by the user. After that call [signInWithReceivedSmsCode] with the SMS code
  /// on iOS:
  /// this function will always return with AutoPhoneAuthFailed (but maybe it
  /// needs the default 30s to return - since AutoPhoneAuth feature isn't 
  /// supported on iOS). Just ask the user for the SMS code and use it to call
  /// [signInWithReceivedSmsCode]
  /// 
  /// On both devices you should direct the user instantly to the SMS code 
  /// entering page and listen in the background for the return value of this
  /// function if it returns:
  ///   - AutoPhoneAuthFailed use [signInWithReceivedSmsCode]
  ///   - Unit than user is logged in
  ///   - other Failures handle them properly
  @override
  Future<Either<AuthFailure, Unit>> startPhoneNumberSignInFlow({String phoneNumber}) async {

    _lastPhoneNumber = some(phoneNumber);

    final Completer<Either<AuthFailure, Unit>> loginResultCompleter = Completer();

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber, 
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        final Either<AuthFailure, Unit> loginResult = 
          await _signInWithCredential(phoneAuthCredential);
        loginResultCompleter.complete(loginResult);
      }, 
      verificationFailed: (FirebaseAuthException phoneAuthException) {
        AuthFailure authFailure;
        switch (phoneAuthException.code) {
          case "invalid-phone-number":
            authFailure = const BadPhoneNumber();
            break;
          default:
            authFailure = const UnknownFirebaseAuthException();
        }
        loginResultCompleter.complete(left(authFailure));
      }, 
      codeSent: (String phoneVerificationId, int resendToken) {
        _lastPhoneVerificationId = some(phoneVerificationId);
        _lastPhoneResendToken = some(resendToken);
      }, 
      codeAutoRetrievalTimeout: (String phoneVerificationId) {
        _lastPhoneVerificationId = some(phoneVerificationId);
        loginResultCompleter.complete(left(const AutoPhoneAuthFailed()));
      },
      forceResendingToken: _lastPhoneResendToken.getOrElse(() => null),
    );

    return loginResultCompleter.future;
  }

  @override
  Future<Either<AuthFailure, Unit>> resendSmsCode() {
    final String phoneNumber = _lastPhoneNumber.getOrElse(() {
      throw PhoneVerificationNotStarted();
    });

    return startPhoneNumberSignInFlow(phoneNumber: phoneNumber);
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithReceivedSmsCode({@required String smsCode}) async {
    final String phoneVerificationId = _lastPhoneVerificationId.getOrElse(() {
      throw PhoneVerificationNotStarted();
    });
    
    final AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: phoneVerificationId,
      smsCode: smsCode
    );

    return _signInWithCredential(phoneAuthCredential);
  }

  Future<Either<AuthFailure, Unit>> _signInWithCredential(AuthCredential credential) async {
    try {
      await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (firebaseAuthException) {
      switch (firebaseAuthException.code) {
        //TODO add relevant failures
        case "invalid-verification-code":
          break;
        case "invalid-verification-id":
          break;
        default: 
          return left(const UnknownFirebaseAuthException());
      }
    }

    _clearPhoneAuthTokens();

    return right(unit);
  }

  /// This method clears the temporary needed fields [_lastPhoneVerificationId]
  /// and [_lastPhoneResendToken]. It isn't necessary but could prevent
  /// some potential errors
  void _clearPhoneAuthTokens() {
    _lastPhoneNumber = none();
    _lastPhoneVerificationId = none();
    _lastPhoneResendToken = none();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

}

