import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class EventListTiles extends StatelessWidget {
  final Event event;
  final bool allowEdit;

  const EventListTiles({Key? key, required this.event, required this.allowEdit}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.event),
        title: Text(event.description.getOrCrash()),
        trailing: Row(
            mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(icon: Icon(Icons.delete), onPressed: () => {deleteEvent(context)} ),
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => {editEvent(context)}
                ),
          ],
      ),
      ),
    );
  }


  void editEvent(BuildContext context){
    context.router.push(EventFormPageRoute(editedEventId: event.id.getOrCrash()));
  }

  void deleteEvent(BuildContext context){
    //Not yet implemented
    showDialog<void>(
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
            TextButton( //Cpnfirmation
              child: Text(AppStrings.deleteEventDialogConfirm),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton( //Abortion
              child: Text(AppStrings.deleteEventDialogAbort),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


}