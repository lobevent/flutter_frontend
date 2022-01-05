import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/login_register_email/cubit/login_register_cubit.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    return BlocBuilder<LoginRegisterCubit, LoginRegisterState>(builder: (context, state) {
      return BasicContentContainer(children: [
        Column(children: [
          Text("Login"),
          // email Field
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: textEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email or username',
              ),
            ),
          ),
          // password field
          Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: textEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email or username',
                ),
              )),
          Padding(
              padding: const EdgeInsets.all(10),
              child: TextWithIconButton(
                onPressed: () => {},
                text: "Login",
                icon: Icons.login,
              ))
        ])
      ]);
    });
  }
}