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

class _DismissibleOverlayState extends State<DismissibleOverlay> with AutoRouteAware{

  // AutoRouteObserver? _observer;
  //
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // RouterScope exposes the list of provided observers
  //   // including inherited observers
  //   var dar = RouterScope.of(context);
  //
  //   _observer = RouterScope.of(context).firstObserverOfType<AutoRouteObserver>();
  //   if (_observer != null) {
  //     // we subscribe to the observer by passing our
  //     // AutoRouteAware state and the scoped routeData
  //     _observer!.subscribe(this, context.routeData);
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   super.dispose();
  //   // don't forget to unsubscribe from the
  //   // observer on dispose
  //   _observer!.unsubscribe(this);
  // }


  @override
  Widget build(BuildContext context) {
    // //context.watchRouter.
    //context.watchRouter.addListener(() {remove(context);});

    //context.watchRouter.pagelessRoutesObserver.dispose();
    return BackButtonListener(
        onBackButtonPressed: () async { widget.overlayEntry.remove(); return Future.value(true);},
        child: Dismissible(
            onDismissed: (dismissDirection) => widget.overlayEntry.remove(),
            direction: DismissDirection.vertical,
            key: Key(''),
            child: ColorfulSafeArea(child: widget.child)
        )
    );

  }

  //
  // @override
  // void didPush() {
  //   widget.overlayEntry.remove();
  //   super.didPush();
  // }

  // @override
  // void dispose(){
  //   print("disposed");
  //   print(context.watchRouter.hasListeners);
  //   context.watchRouter.removeListener(() {remove(context);});
  //   super.dispose();
  // }

  // void remove(watchrouter){
  //   context.watchRouter.removeListener(() {remove(context);});
  //   widget.overlayEntry.remove();
  // }
}
