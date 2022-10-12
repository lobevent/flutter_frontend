import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/event/events_user/cubit/events_user_cubit.dart';

class NetworkErrorWidget extends StatelessWidget {
  final NetWorkFailure failure;
  const NetworkErrorWidget({Key? key, required this.failure}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      maxHeight: double.infinity,
      child: Container(
        height: 500,
        color: AppColors.lightErrorBackgroundColor,
        child: Center(child: Text(failure.getDisplayStringLocal())),
      ),
    );
  }
}
