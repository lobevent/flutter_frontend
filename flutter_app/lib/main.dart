import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart'
as app_router;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/auth/sign_in_form/sign_in_form_cubit.dart';
import 'package:flutter_frontend/presentation/pages/feed.dart';
import 'package:flutter_frontend/presentation/pages/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final _appRouter = app_router.Router();
  @override
  Widget build(BuildContext context) {
    return MaterialApp
    //     .router(
    //     routerDelegate: _appRouter.delegate(),
    //     routeInformationParser: _appRouter.defaultRouteParser()
    // );
      (
      title: 'Material App',
      builder: ExtendedNavigator.builder<app_router.Router>(router: app_router.Router()),
      //home: FeedScreen(),
//      BlocProvider(
//        create: (context) => SignInFormCubit(null),
//        child: LoginScreen(),
      //),
    );
  }
}

