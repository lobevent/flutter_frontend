import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_frontend/application/auth/sign_in_form/sign_in_form_cubit.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class CountryCodeSelectionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.router.push(const CountryCodeSelectionScreenRoute()),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            context.watch<SignInFormCubit>().state.phoneNumberPrefix.value.fold(
              (l) => throw PhoneNumberPrefixShouldBeSetProperly(), 
              (r) => r),
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