import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/rotatingCircle.dart';

class LoadingButton extends StatelessWidget {
  const LoadingButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(
        flex: 1,
        child: Center(
          child: Align(
            alignment: Alignment.center,
            child: SpinKitRotatingCircle(
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
        ));;
  }
}
