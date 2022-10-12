import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// Animated check displays an circle with an check in it
/// the circle bounces
/// the check appears from left to right
///
class AnimatedCheck extends StatefulWidget {
  @override
  _AnimatedCheckState createState() => _AnimatedCheckState();
}

class _AnimatedCheckState extends State<AnimatedCheck> with TickerProviderStateMixin {
  late AnimationController scaleController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
  late Animation<double> scaleAnimation = CurvedAnimation(parent: scaleController, curve: Curves.elasticOut);
  late AnimationController checkController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
  late Animation<double> checkAnimation = CurvedAnimation(parent: checkController, curve: Curves.linear);

  @override
  void initState() {
    super.initState();
    scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkController.forward();
      }
    });
    scaleController.forward();
  }

  @override
  void dispose() {
    scaleController.dispose();
    checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double circleSize = 140;
    double iconSize = 108;


    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: Container(
              height: circleSize,
              width: circleSize,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),

        Container(
          height: circleSize,
          child: SizeTransition(
            sizeFactor: checkAnimation,
            axis: Axis.horizontal,
            axisAlignment: -1,
            child: Center(
              child: Icon(Icons.check_rounded, color: Colors.white, size: iconSize),
            ),
          ),
        ),
      ],
    );
    // return ScaleTransition(
    //   scale: scaleAnimation,
    //   child: Container(
    //     height: circleSize,
    //     width: circleSize,
    //     decoration: BoxDecoration(
    //       color: Colors.green,
    //       shape: BoxShape.circle,
    //     ),
    //     child: SizeTransition(
    //         sizeFactor: checkAnimation,
    //         axis: Axis.horizontal,
    //         axisAlignment: -1,
    //         child: Center(
    //             child: Icon(Icons.check, color: Colors.white, size: iconSize)
    //         )
    //     ),
    //   ),
    // );
  }
}