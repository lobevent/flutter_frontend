import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/data/constants.dart';
import 'package:flutter_frontend/presentation/core/style.dart';

typedef CountryCodeCallback = void Function(Map<String, String> countryData);

class CountryCodeListTile extends StatelessWidget {
  final Map<String, String> countryData;
  final CountryCodeCallback countryCodePressed;

  const CountryCodeListTile(
      {required this.countryData, required this.countryCodePressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _countryCodePressed(context),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "${countryData[Constants.countryDataName]} (${countryData[Constants.countryDataCode]})",
                textAlign: TextAlign.left,
                style: AppTextStyles.loginText,
              ),
            ),
            Text(
              countryData[Constants.countryDataDialCode]!,
              textAlign: TextAlign.right,
              style: AppTextStyles.loginText,
            )
          ],
        ),
      ),
    );
  }

  void _countryCodePressed(BuildContext context) {
    context.router.pop();
    countryCodePressed(countryData);
  }
}
