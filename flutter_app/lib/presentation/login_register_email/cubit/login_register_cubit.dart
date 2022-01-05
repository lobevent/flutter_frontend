import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/core/services/AuthTokenService.dart';
import 'package:flutter_frontend/infrastructure/auth/symfonyLogin.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'login_register_state.dart';

class LoginRegisterCubit extends Cubit<LoginRegisterState> {
  LoginRegisterCubit() : super(LoginRegisterInitial());


  Future<void> login(String password, String username) async{
    SymfonyLogin symfonyLogin = SymfonyLogin();
    await symfonyLogin.login(username, password);
    String? test = await GetIt.I<AuthTokenService>().retrieveToken();
    print(test);

  }
}
