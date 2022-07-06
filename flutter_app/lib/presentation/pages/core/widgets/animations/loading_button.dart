import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/rotatingCircle.dart';

class LoadingButton extends StatelessWidget {
  final double size;
  const LoadingButton({Key? key, this.size = 20}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 0,
        child: Center(
          child: Align(
            alignment: Alignment.center,
            child: SpinKitRotatingCircle(
              color: AppColors.primaryColor,
              size: this.size,
            ),
          ),
        ));;
  }
}
