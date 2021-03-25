import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/data/country_codes.dart';
import 'package:flutter_frontend/presentation/core/style.dart';

class PhoneNumberSignInScreen extends StatelessWidget {

  final TextEditingController phoneNumberController = TextEditingController();

  //TODO init with system country/language/number...
  final Map<String, String> countryData = {
    "name": "Deutschland",
    "code": "DE",
    "dial_code": "+49"
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          ),

          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(top: 75.0),
                    child: Text(
                      AppStrings.phoneNumberVerificationTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: _buildPhoneNumberTextField()
                  ),

                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0)
                        ),
                        color: lightGrey,
                        onPressed: () => _sendVerificationCode(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            AppStrings.sendPhoneNumberVerification,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),


          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: _buildAppBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: lightGrey,
          size: 35.0,
        ),
        onPressed: _handleBackPress,
      ),
    );
  }

  Widget _buildPhoneNumberTextField() {
    const TextStyle textFieldTextStyle = TextStyle(
      fontSize: 20.0,
      color: Colors.white
    );
    const UnderlineInputBorder underlineInputBorder = UnderlineInputBorder(
      borderSide: BorderSide(
          color: Colors.white
      ),
    );

    return TextFormField(
      controller: phoneNumberController,
      decoration: InputDecoration(
        prefixIcon: _buildCountryCodePart(textFieldTextStyle, 20.0, Colors.white),
        hintText: AppStrings.phoneNumberTextFieldHint,
        hintStyle: textFieldTextStyle,
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
        disabledBorder: underlineInputBorder,
        enabledBorder: underlineInputBorder,
        focusedBorder: underlineInputBorder,
        errorBorder: underlineInputBorder,
        focusedErrorBorder: underlineInputBorder,
      ),
      style: textFieldTextStyle,
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildCountryCodePart(TextStyle textStyle, double iconSize, Color iconColor) {
    return FlatButton(
      onPressed: _handleCountryCodePressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            countryData['dial_code']!,
            style: textStyle
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            margin: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.arrow_forward_ios,
              color: iconColor,
              size: iconSize,
            ),
          ),
        ],
      ),
    );
  }

  String _phoneNumberValidator(String phoneNumber) {
    const allowedCharacters = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', ' '];

    final List<String> digitStrings = phoneNumber.split('');
    String validatedPhoneNumber = '';

    for (final String digit in digitStrings) {
      if (allowedCharacters.contains(digit)) {
        validatedPhoneNumber += digit;
      }
    }

    return validatedPhoneNumber;
  }

  void _handleBackPress() {

  }

  void _handleCountryCodePressed() {

  }

  void _setReturnedCountryData (Map<String, String> countryData) {

  }

  void _sendVerificationCode(BuildContext context) {

  }
}
