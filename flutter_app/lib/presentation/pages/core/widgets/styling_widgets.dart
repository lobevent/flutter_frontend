
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

/// Widget used for making padding with a row, so the children start on the
/// correct side and is padded from the side
class PaddingRowWidget extends StatelessWidget{
  final List<Widget> children;

  /// the padding value on the left side
  final double paddinfLeft;
  /// the padding value on the top
  final double paddingTop;
  /// the padding value on the right side
  final double paddingRight;
  /// the padding value on the bottom
  final double paddingBottom;


  const PaddingRowWidget({Key? key, required this.children,
    this.paddinfLeft  = 30,
    this.paddingTop = 0,
    this.paddingRight  = 30,
    this.paddingBottom = 0}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.fromLTRB(paddinfLeft, paddingTop, paddingRight, paddingBottom),
      child: Row(children: children),
    );
  }



}


