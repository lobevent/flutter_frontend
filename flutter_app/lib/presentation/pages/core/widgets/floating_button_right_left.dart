import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';

class FloatingButtonRightBottom extends StatelessWidget {
  const FloatingButtonRightBottom({Key? key, required this.onPressed}) : super(key: key);

  /// The callback that is called when the button is tapped or otherwise activated.
  ///
  /// If this is set to null, the button will be disabled.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 20,
        bottom: 20,
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            child: Icon(Icons.refresh_outlined),
            backgroundColor: AppColors.accentColor,
            onPressed: onPressed,
          ),
        )
    );
  }
}
