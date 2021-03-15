import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart'
as app_router;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/auth/sign_in_form/sign_in_form_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event_form.dart';
import 'package:flutter_frontend/presentation/pages/feed.dart';
import 'package:flutter_frontend/presentation/pages/login_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      builder: ExtendedNavigator.builder(router: app_router.Router()),
      //home: FeedScreen(),
//      BlocProvider(
//        create: (context) => SignInFormCubit(null),
//        child: LoginScreen(),
      //),
    );
  }
}

