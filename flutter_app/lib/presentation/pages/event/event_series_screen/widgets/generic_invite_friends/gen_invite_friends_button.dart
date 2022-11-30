import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_screen/widgets/ess_invite_friends_widget.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_screen/widgets/generic_invite_friends/cubit/gen_invite_friends_cubit.dart';

import '../../../../../../domain/profile/profile.dart';
import '../../../../../../l10n/app_strings.dart';
import '../../../../core/list_tiles/friend_list_tile.dart';
import '../../../../core/widgets/add_friends_dialog.dart';
import '../../../../core/widgets/styling_widgets.dart';
enum InviteFriendsButtonType{
  eventseries,
  event,
  todo,
}

class GenInviteFriendsButton extends StatefulWidget {
  final InviteFriendsButtonType inviteFriendsButtonType;
  final Widget? button;
  final Function(Profile) onAddFriend;

  // callback functtion for removing friends
  final Function(Profile) onRemoveFriend;

  // callback function for adding hosts
  final Function(Profile)? onAddHost;
  final Function(Profile)? onRemoveHost;

  GenInviteFriendsButton({
    Key? key,
    this.button,
    required this.onAddFriend,
    required this.onRemoveFriend,
    this.onAddHost,
    this.onRemoveHost, required this.inviteFriendsButtonType,
  }) : super(key: key);

  @override
  GenInviteFriendsButtonState createState() => GenInviteFriendsButtonState();
}

class GenInviteFriendsButtonState extends State<GenInviteFriendsButton> {

  @override
  Widget build(BuildContext context) {
    return GenAddFriendsButton(context);
  }

  Widget GenAddFriendsButton(BuildContext context) {
    return BlocProvider(create: (context)=> GenInviteFriendsCubit(inviteFriendsButtonType: widget.inviteFriendsButtonType),
      child: BlocBuilder<GenInviteFriendsCubit, GenInviteFriendsState>(
        buildWhen: (previous, current) =>
        !(current.status == GenInviteFriendsStatus.loading),
        builder: (context, stateCubit){
          return TextWithIconButton(
            text: AppStrings.inviteFriends,
            disabled: context.read<GenInviteFriendsCubit>().disableButton,
            //state.isLoadingFriends,
            onPressed: () {
              context.read<GenInviteFriendsCubit>().disableButton=true;
              if(stateCubit.status == GenInviteFriendsStatus.loaded){
                openInviteOverlay(context, stateCubit.friends, widget.onAddFriend, widget.onRemoveFriend, widget.onAddHost, widget.onRemoveHost);
              }else{
                context.read<GenInviteFriendsCubit>().loadFriendsAndStuff();
              }
            },
            icon: Icons.group,
          );
        },
      ),
    );



    }
  }

  void openInviteOverlay(
      BuildContext contextParent, List<Profile> friends, Function(Profile p1) onAddFriend, Function(Profile p1) onRemoveFriend, Function(Profile p1)? onAddHost, Function(Profile p1)? onRemoveHost)  {
     showDialog(
        context: contextParent,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(builder: (context, setState) {
            return GenAddFriendsDialog(
              friends: friends,
              onAddFriend: onAddFriend,
              onRemoveFriend: onRemoveFriend,
              onAddHost: onAddHost,
              onRemoveHost: onRemoveHost,
            );
          });
        });
  }

class GenAddFriendsDialog extends StatefulWidget {
  /// the list with all the friends of the user
  final List<Profile> friends;

  // callbackfunctio for adding friend
  final Function(Profile) onAddFriend;

  // callback functtion for removing friends
  final Function(Profile) onRemoveFriend;

  // callback function for adding hosts
  final Function(Profile)? onAddHost;
  final Function(Profile)? onRemoveHost;

  const GenAddFriendsDialog({
    Key? key,
    required this.friends,
    required this.onAddFriend,
    required this.onRemoveFriend,
    this.onAddHost,
    this.onRemoveHost,
  }) : super(key: key);

  GenAddFriendsDialogState createState() => GenAddFriendsDialogState();
}

class GenAddFriendsDialogState extends State<GenAddFriendsDialog> {
  final TextEditingController controller = TextEditingController();
  List<Profile> results = [];

  @override
  void initState() {
    results = List<Profile>.from(widget.friends);
    super.initState();
  }

  /// this override is used, if the widged is changed externaly, so we have to
  /// update the value
  @override
  void didUpdateWidget(covariant GenAddFriendsDialog oldWidget) {
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
          maxHeight: MediaQuery.of(context).size.height * 0.7,
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: ListView.builder(
            //physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: results.length,
            itemBuilder: (context, i) {
              //Invitation? invitation;
              //Profile? assignedToItem;
              //EventSeriesInvitation? es_inv;

              // Here the list tiles are generated
              return FriendListTile(
                profile: results[i],
                // here we check if that person is invited or only a friend. this map and contains returns an bool
                showCheck: isShowCheck(),
                isHost: isShowHost(),

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
                  if (widget.onAddHost != null) {
                    widget.onAddHost!(profile);
                  }
                  setState(() {});
                },
                onRemoveHost: (Profile profile) {
                  if (widget.onRemoveHost != null) {
                    widget.onRemoveHost!(profile);
                  }
                  setState(() {});
                },
              );
            }));
  }

  bool isShowCheck() {
    return false;
  }

  bool isShowHost() {
    return false;
  }
}
