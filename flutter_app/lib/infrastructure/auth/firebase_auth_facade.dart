import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:flutter_frontend/domain/auth/user.dart';
import 'package:flutter_frontend/domain/auth/auth_failure.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/auth/i_auth_facade.dart';
import 'package:flutter_frontend/infrastructure/auth/user_dto.dart';

/// Class for the Auth API calls. 
class FirebaseAuthFacade implements IAuthFacade {
  final FirebaseAuth _firebaseAuth;
  /// The field [_googleSignIn] should be initialized with the scopes
  /// "email" and "profile"
  final GoogleSignIn _googleSignIn;

  Option<String> _lastPhoneNumber = none();
  Option<String> _lastPhoneVerificationId = none();
  Option<int> _lastPhoneResendToken = none();

  FirebaseAuthFacade(
      this._firebaseAuth,
      this._googleSignIn
  );

  @override
  Option<User> getSignedInUser() 
    => optionOf(UserDto.fromFirebase(_firebaseAuth.currentUser).toDomain());

  @override
  Future<bool> signInWithAppleAvailable() async {
    try {
      return SignInWithApple.isAvailable();
    } catch (_) {
      return false;
    }
  }


  /// This function provides apple sign in capability. 
  /// iOS and macOS:
  /// The future returned by this function will always resolve. Either with an exception
  /// if sign in with apple isn't available or when the native UI goes away
  /// (doesn't matter if due cancellation or auth completion)
  /// 
  /// Android:
  /// An custom chrome tab will be opened for auth process. The returned future
  /// probably never resolves when the auth process was cancelled (for example
  /// by closing the chrome tab). By calling the function again all previously 
  /// returned futures will be terminated and a new sign in flow will be started
  @override
  Future<Either<AuthFailure, Unit>> signInWithApple() async {
    AuthorizationCredentialAppleID authorizationCredentialAppleID;
    try {
      authorizationCredentialAppleID = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email,AppleIDAuthorizationScopes.fullName],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: "com.maybee.service", 
          redirectUri: Uri.parse("https://lobevent.firebaseapp.com/__/auth/handler"),
        ),
      );
    } on SignInWithAppleNotSupportedException {
      return left(const AppleSignInNotSupported());
    } catch (_) {
      return left(const AppleSignInAuthError());
    }

    if (authorizationCredentialAppleID == null) {
      return left(const CancelledByUser());
    }

    final OAuthProvider oAuthProvider = OAuthProvider("apple.com");
    final AuthCredential credential = oAuthProvider.credential(
      idToken: authorizationCredentialAppleID.identityToken,
      accessToken: authorizationCredentialAppleID.authorizationCode,
    );

    return _signInWithCredential(credential);
  }

  @override
  Future<Either<AuthFailure, Unit>> signInWithGoogle() async {
    AuthCredential credential;
    try {
      // this fields hold additional info about the google account
      // normally firebase should add them to the firebase user
      final GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount == null) {
        return left(const AuthFailure.cancelledByUser());
      }

      // this field holds all the tokens required for the authentication process
      // again firebase uses them to get access to the google account
      final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

      credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );
    } on PlatformException {
      return left(const ServerError());
    }

    return _signInWithCredential(credential);
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
        switch (phoneAuthException.code) {
          case "invalid-phone-number":
            loginResultCompleter.complete(left(const BadPhoneNumber()));
            break;
          default:
            loginResultCompleter.complete(left(const UnknownFirebaseAuthException()));
        }
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
        case "invalid-credential":
          return left(const InvalidCredential());
          break;
        case "invalid-verification-code":
          return left(const InvalidVerificationCode());
          break;
        case "invalid-verification-id":
          return left(const InvalidVerificationId());
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
    // TODO implement
    throw UnimplementedError();
  }

}

