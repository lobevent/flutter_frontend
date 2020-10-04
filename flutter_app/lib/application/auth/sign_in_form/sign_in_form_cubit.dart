import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/auth/auth_failure.dart';
import 'package:flutter_frontend/domain/auth/i_auth_facade.dart';
import 'package:flutter_frontend/domain/auth/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'sign_in_form_state.dart';
part 'sign_in_form_cubit.freezed.dart';

class SignInFormCubit extends Cubit<SignInFormState> {
  final IAuthFacade _authFacade;

  SignInFormCubit(this._authFacade) : super(null);
  

  @override
  SignInFormState get initialState => SignInFormState.initial();

  Future<void> emailChanged(String emailStr) async{
    emit(state.copyWith(
      emailAddress: EmailAddress(emailStr),
      authFailureOrSuccessOption: none(),
    )
    );
  }
  Future<void> passwordChanged(String passwordStr) async{
    emit(state.copyWith(
      password: Password(passwordStr),
      authFailureOrSuccessOption: none(),
    )
    );
  }
  Future<void> registerWithEmailAndPasswordPressed() async{
    Either<AuthFailure, Unit> failureOrSuccess;

    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit (state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      )
      );

      failureOrSuccess = await _authFacade.registerWithEmailAndPassword(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }
    emit (state.copyWith(
      isSubmitting: false,
      showErrorMessages: true,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    )
    );
  }
  Future<void> signInWithEmailAndPasswordPressed() async{
    Either<AuthFailure, Unit> failureOrSuccess;

    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit (state.copyWith(
        isSubmitting: true,
        authFailureOrSuccessOption: none(),
      )
      );

      failureOrSuccess = await _authFacade.signInWithEmailAndPassword(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }
    emit (state.copyWith(
      isSubmitting: false,
      showErrorMessages: true,
      authFailureOrSuccessOption: optionOf(failureOrSuccess),
    )
    );
  }
  Future<void> signInWithGooglePressed() async{
    emit(state.copyWith(
      isSubmitting: true,
      authFailureOrSuccessOption: none(),
      )
    );
    final failureOrSuccess = await _authFacade.signInWithGoogle();
    emit (state.copyWith(
        isSubmitting: false,
        authFailureOrSuccessOption: some(failureOrSuccess)
        )
    );
  }
}



