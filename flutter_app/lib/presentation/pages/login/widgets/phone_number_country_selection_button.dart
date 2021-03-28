import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/core/style.dart';

class PhoneNumberCountrySelectionButton extends StatelessWidget {
  final VoidCallback countryCodePressed;
  final Map<String, String> countryData;

  const PhoneNumberCountrySelectionButton({
    required this.countryCodePressed,
    required this.countryData,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: countryCodePressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            countryData['dial_code']!,
            style: AppTextStyles.basic,
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            margin: const EdgeInsets.only(right: 8.0),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: AppColors.mainIcon,
              size: AppSizes.mainIcon,
            ),
          ),
        ],
      ),
    );
  }
}