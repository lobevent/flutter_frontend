import 'package:flutter_frontend/application/auth/sign_in_form/sign_in_form_cubit.dart';
import 'package:flutter_frontend/infrastructure/auth/firebase_auth_facade.dart';
import 'package:get_it/get_it.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class InjectionContainer {
  // get an instance of the GetIt singleton to use for injection
  static final GetIt getIt = GetIt.I; // equal to: GetIt.instance;

  static Future<void> injectDependencies() async {
    getIt.registerLazySingleton<FirebaseAuthFacade>(() => FirebaseAuthFacade(
      FirebaseAuth.instance,
      GoogleSignIn.standard(
        scopes: [
          "email", "profile"
        ]
      )
    ));

    getIt.registerLazySingleton(() => SignInFormCubit(
      authFacade: getIt<FirebaseAuthFacade>()
    ));
  }
}