import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
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
              deleteEvent(context).then((value) async =>
                  {if (value) onDeletion!(event) else print("falseeeee")});
            }),
        IconButton(
            icon: Icon(Icons.edit), onPressed: () => {editEvent(context)}),
      ];
    }
    return <Widget>[];
  }

  void editEvent(BuildContext context) {
    context.router
        .push(EventFormPageRoute(editedEventId: event.id.getOrCrash()));
  }

  void showEvent(BuildContext context) {
    context.router.push(EventScreenPageRoute(eventId: event.id));
  }

  /// an delete event function with an alert dialog to submit
  Future<bool> deleteEvent(BuildContext context) async {
    bool answer = false;
    //Not yet implemented
    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppStrings.deleteEventDialogTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppStrings.deleteEventDialogText),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              //Cpnfirmation
              child: Text(AppStrings.deleteEventDialogConfirm),
              onPressed: () {
                Navigator.of(context).pop();
                //context.read<OwnEventsCubit>().deleteEvent();
                answer = true;
              },
            ),
            TextButton(
              //Abortion
              child: Text(AppStrings.deleteEventDialogAbort),
              onPressed: () {
                Navigator.of(context).pop();
                answer = false;
              },
            ),
          ],
        );
      },
    );
    return answer;
  }
}
