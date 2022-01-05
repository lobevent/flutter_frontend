import 'package:flutter_frontend/core/services/AuthTokenService.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart'
as _app_router;

class LoginControllFunctions{

  static logout() async{
    await GetIt.I<AuthTokenService>().deleteToken();
    GetIt.I<_app_router.Router>().popUntilRoot();(_app_router.LoginRegisterRoute());
    GetIt.I<_app_router.Router>().replace(_app_router.LoginRegisterRoute());
  }

  static setLoginStuff() async{
    await GetIt.I<AuthTokenService>().retrieveToken().then((value) => GetIt.I<SymfonyCommunicator>().setJwt(value??''));
  }
}