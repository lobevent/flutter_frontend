import 'package:flutter/material.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/circle_beating.dart';

class GPSLoadingAnimation extends StatelessWidget {
  const GPSLoadingAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleBeating(color: AppColors.accentButtonColor, size: 70),
          SizedBox(height: 20,),
          Text(AppStrings.loadingGps)
        ],
        mainAxisSize: MainAxisSize.min,

      ),
    );
  }
}
