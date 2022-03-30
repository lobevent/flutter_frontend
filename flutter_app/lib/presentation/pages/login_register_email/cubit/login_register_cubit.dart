import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/core/Utils/LoginControllFunctions.dart';
import 'package:flutter_frontend/core/services/AuthTokenService.dart';
import 'package:flutter_frontend/infrastructure/auth/symfonyLogin.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart'
as _app_router;
part 'login_register_state.dart';

class LoginRegisterCubit extends Cubit<LoginRegisterState> {
  LoginRegisterCubit({bool withRouting = true}) : super(LoginRegisterInitial()) {
    if (withRouting) LoginControllFunctions.logout();
  }


  Future<void> login(String password, String username) async{
    // login user and safe to safestorage
    SymfonyLogin symfonyLogin = SymfonyLogin();
    // double then because we have to wait until all is set
    await symfonyLogin.login(username, password).then((value) {
      LoginControllFunctions.setLoginStuff().then((value) {
        // route to the feed
        // pop until root so no routes are in the stack anymore
        GetIt.I<_app_router.Router>().popUntilRoot();
        // replace the root route
        GetIt.I<_app_router.Router>().replaceNamed("/");
      });
    });



    

  }

  Future<void> register(String password, String username, String email) async{
    // register new user and save
    SymfonyLogin symfonyLogin = SymfonyLogin();
    await symfonyLogin.register(username, password, email).then((value) {
      // route to the feed
      // pop until root so no routes are in the stack anymore
      GetIt.I<_app_router.Router>().popUntilRoot();
      // replace the root route
      GetIt.I<_app_router.Router>().replaceNamed("/");
    });
  }
}
