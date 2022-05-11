import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/gen_dialog.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class EventListTiles extends StatelessWidget {
  final Event event;
  final Function(Event event)? onDeletion;
  final bool isInvitation;
  final EventStatus? eventStatus;

  const EventListTiles(
      {required ObjectKey key, required this.event, this.onDeletion, this.isInvitation = false, this.eventStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Column(children: [
        GestureDetector(
          onTap: () => showEvent(context),
          child: ImageWidget(context, event.image),
        ),
        ListTile(
          leading: IconButton(
            icon: Icon(Icons.event),
            onPressed: () => showEvent(context),
          ),
          title: Text(event.name.getOrCrash()),
          //subtitle: Text(event.description?.getOrCrash()??'', style: TextStyle(color: AppColors.stdTextColor),),
          subtitle: Text(event.date.toString(), style: TextStyle(color: AppColors.stdTextColor), ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: actionButtons(onDeletion != null, context),
          ),
      ),])
    );
  }

  ///
  /// Checks if imagePath exists and shows other stdimage if not
  ///
  Widget ImageWidget(BuildContext context, String? imagePath){
    ImageProvider image;
    if(imagePath == null){
      image = AssetImage("assets/images/partypeople.jpg");
    }
    else {
      image = NetworkImage(dotenv.env['ipSim']!.toString() +  imagePath);
    }
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: image,
        ),
      ),
    );
  }

  /// action buttons for the event, can be made invisible, if its not own events
  List<Widget> actionButtons(bool visible, BuildContext context) {
    Icon uesIcon = Icon(Icons.error);
    if(isInvitation) {
      switch (eventStatus) {
        case EventStatus.attending:
        uesIcon = Icon(Icons.check);
          break;
        case EventStatus.notAttending:
        uesIcon = Icon(Icons.clear);
          break;
        case EventStatus.interested:
          uesIcon = Icon(Icons.lightbulb);
          break;
        case null:
          break;
        case EventStatus.invited:
          uesIcon = Icon(Icons.lightbulb);
          break;
      }
      return <Widget>[
        IconButton(icon: uesIcon, onPressed: () => {}),
        ];
        }
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
                      {if (value) onDeletion!(event) else print("abort delete")});
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
