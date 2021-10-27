import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/image_classes.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class FriendListTile extends StatelessWidget {
  final bool isInvited;
  final Profile profile;
  final Function(Profile) onAddFriend;
  final Function(Profile) onRemoveFriend;

  const FriendListTile(
      {Key? key,
      required this.profile,
      required this.isInvited,
      required this.onAddFriend,
      required this.onRemoveFriend})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // the container for the listcard
    return Card(
      child: ListTile(
        leading: IconButton(
          //load the avatar
          icon: _CircularAvatarWithIcon(),
          onPressed: () {
            showFriend(context);
          },
        ),
        // the title text
        title: Text(profile.name.getOrCrash()),
        //the action buttons
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actionButtons(context),
        ),
      ),
    );
  }

  /// action buttons for the event, can be made invisible, if its not own events
  List<Widget> actionButtons(BuildContext context) {
    return <Widget>[
      if (!isInvited)
        IconButton(icon: Icon(Icons.add), onPressed: () => {addFriend(context)})
      else
        IconButton(
            icon: Icon(Icons.close), onPressed: () => {removeFriend(context)})
    ];
  }

  void removeFriend(BuildContext context) {
    onRemoveFriend(profile);
    //context.router.push(EventFormPageRoute(editedEventId: event.id.getOrCrash()));
  }

  void addFriend(BuildContext context) {
    onAddFriend(profile);
    //context.router.push(EventFormPageRoute(editedEventId: event.id.getOrCrash()));
  }

  void showFriend(BuildContext context) {
    context.router.push(ProfilePageRoute(profileId: profile.id));
  }

  // Own Circular Avatar, to show already invited users
  Widget _CircularAvatarWithIcon() {
    return CircleAvatar(
      radius: 20,
      backgroundImage: ProfileImage.getAssetOrNetworkFromProfile(profile),
      child: !isInvited
          ? const Text('')
          : Stack(children: const [
              Align(
                // the alignment, so its bottom right
                alignment: Alignment(0.5, 0.5),
                child: CircleAvatar(
                  radius: 5,
                  // transparent, so its not blue
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
              ),
            ]),
    );
  }
}
