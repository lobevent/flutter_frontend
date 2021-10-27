import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/event/core/profile_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_friends/cubit/profile_friends_cubit.dart';

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

  Widget buildFriendListView(List<Profile> friendsOrPending) {
    if (friendsOrPending.isEmpty) {
      return Center(
        child: Text(AppStrings.noProfilesFound),
      );
    }
    return ListView.builder(
        itemBuilder: (context, index) {
          final friend = friendsOrPending[index];
          if (friend.failureOption.isSome()) {
            return Ink(
                color: Colors.red,
                child: ListTile(
                  title: Text(
                      friend.failureOption.fold(() => "", (a) => a.toString())),
                ));
          } else {
            return ProfileListTiles(
              key: ObjectKey(friend),
              profile: friendsOrPending[index],
              buttonCase: TileButton.deleteFriendButton,
            );
          }
        },
        itemCount: friendsOrPending.length);
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
      //normal tab controller
      child: DefaultTabController(
          length: tabs.length,
          child: BlocBuilder<ProfileFriendsCubit, ProfileFriendsState>(
            builder: (context, state) {
              return Scaffold(
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
                    //build the friendTileListview here or return no friends found
                    buildFriendListView(friends),
                    //build the friendTileListview for pending friends here or return no pending requests found
                    buildFriendListView(pendingFriends),
                  ],
                ),
              );
            },
          )),
    );
  }
}
