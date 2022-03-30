import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/login_register_email/cubit/login_register_cubit.dart';
import 'package:flutter_frontend/presentation/pages/login_register_email/loginScaffold.dart';

class RegistrationForm extends StatelessWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingControllerUsername =
        TextEditingController();
    TextEditingController textEditingControllerPassword =
        TextEditingController();
    TextEditingController textEditingControllerEmail = TextEditingController();
    return BlocProvider(
        create: (context) => LoginRegisterCubit(),
        child: BlocBuilder<LoginRegisterCubit, LoginRegisterState>(
          builder: (context1, state) {
            return BasicContentContainer(scrollable: false,
                // height: 200.0,
                // padding: const EdgeInsets.symmetric(horizontal: 8.0),
                // decoration: BoxDecoration(color: Colors.blue[500]),
                children: [
                  Column(
                    children: [
                      FullWidthPaddingInput(
                        labelText: "Username",
                        controller: textEditingControllerUsername,
                      ),
                      FullWidthPaddingInput(
                        labelText: "Password",
                        controller: textEditingControllerPassword,
                        password: true,
                      ),
                      FullWidthPaddingInput(
                        labelText: "E-mail adress",
                        controller: textEditingControllerEmail,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: TextWithIconButton(
                            onPressed: () => {

                                  context1.read<LoginRegisterCubit>().register(
                                      textEditingControllerPassword.value.text,
                                      textEditingControllerUsername.value.text,
                                      textEditingControllerEmail.value.text)
                                },
                            text: "Sign up!"),
                      )
                    ],
                  ),
                ]);
          },
        ));
  }
}

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginRegisterCubit(),
      child: Registration(),
    );
  }
}
