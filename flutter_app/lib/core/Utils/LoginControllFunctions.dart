import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/core/services/AuthTokenService.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/infrastructure/core/local/common_hive/common_hive.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart'
    as _app_router;

class LoginControllFunctions {
  static logout() async {
    await CommonHive.deleteHive();
    await GetIt.I<AuthTokenService>().deleteToken();
    GetIt.I<_app_router.Router>().popUntilRoot();
    (_app_router.LoginRegisterRoute());
    GetIt.I<_app_router.Router>().replace(_app_router.LoginRegisterRoute());
  }

  static Future<void> setLoginStuff() async {
    GetIt.I<AuthTokenService>()
        .retrieveToken()
        .then((value) => GetIt.I<SymfonyCommunicator>().setJwt(value ?? ''));
  }
}
