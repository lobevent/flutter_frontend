import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/profile/profile_friends/profile_friends_cubit.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/event/core/profile_list_tiles.dart';

class ProfileFriendsBody extends StatefulWidget {
  @override
  ProfileFriendsBodyState createState() => ProfileFriendsBodyState();
}

class ProfileFriendsBodyState extends State<ProfileFriendsBody>
    with TickerProviderStateMixin {
  List<Profile> friends = [];
  List<Profile> pendingFriends = [];

  //tabs to show
  final List<Tab> tabs = [
    Tab(
      text: "Friends",
    ),
    Tab(
      text: "Not accepted",
    )
  ];
  late TabController tabController;

  @override
  void initState() {
    tabController = getTabController();
    //tabController.addListener();
    super.initState();
  }

  TabController getTabController() {
    return TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileFriendsCubit, ProfileFriendsState>(
      listener: (context, state) => {
        //this is the deletion and loading
        state.maybeMap((value) => {},
            loadedBoth: (state) => {
                  this.friends = state.friendList,
                  this.pendingFriends = state.pendingFriendsList,
                  setState(() {})
                },
            deleted: (state) => {
                  //this is for updating the listview when deleting
                  this.friends.remove(state.profile),
                  setState(() {})
                },
            orElse: () => {})
      },
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
            appBar: TabBar(
              controller: tabController,
              unselectedLabelColor: Colors.black,
              labelColor: Colors.red,
              tabs: tabs,
            ),
            //tabbarview for switching between friends and pending requests
            body: TabBarView(
              controller: tabController,
              children: [
                ListView.builder(
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
                            child: ListTile(
                                title: Text("No friends available :(")));
                      } else {
                        return ProfileListTiles(
                          key: ObjectKey(friend),
                          profile: this.friends[index],
                          buttonCase: TileButton.deleteFriendButton,
                        );
                        //EventListTiles(key: ObjectKey(event), event: this.events[index], allowEdit: true);
                      }
                    },
                    itemCount: this.friends.length),
                ListView.builder(
                    itemBuilder: (context, index) {
                      final friend = this.pendingFriends[index];
                      if (friend.failureOption.isSome()) {
                        return Ink(
                            color: Colors.red,
                            child: ListTile(
                              title: Text(friend.failureOption
                                  .fold(() => "", (a) => a.toString())),
                            ));
                      }
                      if (this.pendingFriends.isEmpty) {
                        return Ink(
                            color: Colors.red,
                            child: ListTile(
                                title: Text("No friends available :(")));
                      } else {
                        return ProfileListTiles(
                          key: ObjectKey(friend),
                          profile: this.pendingFriends[index],
                          buttonCase: TileButton.acceptDeclineFriendButton,
                        );
                        //EventListTiles(key: ObjectKey(event), event: this.events[index], allowEdit: true);
                      }
                    },
                    itemCount: this.pendingFriends.length),
              ],
            )),
      ),
    );
  }
}
