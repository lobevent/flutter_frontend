import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_frontend/domain/auth/auth_failure.dart';
import 'package:flutter_frontend/domain/auth/i_auth_facade.dart';
import 'package:flutter_frontend/domain/auth/value_objects.dart';

part 'sign_in_form_state.dart';
part 'sign_in_form_cubit.freezed.dart';

class SignInFormCubit extends Cubit<SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormCubit({required IAuthFacade authFacade}) 
    : _authFacade = authFacade,
      super(SignInFormState.initial());

  Future<void> startGoogleSignIn() async {
    emit(state.copyWith(isSubmitting: true));
    Either<AuthFailure, Unit> result = await _authFacade.signInWithGoogle();
  }

  Future<void> startAppleSignIn() async {
    emit(state.copyWith(isSubmitting: true));
    Either<AuthFailure, Unit> result = await _authFacade.signInWithApple();
  }
}



