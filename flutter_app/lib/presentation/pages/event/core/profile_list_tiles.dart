import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/image_classes.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class ProfileListTiles extends StatelessWidget {
  final Profile profile;
  //accept/send friendrequest
  final Function(Profile profile)? onFriendRequest;
  //decline/delete friendrequest
  final Function(Profile profile)? onDeleteFriend;

  //profile list tiles for searching profiles
  const ProfileListTiles(
      {required ObjectKey key,
      required this.profile,
      this.onDeleteFriend,
      this.onFriendRequest})
      : super(key: key);

  //card for the friendlisttile with the actionbuttons
  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: IconButton(
        //load the avatar
        icon: CircleAvatar(
          radius: 30,
          backgroundImage: ProfileImage.getAssetOrNetworkFromProfile(profile),
        ),
        onPressed: () => showProfile(context),
      ),
      title: Text(profile.name.getOrCrash()),
      trailing: Row(
        children: [
          actionButtons(
              onFriendRequest != null, onDeleteFriend != null, context)
        ],
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    ));
  }

  //build the send friendrequest buttons
  Widget actionButtons(
      bool acceptOrSend, bool deleteOrDeny, BuildContext context) {
    //for building both buttons to accept or decline the friendrequest
    if (acceptOrSend && deleteOrDeny) {
      return PaddingRowWidget(
        paddinfLeft: 5,
        paddingRight: 5,
        children: [
          //button for sending a friendship
          IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                onFriendRequest!(profile);
              }),
          //button for deleting a friendship, opens a showdialog for submitting
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                deleteFriend(context).then((value) async => {
                      if (value) onDeleteFriend!(profile) else print("falseee"),
                    });
              })
        ],
      );
      //this is for building the delete or decline friend/request buttons
    } else if (!acceptOrSend && deleteOrDeny) {
      return IconButton(
          icon: Icon(Icons.delete_forever),
          onPressed: () {
            deleteFriend(context).then((value) async => {
                  if (value) onDeleteFriend!(profile) else print("falseee"),
                });
          });
      //only build the send friendrequest button
    } else if (!deleteOrDeny && acceptOrSend) {
      return IconButton(
          icon: Icon(Icons.person_add_alt_1_rounded),
          onPressed: () {
            onFriendRequest!(profile);
          });
    }
    return Text("");
  }

  void showProfile(BuildContext context) {
    context.router.push(ProfilePageRoute(profileId: profile.id));
  }

  ///ask for submition
  Future<bool> deleteFriend(BuildContext context) async {
    bool answer = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppStrings.deleteFriendDialogTitle),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppStrings.deleteFriendDialogText),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              //Cpnfirmation
              child: Text(AppStrings.deleteFriendDialogConfirm),
              onPressed: () {
                Navigator.of(context).pop();
                //context.read<OwnEventsCubit>().deleteEvent();
                answer = true;
              },
            ),
            TextButton(
              //Abortion
              child: Text(AppStrings.deleteFriendDialogAbort),
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
