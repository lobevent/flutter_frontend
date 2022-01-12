import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/gen_dialog.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class EventListTiles extends StatelessWidget {
  final Event event;
  final Function(Event event)? onDeletion;

  const EventListTiles(
      {required ObjectKey key, required this.event, this.onDeletion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: IconButton(
          icon: Icon(Icons.event),
          onPressed: () => showEvent(context),
        ),
        title: Text(event.name.getOrCrash()),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actionButtons(onDeletion != null, context),
        ),
      ),
    );
  }

  /// action buttons for the event, can be made invisible, if its not own events
  List<Widget> actionButtons(bool visible, BuildContext context) {
    if (visible) {
      return <Widget>[
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              GenDialog.genericDialog(
                      context,
                      AppStrings.deleteEventDialogTitle,
                      AppStrings.deleteEventDialogText,
                      AppStrings.deleteEventDialogConfirm,
                      AppStrings.deleteEventDialogAbort)
                  .then((value) async =>
                      {if (value) onDeletion!(event) else print("falseeeee")});
            }),
        IconButton(
            icon: Icon(Icons.edit), onPressed: () => {editEvent(context)}),
      ];
    }
    return <Widget>[];
  }

  void editEvent(BuildContext context) {
    context.router.push(EventFormPageRoute(editedEventId: event.id.value));
  }

  void showEvent(BuildContext context) {
    context.router.push(EventScreenPageRoute(eventId: event.id));
  }

}
