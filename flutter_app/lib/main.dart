import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/application/auth/sign_in_form/sign_in_form_cubit.dart';
import 'package:flutter_frontend/injection_container.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart'
    as app_router;
import 'package:get_it/get_it.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: ".env.local");
  } catch (e) {
    await dotenv.load(fileName: ".env");
  }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  InjectionContainer.injectDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = app_router.Router();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SignInFormCubit>(
            create: (context) => GetIt.I<SignInFormCubit>()),
      ],
      child: MaterialApp.router(
          routerDelegate: _appRouter.delegate(),
          routeInformationParser: _appRouter.defaultRouteParser()),
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
