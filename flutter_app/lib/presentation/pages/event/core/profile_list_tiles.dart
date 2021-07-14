import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/profile/profile_friends/profile_friends_cubit.dart';
import 'package:flutter_frontend/application/profile/profile_search/profile_search_cubit.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/image_classes.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class ProfileListTiles extends StatelessWidget {
  final Profile profile;
  final String? imagePath;

  //profile list tiles for searching profiles
  const ProfileListTiles(
      {required ObjectKey key, required this.profile, String? this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileSearchCubit, ProfileSearchState>(
        builder: (context, state) {
      return Card(
          child: ListTile(
        leading: IconButton(
          //load the avatar
          icon: CircleAvatar(
            radius: 30,
            backgroundImage: ProfileImage.getAssetOrNetwork(imagePath),
          ),
          onPressed: () => showProfile(context),
        ),
        title: Text(profile.name.getOrCrash()),
        trailing: Row(
          children: [buildFriendButton(context, "ProfileSearch")],
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ));
      throw UnimplementedError();
    });
  }

  //build the send frienrequest button (in that case)
  Widget buildFriendButton(BuildContext context, String type) {
    return IconButton(
        onPressed: () =>
            context.read<ProfileSearchCubit>().sendFriendship(profile.id),
        icon: Icon(Icons.person_add_alt_1_rounded));
  }

  void showProfile(BuildContext context) {
    context.router.push(ProfilePageRoute(profileId: profile.id));
  }
}

//this class is for friendsoverview, so u can delete friends on this page, with the buildFriendButton method
class FriendListTiles extends StatelessWidget {
  final Profile profile;
  final String? imagePath;

  const FriendListTiles(
      {required ObjectKey key, required this.profile, String? this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileFriendsCubit, ProfileFriendsState>(
        builder: (context, state) {
      return Card(
          child: ListTile(
        leading: IconButton(
          icon: CircleAvatar(
            radius: 30,
            backgroundImage: ProfileImage.getAssetOrNetwork(imagePath),
          ),
          onPressed: () => showProfile(context),
        ),
        title: Text(profile.name.getOrCrash()),
        trailing: Row(
          children: [buildFriendButton(context)],
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
        ),
      ));
      throw UnimplementedError();
    });
  }

  ///build delete friend button
  @override
  Widget buildFriendButton(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.delete_forever),
        onPressed: () {
          deleteFriend(context).then((value) async => {
                if (value)
                  context.read<ProfileFriendsCubit>().deleteFriendship(profile)
                else
                  print("falseee"),
              });
        });
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

  void showProfile(BuildContext context) {
    context.router.push(ProfilePageRoute(profileId: profile.id));
  }
}
