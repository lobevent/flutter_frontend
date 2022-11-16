import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/application/auth/sign_in_form/sign_in_form_cubit.dart';
import 'package:flutter_frontend/infrastructure/core/local/common_hive/common_hive.dart';
import 'package:flutter_frontend/injection_container.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/core/styles/dark_theme.dart';
import 'package:flutter_frontend/presentation/core/utils/observers/RouterObserver.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart'
    as _app_router;
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'dart:io' show Platform;

import 'package:hive/hive.dart';

final _app_router.Router _appRouter = _app_router.Router();

Future<void> main() async {
  if (Platform.isAndroid) {
    await dotenv.load(fileName: ".env");
  } else if (Platform.isIOS) {
    await dotenv.load(fileName: ".env.ios");
  }
  WidgetsFlutterBinding.ensureInitialized();

  // save router to getIt so we can route from everywhere
  InjectionContainer.getIt.registerLazySingleton(() => _appRouter);

  //initialize some boxes, for storing score related entries
  //await CommonHive.deleteHive();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);
  await CommonHive.initBoxes();

  //await Firebase.initializeApp();
  await InjectionContainer.injectDependencies();
  await InjectionContainer.loadNecessities();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //value notifier to change on time
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(DarkTheme().currentTheme());

  @override
  Widget build(BuildContext context) {
    //so we can change theme on runtime
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, ThemeMode currentMode, __){
          return GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: MultiBlocProvider(
                providers: [
                  BlocProvider<SignInFormCubit>(
                      create: (context) => GetIt.I<SignInFormCubit>()),
                ],
                child: MaterialApp.router(
                    themeMode: currentMode,
                    theme: DarkTheme().getLightTheme(),
                    darkTheme: DarkTheme().getDarkTheme(),
                    /*ThemeData(
                //colorScheme: ThemeData().colorScheme.copyWith(primary: AppColors.backGroundColor, brightness: Brightness.dark),
                focusColor: AppColors.accentButtonColor,
                brightness: Brightness.dark,
                primaryColor: AppColors.backGroundColor,
                fontFamily: 'Prompt',
              ),

               */
                    routerDelegate: AutoRouterDelegate(_appRouter,
                        navigatorObservers: () => [AutoRouteObserver()]),
                    routeInformationParser: _appRouter.defaultRouteParser()),
              ));
        });

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

