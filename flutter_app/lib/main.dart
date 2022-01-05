import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/application/auth/sign_in_form/sign_in_form_cubit.dart';
import 'package:flutter_frontend/injection_container.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart'
    as app_router;
import 'package:get_it/get_it.dart';
import 'dart:io' show Platform;

//final app_router.Router appRouter = app_router.Router();

//final GlobalKey<AutoRouterState> navigatorKey = new GlobalKey<AutoRouterState>();
Future<void> main() async {
  if (Platform.isAndroid) {
    await dotenv.load(fileName: ".env");
  } else if (Platform.isIOS) {
    await dotenv.load(fileName: ".env.ios");
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await InjectionContainer.injectDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final app_router.Router appRouter = app_router.Router();


  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider<SignInFormCubit>(
            create: (context) => GetIt.I<SignInFormCubit>()),
      ],
      child: MaterialApp.router(
          routerDelegate: appRouter.delegate(),
          routeInformationParser: appRouter.defaultRouteParser()),
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
