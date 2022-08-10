import 'package:auto_route/auto_route.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';

class DismissibleOverlay extends StatefulWidget {
  final Widget child;
  final OverlayEntry overlayEntry;
  const DismissibleOverlay({Key? key, required this.child, required this.overlayEntry}) : super(key: key);

  @override
  State<DismissibleOverlay> createState() => _DismissibleOverlayState();
}

class _DismissibleOverlayState extends State<DismissibleOverlay> with AutoRouteAware, SingleTickerProviderStateMixin{


  late Animation<double> animation;
  late AnimationController controller;
  double opacity = 0;

  @override
  void initState() {
    //BEGIN: --- the fade in animation
    controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    animation = Tween<double>(begin: 0, end: 1.0).animate(controller)..addListener(() {
      this.opacity = animation.value;
      setState((){});
    });
    controller.forward();
    //END: --- the fade in animation

    super.initState();
  }

  @override
  Widget build(BuildContext context) {



    return BackButtonListener(
        onBackButtonPressed: () async {
          // this reverses the animation when the back button is clicked, so it fades out
          return controller.reverse().then((value) {
            widget.overlayEntry.remove(); return Future.value(true);
        });},
        child: Opacity(
          opacity: opacity,
          child: Dismissible(
              onDismissed: (dismissDirection) => widget.overlayEntry.remove(),
              direction: DismissDirection.vertical,
              key: Key(''),
              child: ColorfulSafeArea(child: widget.child)
          ),
        )
    );

  }

}
