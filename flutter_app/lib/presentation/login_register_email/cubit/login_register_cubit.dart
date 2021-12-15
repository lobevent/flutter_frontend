import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_register_state.dart';

class LoginRegisterCubit extends Cubit<LoginRegisterState> {
  LoginRegisterCubit() : super(LoginRegisterInitial());


  // Future<void> login(String password, String username){
  //
  // }
}
