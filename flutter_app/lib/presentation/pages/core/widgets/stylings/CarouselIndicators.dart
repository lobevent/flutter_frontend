import 'package:flutter/material.dart';

class CarouselIndicators extends StatelessWidget {
  final int length;
  final int activePage;

  const CarouselIndicators({Key? key, required this.length, required this.activePage}) : super(key: key);

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
            color: currentIndex == index ? Colors.black : Colors.black26,
            shape: BoxShape.circle),
      );
    });
  }
}
