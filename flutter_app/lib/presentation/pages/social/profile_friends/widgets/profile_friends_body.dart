import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/profile/profile_friends/profile_friends_cubit.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/event/core/profile_list_tiles.dart';

class ProfileFriendsBody extends StatefulWidget {
  @override
  ProfileFriendsBodyState createState() => ProfileFriendsBodyState();
}

class ProfileFriendsBodyState extends State<ProfileFriendsBody> {
  List<Profile> friends = [];
  @override
  Widget build(BuildContext context) {

    return BlocListener<ProfileFriendsCubit, ProfileFriendsState>(
      listener: (context, state) => {
        //this is the deletion and loading
        state.maybeMap(
                (value) => {},
            loaded: (state) =>
                {
                  this.friends = state.friendList,
                  setState(() {})},
            deleted: (state) => {
                  //this is for updating the listview when deleting
                  this.friends.remove(state.profile),
                  setState(() {})
                },
            orElse: () => {})
      },
      child: ListView.builder(
          itemBuilder: (context, index) {
            final friend = this.friends[index];
            if (friend.failureOption.isSome()) {
              return Ink(
                  color: Colors.red,
                  child: ListTile(
                    title: Text(friend.failureOption
                        .fold(() => "", (a) => a.toString())),
                  ));
            }
            if (this.friends.isEmpty) {
              return Ink(
                  color: Colors.red,
                  child: ListTile(title: Text("No friends available :(")));
            } else {
              return ProfileListTiles(
                  key: ObjectKey(friend), profile: this.friends[index]);
              //EventListTiles(key: ObjectKey(event), event: this.events[index], allowEdit: true);
            }
          },
          itemCount: this.friends.length),
    );
  }
}
