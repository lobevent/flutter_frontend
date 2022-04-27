import 'package:flutter/material.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';

class TextWithIcon extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final IconData icon;
  const TextWithIcon({Key? key, this.onTap, required this.text, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: AppColors.stdTextColor,),
      if(onTap != null )GestureDetector(
        child: makeTextWidget(),
        onTap: (){
          if(onTap != null) onTap!();
        },
      ),
      if(onTap == null) makeTextWidget()
    ]);
  }


  Widget makeTextWidget(){
    return Text(
      text,
      style: TextStyle(color: AppColors.stdTextColor),
    );
  }
}
