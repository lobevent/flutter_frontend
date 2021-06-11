
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// the content Container should contain no logic, but should only call the
/// content widgets
class BasicContentContainer extends StatelessWidget{
  final List<Widget> children;
  const BasicContentContainer({Key? key, required this.children}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ColorfulSafeArea(
          color: Colors.yellow,
          child: SingleChildScrollView(
            child: Column(
              children: children,
            ),
          ),
        ));
  }
}
