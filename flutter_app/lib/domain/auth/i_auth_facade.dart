import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/auth/value_objects.dart';
import 'package:meta/meta.dart';

import 'auth_failure.dart';

abstract class IAuthFacade {
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    @required EmailAddress emailAddress,
    @required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    @required EmailAddress emailAddress,
    @required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithGoogle();
}
