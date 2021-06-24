
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
const double paddingLeftConst  = 30;
const double paddingTopConst = 0;
const double paddingRightConst  = 30;
const double paddingBottomConst = 0;
const stdPadding = EdgeInsets.fromLTRB(paddingLeftConst, paddingTopConst, paddingRightConst, paddingBottomConst);



/// the content Container should contain no logic, but should only call the
/// content widgets
class BasicContentContainer extends StatelessWidget{
  final List<Widget> children;
  final bool scrollable;
  const BasicContentContainer({Key? key, required this.children, this.scrollable = true}): super(key: key);

  @override
  Widget build(BuildContext context) {
    if(!scrollable) {
      return Scaffold(
          body: ColorfulSafeArea(
            color: Colors.yellow,
            child: Column(
                children: children,
              ),
            ),
          );
    }
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
    this.paddinfLeft  = paddingLeftConst,
    this.paddingTop = paddingTopConst,
    this.paddingRight  = paddingRightConst,
    this.paddingBottom = paddingBottomConst}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.fromLTRB(paddinfLeft, paddingTop, paddingRight, paddingBottom),
      child: Row(children: children),
    );
  }
}

/// Widget used for making padding with an conatiner, so the child are padded from the side
class PaddingContainer extends StatelessWidget{
  final Widget child;

  /// the padding value on the left side
  final double paddinfLeft;
  /// the padding value on the top
  final double paddingTop;
  /// the padding value on the right side
  final double paddingRight;
  /// the padding value on the bottom
  final double paddingBottom;


  const PaddingContainer({Key? key, required this.child,
    this.paddinfLeft  = paddingLeftConst,
    this.paddingTop = paddingTopConst,
    this.paddingRight  = paddingRightConst,
    this.paddingBottom = paddingBottomConst}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.fromLTRB(paddinfLeft, paddingTop, paddingRight, paddingBottom),
      child: child,
    );
  }
}

/// class primary for texts, that could overflow
class OverflowSafeString extends StatelessWidget{
  final Widget child;
  const OverflowSafeString({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return ClipRect(
        // overflow is alowed, so no overflowerror arises
        child: SizedOverflowBox(
        //the alignment of the content should be on the left side and
        // vertical it should be centered
          alignment: Alignment.centerLeft,
          size: Size(MediaQuery.of(context).size.width*0.2, 30),
            child: child,
        )
    );
  }




}




