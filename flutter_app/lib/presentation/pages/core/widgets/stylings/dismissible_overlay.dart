import 'package:auto_route/auto_route.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';

class DismissibleOverlay extends StatelessWidget {
  final Widget child;
  final OverlayEntry overlayEntry;
  const DismissibleOverlay({Key? key, required this.child, required this.overlayEntry}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    // //context.watchRouter.
    // context.watchRouter.addListener(() {
    //   if(overlayEntry!=null){
    //
    //   overlayEntry.remove();
    //   }
    // };
    //context.router.onNavigate!((){}, );
    return BackButtonListener(
        onBackButtonPressed: () async { overlayEntry.remove(); return Future.value(true);},
        child: Dismissible(
            onDismissed: (dismissDirection) => overlayEntry.remove(),
            direction: DismissDirection.vertical,
            key: Key(''),
            child: ColorfulSafeArea(child: child)
        )
    );

  }
}
