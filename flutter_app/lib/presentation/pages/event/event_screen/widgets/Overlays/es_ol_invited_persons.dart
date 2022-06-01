import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/Overlays/es_ol_invited_persons_widgets/es_ol_ip_content.dart';


class InvitedPersonsOverlay extends StatefulWidget {
  final OverlayEntry overlayEntry;
  final BuildContext eventCubitContext;
  
  
  
  const InvitedPersonsOverlay({Key? key, required this.overlayEntry, required this.eventCubitContext}) : super(key: key);

  
  /// build this Widget as overlay!
  static void showInvitedPersonsOverlay(BuildContext eventCubitContextLocal /* this is used to access the cubit inside of the overlay*/) async {
    //initialise overlaystate and entries
    final OverlayState overlayState = Overlay.of(eventCubitContextLocal)!;
    //have to do it nullable
    OverlayEntry? overlayEntry;


    //this is the way to work with overlays
    overlayEntry = OverlayEntry(builder: (buildContext)
    {
      return InvitedPersonsOverlay(overlayEntry: overlayEntry!, eventCubitContext: eventCubitContextLocal);
    });


    //insert the entry in the state to make it accesible
    overlayState.insert(overlayEntry);
  }
  @override
  State<InvitedPersonsOverlay> createState() => _InvitedPersonsOverlayState();
}

// ======================// ======================// ======================// ======================// ======================// ======================// ======================// ======================
// ---------------------------------------------------------------------------------------------- STATE -----------------------------------------------------------------------------------
// ======================// ======================// ======================// ======================// ======================// ======================// ======================// ======================

class _InvitedPersonsOverlayState extends State<InvitedPersonsOverlay> {
  
  List<Invitation> invitations = [];




  @override
  Widget build(BuildContext context) {


    return
      BlocBuilder<EventScreenCubit, EventScreenState>(
        bloc: BlocProvider.of(widget.eventCubitContext),
        builder: (context, state){ state.maybeMap(orElse: (){
          invitations = [];
        },
        loaded: (loadedState) {
          invitations = loadedState.event.invitations;
        });
        return DismissibleOverlay(
          overlayEntry: widget.overlayEntry,
          child: InvitedPersonsContent(invitations: invitations,),
        );
      });
    }
}
