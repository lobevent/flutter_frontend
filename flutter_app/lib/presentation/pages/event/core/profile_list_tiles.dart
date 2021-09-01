import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/profile/profile_friends/profile_friends_cubit.dart';
import 'package:flutter_frontend/application/profile/profile_search/profile_search_cubit.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/image_classes.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

enum TileButton {
  sendFriendButton,
  deleteFriendButton,
  acceptDeclineFriendButton
}

class ProfileListTiles extends StatelessWidget {
  final Profile profile;
  final TileButton buttonCase;

  //profile list tiles for searching profiles
  const ProfileListTiles(
      {required ObjectKey key,
      required this.profile,
      required this.buttonCase})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (buttonCase) {
      //case for profilesearch, to send friendshiprequest
      case TileButton.sendFriendButton:
        return BlocBuilder<ProfileSearchCubit, ProfileSearchState>(
            builder: (context, state) {
          return buildListTile(context, buttonCase);
        });

      //case for friendpage, to delete the friends
      case TileButton.deleteFriendButton:
        return BlocBuilder<ProfileFriendsCubit, ProfileFriendsState>(
            builder: (context, state) {
          return buildListTile(context, buttonCase);
        });
      //case to accept or decline friends in pending friend requests page/tab
      case TileButton.acceptDeclineFriendButton:
        return BlocBuilder<ProfileFriendsCubit, ProfileFriendsState>(
            builder: (context, state) {
          return buildListTile(context, buttonCase);
        });
    }
  }

  ///just build the listtile of a profile to show in a list
  Widget buildListTile(BuildContext context, TileButton buttonCase) {
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
        children: [buildFriendButton(context, buttonCase)],
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    ));
  }

  //build the send friendrequest buttons
  Widget buildFriendButton(BuildContext context, TileButton buttonCase) {
    switch (buttonCase) {
      //build send friednship button
      case TileButton.sendFriendButton:
        return IconButton(
            onPressed: () =>
                context.read<ProfileSearchCubit>().sendFriendship(profile.id),
            icon: Icon(Icons.person_add_alt_1_rounded));
      case TileButton.deleteFriendButton:
        return IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              deleteFriend(context).then((value) async => {
                    if (value)
                      context
                          .read<ProfileFriendsCubit>()
                          .deleteFriendship(profile)
                    else
                      print("falseee"),
                  });
            });
      case TileButton.acceptDeclineFriendButton:
        return PaddingRowWidget(
          paddinfLeft: 5,
          paddingRight: 5,
          children: [
            //button for sending a friendship
            IconButton(
                icon: Icon(Icons.add_circle),
                onPressed: () {
                  context.read<ProfileFriendsCubit>().acceptFriendship(profile);
                }),
            //button for deleting a friendship, opens a showdialog for submitting
            IconButton(
                icon: Icon(Icons.delete_forever),
                onPressed: () {
                  deleteFriend(context).then((value) async => {
                        if (value)
                          context
                              .read<ProfileFriendsCubit>()
                              .deleteFriendship(profile)
                        else
                          print("falseee"),
                      });
                })
          ],
        );
    }
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
