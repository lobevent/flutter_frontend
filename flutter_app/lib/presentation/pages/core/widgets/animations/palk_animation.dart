import 'package:flutter/material.dart';

class PalkAnimation extends StatefulWidget {
  final double size;

  const PalkAnimation({Key? key, required this.size}) : super(key: key);

  @override
  State<PalkAnimation> createState() => _PalkAnimationState();
}

class _PalkAnimationState extends State<PalkAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late Animation<double> animationSize;
  late AnimationController _animationController;
  double opacity = 0;
  double size = 50;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        // calulate different opacities
        this.opacity = _animationController.value;
        setState(() {});
      });

    /*animationSize =
        Tween<double>(begin: widget.size - 20, end: widget.size + 20)
            .animate(_animationController)
          ..addListener(() {
            // calulate different opacities
            this.size = _animationController.value;
            setState(() {});
          });

     */
    //controller.forward();
    _animationController.repeat(reverse: true);
    //END: --- the fade in animation

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Opacity(
        opacity: opacity,
        child: Image(
          image: AssetImage("assets/logos/palk logo.png"),
        ),
        //AssetImage("assets/logos/palk logo.png"),
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: buildAnimation,
      animation: _animationController,
    );
  }

   */
}
