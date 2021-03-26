/*
import 'package:flutter/material.dart' hide Router;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:project_fire_flutter/app_backend/blocs/authentication/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_fire_flutter/utils/error_dialog.dart';
import 'package:project_fire_flutter/utils/stateless_loading_animation.dart';

import 'package:project_fire_flutter/utils/style.dart';
import 'package:project_fire_flutter/utils/router.dart';



class PhoneNumberVerificationCodeScreen extends StatelessWidget {
  final TextEditingController _smsCodeController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        // TODO implement further navigation here

        if (state is PhoneNumberVerificationSuccessful) {
          Navigator.of(context).pushNamed(Router.loginGetNameRoute);
          print(state.toString());
          print("user is authenticated move on");
        } else if (state is ProfileCompleted) {
          Navigator.of(context).pushReplacementNamed(Router.mainScreenRoute);
          print(state);
          print("Account was already registered in previous session (maybe on different divce)");
        } else if (state is PhoneNumberVerificationCodeWrong) {
          LoginSnackBar(scaffoldKey: _scaffoldState, body: translate("login.phoneVerificationCode.wrongCodeSnackBar")).showSnackBar();
        } else if (state is PhoneNumberVerificationFailed) {
          print(state.toString());
          print("something went wrong while authenticating the user!");
        }
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) => Scaffold(
          key: _scaffoldState,
          body: StatelessLoading(
            showLoading: state is PhoneAuthInProgress,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    gradient: loginBackgroundGradient,
                  ),
                ),
                GestureDetector(
                  onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                ),
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(top: 75.0),
                          child: Text(
                            translate("login.phoneVerificationCode.title"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.only(top: 25.0),
                          margin: const EdgeInsets.symmetric(horizontal: 45.0),
                          child: _buildVerificationCodeInput(),
                        ),

                        _buildResendButton(translate("login.phoneVerificationCode.resendButton"), _resendSmsCode),
                        _buildVerifyButton(translate("login.phoneVerificationCode.verifyButton"), _verifySmsCode),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: _buildAppBar(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: lightGrey,
          size: 35.0,
        ),
        onPressed: () => _handleBackPress(context),
      ),
    );
  }

  Widget _buildVerificationCodeInput() {
    const TextStyle textFieldTextStyle = TextStyle(
        fontSize: 20.0,
        letterSpacing: 20.0,
        color: Colors.white
    );
    const UnderlineInputBorder underlineInputBorder = UnderlineInputBorder(
      borderSide: BorderSide(
          color: Colors.white
      ),
    );

    return TextField(
      controller: _smsCodeController,
      decoration: const InputDecoration(
        hintText: "xxxxxx",
        hintStyle: textFieldTextStyle,
        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
        disabledBorder: underlineInputBorder,
        enabledBorder: underlineInputBorder,
        focusedBorder: underlineInputBorder,
        errorBorder: underlineInputBorder,
        focusedErrorBorder: underlineInputBorder,
      ),
      textAlign: TextAlign.center,
      style: textFieldTextStyle,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildResendButton(String name, Function callback) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 5.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0)),
        color: loginButtonColor,
        onPressed: () => callback(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyButton(String name, Function callback) {
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0)),
        color: loginButtonColor,
        onPressed: () => callback(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );
  }

  void _handleBackPress(BuildContext context) {
    print("Back pressed"); // TODO remove
    Navigator.of(context).pop();
  }

  void _resendSmsCode() {
    BlocProvider.of<AuthenticationBloc>(context).add(ResendAuthCode());
    LoginSnackBar(scaffoldKey: _scaffoldState, body: translate("login.phoneVerificationCode.resendCodeSnackBar")).showSnackBar();
  }

  void _verifySmsCode(BuildContext context) {
    BlocProvider.of<AuthenticationBloc>(context).add(EnteredVerificationCode(_smsCodeController.text));
    //TODO finish with trim the smsCodeController
  }
}

 */
