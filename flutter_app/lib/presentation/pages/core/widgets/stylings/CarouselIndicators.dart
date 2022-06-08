import 'package:flutter/material.dart';

class CarouselIndicators extends StatelessWidget {
  final int length;
  final int activePage;
  final Color? activeColor;
  final Color? inactiveColor;

  const CarouselIndicators(
      {Key? key,
      required this.length,
      required this.activePage,
      this.activeColor,
      this.inactiveColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: indicators(length, activePage));
  }

  /// This method generate indicator dots for the carousel
  List<Widget> indicators(int imagesLength, int currentIndex) {
    return List<Widget>.generate(imagesLength, (index) {
      return Container(
        margin: EdgeInsets.all(3),
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: currentIndex == index
                ? decideActiveColor()
                : decideInactiveColor(),
            shape: BoxShape.circle),
      );
    });
  }

  Color decideActiveColor() {
    if (activeColor != null) {
      return activeColor!;
    } else {
      return Colors.black;
    }
  }

  Color decideInactiveColor() {
    if (inactiveColor != null) {
      return inactiveColor!;
    } else {
      return Colors.black26;
    }
  }
}
