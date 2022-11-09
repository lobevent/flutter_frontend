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
      Icon(icon, color:
          Theme.of(context).iconTheme.color
      //AppColors.stdTextColor,
      ),
      if(onTap != null )GestureDetector(
        child: makeTextWidget(context),
        onTap: (){
          if(onTap != null) onTap!();
        },
      ),
      if(onTap == null) makeTextWidget(context)
    ]);
  }


  Widget makeTextWidget(BuildContext context){
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyText1
      //TextStyle(color: AppColors.stdTextColor),
    );
  }
}
