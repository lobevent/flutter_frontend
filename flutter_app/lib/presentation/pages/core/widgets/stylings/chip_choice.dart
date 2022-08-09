import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/stylings/std_choice_text_chip.dart';

class ChipChoice extends StatefulWidget {
  final Map<String, Function(bool)> list;

  const ChipChoice({Key? key, required this.list}) : super(key: key);

  @override
  State<ChipChoice> createState() => ChipChoiceState();
}

class ChipChoiceState extends State<ChipChoice> {
  int? value = 0;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Wrap(
      alignment: WrapAlignment.spaceAround,
      children: List<Widget>.generate(
        widget.list.length,
        (int index) {
          return StdChoiceTextChip(
            label: (widget.list.keys.toList()[index]),
            selected: value == index,
            onSelected: (bool selected) {
              widget.list.values.toList()[index](selected);
              setState(() {
                value = index;
              });
            },
          );
        },
      ).toList(),
    ));
  }
}
