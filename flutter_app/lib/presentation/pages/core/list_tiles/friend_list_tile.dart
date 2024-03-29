import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/loading_button.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/imageAndFiles/image_classes.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class FriendListTile extends StatelessWidget {
  final bool showCheck;
  final bool showUninviteButton;
  final bool isHost;
  final bool isLoading;
  final Profile profile;
  final Function(Profile) onAddFriend;
  final Function(Profile) onRemoveFriend;
  final Function(Profile)? onAddHost;
  final Function(Profile)? onRemoveHost;

  //final OverlayEntry? overlayEntry;

  const FriendListTile(
      {Key? key,
      this.showUninviteButton = false,
      required this.profile,
      required this.showCheck,
      required this.onAddFriend,
      required this.onRemoveFriend,
      this.isHost = false,
      this.onAddHost,
      this.onRemoveHost, this.isLoading =false/*, this.overlayEntry*/
      })
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
            //overlayEntry?.dispose();
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
      //TODO: third condition may be fcking things up for inviting people idk
      if (!showCheck && !showUninviteButton)
        isLoading!=true? IconButton(icon: Icon(Icons.add), onPressed: () => {addFriend(context)}): LoadingButton(size: 25,)
      else
        isLoading!=true?IconButton(
            icon: Icon(Icons.close), onPressed: () => {removeFriend(context)}): LoadingButton(size: 25,),
      if (isHost == false)
        isLoading!=true? IconButton(
            icon: Icon(Icons.account_box), onPressed: () => {addHost(context)}): LoadingButton(size: 25,)
      else
        IconButton(
            icon: Icon(Icons.account_box_outlined),
            onPressed: () => {removeHost(context)})
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

  void addHost(BuildContext context) {
    onAddHost!(profile);
  }

  void removeHost(BuildContext context) {
    onRemoveHost!(profile);
  }

  void showFriend(BuildContext context) {
    context.router.push(ProfilePageRoute(profileId: profile.id));
  }

  // Own Circular Avatar, to show already invited users
  Widget _CircularAvatarWithIcon() {
    return CircleAvatar(
      radius: 20,
      backgroundImage: ProfileImage.getAssetOrNetworkFromProfile(profile),
      child: !showCheck
          ? const Text('')
          : Stack(children: [
              Align(
                // the alignment, so its bottom right
                alignment: Alignment(0.5, 0.5),
                child: CircleAvatar(
                  radius: 5,
                  // transparent, so its not blue
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    isHost ? Icons.castle_rounded : Icons.check_circle,
                    //color: AppColors.backGroundColor,
                  ),
                ),
              ),
            ]),
    );
  }
}
