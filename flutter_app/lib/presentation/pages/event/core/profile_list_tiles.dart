import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class ProfileListTiles extends StatelessWidget {
  final Profile profile;

  const ProfileListTiles({required ObjectKey key, required this.profile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: IconButton(
        icon: Icon(Icons.add_a_photo_rounded),
        onPressed: () => showProfile(context),
      ),
      title: Text(profile.name.getOrCrash()),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    ));
    throw UnimplementedError();
  }

  void showProfile(BuildContext context) {
    context.router.push(ProfilePageRoute(profileId: profile.id));
  }
}
