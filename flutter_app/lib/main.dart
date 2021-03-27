import 'package:flutter/material.dart';
import 'package:flutter_frontend/infrastructure/auth/firebase_auth_facade.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart' as app_router;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_frontend/application/auth/sign_in_form/sign_in_form_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}


/// TODO get some good working Dependency Injection running


class MyApp extends StatelessWidget {
  final _appRouter = app_router.Router();

  final Future<FirebaseApp> _firebaseInit = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return
      MultiBlocProvider(
      providers: [
        BlocProvider<SignInFormCubit>(
          create: (context) => SignInFormCubit(
            authFacade: FirebaseAuthFacade(
              FirebaseAuth.instance,
              GoogleSignIn.standard(scopes: [
                "email", "profile"
              ]),
            ),
          ),
        ),
      ],
      child: MaterialApp.router(
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser()
      ),
    );
    //   (
    //   title: 'Material App',
    //   builder: ExtendedNavigator.builder<app_router.Router>(router: app_router.Router()),
      //home: FeedScreen(),
//      BlocProvider(
//        create: (context) => SignInFormCubit(null),
//        child: LoginScreen(),
      //),
   // );
  }
}

