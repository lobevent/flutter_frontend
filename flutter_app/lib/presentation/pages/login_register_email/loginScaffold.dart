import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'cubit/login_register_cubit.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingControllerUsername = TextEditingController();
    TextEditingController textEditingControllerPassword = TextEditingController();
    return BlocBuilder<LoginRegisterCubit, LoginRegisterState>(builder: (context1, state) {
      return BasicContentContainer(child_ren: left([
        Column(children: [
          Text("Login"),
          // email Field
          FullWidthPaddingInput(labelText:  'Email or Username', controller: textEditingControllerUsername),
          FullWidthPaddingInput(labelText:  'Password', controller: textEditingControllerPassword, password: true,),
          Padding(
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                TextWithIconButton(
                onPressed: () => {context1.read<LoginRegisterCubit>().login(textEditingControllerPassword.value.text, textEditingControllerUsername.value.text)},
                text: "Login",
                icon: Icons.login,
              ),
                TextWithIconButton(
                onPressed: () => {
                  context.router.push(RegistrationFormRoute())},
                text: "Reigi",
                icon: Icons.login,)
              ]))
        ])
      ]));
    });
  }
}
