import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/core/list_tiles/friend_list_tile.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';

class AddFriendsDialog extends StatefulWidget {
  /// the list with all the friends of the user
  final List<Profile> friends;

  /// the list with all the friends, that are invited
  final List<Invitation> invitedFriends;
  // callbackfunctio for adding friend
  final Function(Profile) onAddFriend;
  // callback functtion for removing friends
  final Function(Profile) onRemoveFriend;
  // callback function for adding hosts
  final Function(Profile)? onAddHost;

  const AddFriendsDialog(
      {Key? key,
      required this.friends,
      required this.invitedFriends,
      required this.onAddFriend,
      required this.onRemoveFriend,
      this.onAddHost})
      : super(key: key);

  AddFriendsDialogState createState() => AddFriendsDialogState();
}

class AddFriendsDialogState extends State<AddFriendsDialog> {
  final TextEditingController controller = new TextEditingController();
  List<Profile> results = [];

  @override
  void initState() {
    results = List<Profile>.from(widget.friends);
    super.initState();
  }

  /// this override is used, if the widged is changed externaly, so we have to
  /// update the value
  @override
  void didUpdateWidget(covariant AddFriendsDialog oldWidget) {
    // TODO: implement didUpdateWidget
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // searchbar
        GenericSearchBar(
            controller: controller, onSearchTextChanged: onSearchTextChanged),
        // the listtiles
        _ProfileListView(context)
      ],
    );
  }

  void onSearchTextChanged(String text) {
    // clear the results before working with it
    results.clear();
    if (text.isEmpty) {
      results = List<Profile>.from(widget.friends);
      setState(() {});
      return;
    }
    // add each friend that contains the string
    for (Profile friend in widget.friends) {
      if (friend.name.getOrCrash().contains(text)) {
        results.add(friend);
      }
    }

    setState(() {});
  }

  /// listview of the proviles as Friend tile
  Widget _ProfileListView(BuildContext context) {
    // that one is for layout testing
    //for(int i = 0; i < 30; i++){results.add(results[0].copyWith(name: ProfileName("input")));}

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height*0.7,
        maxWidth: MediaQuery.of(context).size.width*0.8,
      ),
        child: ListView.builder(
          //physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: results.length,
          itemBuilder: (context, i) {
            Invitation? invitation;
            try {
              invitation = widget.invitedFriends.firstWhere((element) => element.profile.id.value.toString() == results[i].id.value.toString());
            } catch(e){
            }

            // Here the list tiles are generated
            return FriendListTile(
              profile: results[i],
              // here we check if that person is invited or only a friend. this map and contains returns an bool
              isInvited: invitation != null,
              isHost: invitation?.addHost ?? false,

              // the function given for the button on invitation!
              onAddFriend: (Profile profile) {
                widget.onAddFriend(profile);
                setState(() {});
              },
              onRemoveFriend: (Profile profile) {
                widget.onRemoveFriend(profile);
                setState(() {});
              },
              //TODO: check if the inviter is host
              onAddHost: (Profile profile) {
                if(widget.onAddHost != null){
                  widget.onAddHost!(profile);
                }
                setState(() {});
              },
            );
          }));
  }
}
