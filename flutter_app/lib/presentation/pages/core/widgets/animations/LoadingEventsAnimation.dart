import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';

///
/// An Animation of three cards, that start animationg delayed and drop down of sorts
///
class LoadingEventsAnimation extends StatefulWidget {
  const LoadingEventsAnimation({Key? key}) : super(key: key);

  @override
  State<LoadingEventsAnimation> createState() => _LoadingEventsAnimationState();
}

class _LoadingEventsAnimationState extends State<LoadingEventsAnimation> with SingleTickerProviderStateMixin {


  late Animation<double> animation;
  late AnimationController controller;
  double opacity1 = 0;
  double opacity2 = 0;
  double opacity3 = 0;


  @override
  void initState() {
    //BEGIN: --- the fade in animation
    controller = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);
    animation = Tween<double>(begin: 0, end: 90).animate(controller)
      ..addListener(() {
        // calulate different opacities
        this.opacity1 = (animation.value % 100) / 100.0;
        this.opacity2 =
            max((((animation.value * (max(0, animation.value - 20) / (max(0, animation.value - 20) + 0.0000001))) % 100) - 20) / 100.0, 0);
        this.opacity3 =
            max((((animation.value * (max(0, animation.value - 40) / (max(0, animation.value - 40) + 0.0000001))) % 100) - 40) / 100.0, 0);

        setState(() {});
      });
    //controller.forward();
    controller.repeat(reverse: true);
    //END: --- the fade in animation

    super.initState();
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // overflow box is here, so it does not overflow on small devices
    return OverflowBox(
      alignment: Alignment.topCenter,
      minHeight: 0.0,
      maxHeight: double.infinity,
      child: Column(
        children: [
          Opacity(
              opacity: opacity1 + 0.1,
              child: PseudoEvent()),
          SizedBox(height: 10),
          Opacity(
              opacity: opacity2 + 0.1,
              child: PseudoEvent()),
          SizedBox(height: 10),
          Opacity(
              opacity: opacity3 + 0.1,
              child: PseudoEvent()),


        ],
      ),
    );
  }

  Widget PseudoEvent(){
    return Card(
      child: Column(
        children: [
          SizedBox(height: 40),
          SizedBox(height: 100, child: Container(color: AppColors.lightGrey,),)
        ],
      ),);
  }

}
