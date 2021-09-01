import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/image_classes.dart';

class FriendListTile extends StatelessWidget {
  final bool isInvited;
  final Profile profile;


  const FriendListTile({Key? key, required this.profile, required this.isInvited}): super(key: key);

  @override
  Widget build(BuildContext context) {
    // the container for the listcard
    return Card(
      child: ListTile(
        leading: IconButton(
          //load the avatar
          icon: CircleAvatar(
            radius: 30,
            backgroundImage: ProfileImage.getAssetOrNetworkFromProfile(profile),
          ),
          onPressed: () {

          },),
          title: Text(profile.name.getOrCrash()),
          trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actionButtons(isInvited, context),
        ),
      ),
    );
  }

  /// action buttons for the event, can be made invisible, if its not own events
  List<Widget> actionButtons(bool visible, BuildContext context){
    if(visible){
      return <Widget>[
        IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => {editEvent(context)}
        ),
      ];
    }
    return <Widget>[];
  }


  void editEvent(BuildContext context){
    //context.router.push(EventFormPageRoute(editedEventId: event.id.getOrCrash()));
  }

  void showEvent(BuildContext context){
    //context.router.push(EventScreenPageRoute(eventId: event.id));
  }


  _CircularAvatarWithIcon(){

  }



}