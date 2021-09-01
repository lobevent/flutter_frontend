import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/core/list_tiles/friend_list_tile.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';

class AddFriendsDialog extends StatefulWidget {


  AddFriendsDialogState createState() => AddFriendsDialogState();
}


class AddFriendsDialogState extends State<AddFriendsDialog>{
  final TextEditingController controller = new TextEditingController();
  final List<Profile> results = [];
  final List<Profile> friends = [];
  final List<Profile> invitedFriends = [];


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GenericSearchBar(controller: controller, onSearchTextChanged: onSearchTextChanged)

      ],
    );

  }

  void onSearchTextChanged(String value) {}

  Widget _ProfileListView(BuildContext context){
    return ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, i ){
          return FriendListTile(profile: results[i], isInvited: invitedFriends.contains(friends));
        }
    );
  }



}
