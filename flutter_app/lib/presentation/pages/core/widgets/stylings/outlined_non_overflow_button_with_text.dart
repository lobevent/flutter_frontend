import 'package:flutter/material.dart';

class OutlinedNonOverflowbutton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool disabled;
  const OutlinedNonOverflowbutton(
      {Key? key,
        required this.onPressed,
        required this.text,
        this.icon,
        this.disabled = false})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onPressed,
        child:
        // this looks cancer, and maybe you are right
        // feel free to correct this
        // used to hide overflow
        ClipRect(
          // overflow is alowed, so no overflowerror arises
            child: SizedOverflowBox(
              //the alignment of the content should be on the left side and
              // vertical it should be centered
                alignment: Alignment.centerLeft,
                size: Size(MediaQuery.of(context).size.width * 0.25, 30),
                // Row is used so the button can contain icon and text
                child: Row(children: [
                  Icon(icon),
                  Text(text)
                ]
                ))));
  }
}
