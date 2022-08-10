import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/my_location/my_location.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';

class MyLocationFormOverlay{
  MyLocationFormOverlay({MyLocation? myLocation, required BuildContext context}){
    final OverlayState overlayState = Overlay.of(context)!;
    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) => DismissibleOverlay(overlayEntry: overlayEntry!, child: _MyLocationForm(location: myLocation,),));
    overlayState.insert(overlayEntry);
  }
}

class _MyLocationForm extends StatelessWidget {
  const _MyLocationForm({Key? key, MyLocation? location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BasicContentContainer(
        child_ren: right(
            Container(
              child: Form(
                child: Column(
                  children: [
                    FullWidthPaddingInput(),
                    FullWidthPaddingInput(),
                  ],
                ),
              ),
            )
        )
    );
  }
}
