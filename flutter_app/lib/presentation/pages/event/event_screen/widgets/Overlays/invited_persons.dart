import 'package:flutter/material.dart';

class InvitedPersonsOverlay extends StatefulWidget {
  final OverlayEntry overlayEntry;
  final List<Invitations>
  
  
  
  const InvitedPersonsOverlay({Key? key, required this.overlayEntry}) : super(key: key);

  
  //build this Widget as overlay!
  static void showCreateTodoListOverlay(BuildContext eventCubitcontext, BuildContext addFriendsCubit) async {
    //initialise overlaystate and entries
    final OverlayState overlayState = Overlay.of(buildContext)!;
    //have to do it nullable
    OverlayEntry? overlayEntry;

    //controllers for name and desc


    //this is the way to work with overlays
    overlayEntry = OverlayEntry(builder: (buildContext)
    {
      return InvitedPersonsOverlay(overlayEntry: overlayEntry!, cubitContext: context, event: eventPass,);
    });
    //insert the entry in the state to make it accesible
    overlayState.insert(overlayEntry);
  }
  @override
  State<InvitedPersonsOverlay> createState() => _InvitedPersonsOverlayState();
}

class _InvitedPersonsOverlayState extends State<InvitedPersonsOverlay> {
  
  
  
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
