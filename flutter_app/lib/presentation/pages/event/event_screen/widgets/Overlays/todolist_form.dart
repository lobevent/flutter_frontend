

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/stylings/dismissible_overlay.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoListForm extends StatefulWidget {
  final OverlayEntry overlayEntry;
  final BuildContext cubitContext;
  final Event event;
  const TodoListForm({required this.overlayEntry, required this.cubitContext, Key? key, required this.event}) : super(key: key);

  @override
  _TodoListFormState createState() => _TodoListFormState(cubitContext);
}

class _TodoListFormState extends State<TodoListForm> {
  final BuildContext cubitContext;
  final orgaNameController = TextEditingController();
  final orgaDescriptionController = TextEditingController();

  _TodoListFormState(this.cubitContext);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return DismissibleOverlay(overlayEntry: widget.overlayEntry , child: Scaffold(
        body: Column(
          children: [
            const SizedBox(height: 20),
            Text('Create Orgalist', style: Theme.of(context).textTheme.headline3),
            const SizedBox(height: 20),
            FullWidthPaddingInput(controller:  orgaNameController, labelText: 'Enter the Organame'),
            const SizedBox(height: 20),
            FullWidthPaddingInput(controller:  orgaDescriptionController, labelText: 'Enter the Orgadescription'),
            StdTextButton(
                onPressed: () {
                  //check for overlay so it is nullsafe
                  if (widget.overlayEntry != null) {
                    //remove overlay so we have to dont fuck around with routes
                    widget.overlayEntry.remove();
                  }
                  //create the orgalist and pass the event + inputted orgalistname +desc
                  cubitContext.read<EventScreenCubit>().createOrgaEvent(widget.event, orgaNameController.text, orgaDescriptionController.text);
                },
                child: const Icon(Icons.add, color: AppColors.stdTextColor))
          ],
        )));
  }
}
