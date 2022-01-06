import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';

import 'cubit/login_register_cubit.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingControllerUsername = TextEditingController();
    TextEditingController textEditingControllerPassword = TextEditingController();
    return BlocBuilder<LoginRegisterCubit, LoginRegisterState>(builder: (context1, state) {
      return BasicContentContainer(children: [
        Column(children: [
          Text("Login"),
          // email Field
          FullWidthPaddingInput(labelText:  'Email or Username', controller: textEditingControllerUsername),
          FullWidthPaddingInput(labelText:  'Password', controller: textEditingControllerPassword, password: true,),
          // Padding(
          //   padding: const EdgeInsets.all(10),
          //   child: TextField(
          //     controller: textEditingControllerUsername,
          //     decoration: const InputDecoration(
          //       border: OutlineInputBorder(),
          //       labelText: 'Email or username',
          //     ),
          //   ),
          // ),
          // password field
          // Padding(
          //     padding: const EdgeInsets.all(10),
          //     child: TextField(
          //       obscureText: true,
          //       enableSuggestions: false,
          //       autocorrect: false,
          //       controller: textEditingControllerPassword,
          //       decoration: const InputDecoration(
          //         border: OutlineInputBorder(),
          //         labelText: 'Email or username',
          //       ),
          //     )),
          Padding(
              padding: const EdgeInsets.all(10),
              child: TextWithIconButton(
                onPressed: () => {context1.read<LoginRegisterCubit>().login(textEditingControllerPassword.value.text, textEditingControllerUsername.value.text)},
                text: "Login",
                icon: Icons.login,
              ))
        ])
      ]);
    });
  }
}
