import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/core/style.dart';

import '../../../../core/styles/colors.dart';

class StdChoiceTextChip extends StatelessWidget {
  final bool selected;
  final Function(bool) onSelected;
  final String label;
  const StdChoiceTextChip({Key? key, required this.selected, required this.onSelected, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      clipBehavior: Clip.antiAlias,
      shadowColor: selected? AppColors.selectedColor : AppColors.unselectedColor,
      // shape: StadiumBorder(
      //     side: BorderSide(
      //       width: 2.0,
      //         color: selected? AppColors.selectedColor : AppColors.unselectedColor)
      // ),
      elevation: 10.0,
      selectedColor: Color(AppColors.selectedColor.value - 0x99000000),
      backgroundColor: Color(AppColors.unselectedColor.value - 0x99000000),
      label: Text(label, style: selected ? AppTextStyles.stdSelectedText : AppTextStyles.stdText,),
      selected: selected,
      onSelected: onSelected,
  );
  }
}
