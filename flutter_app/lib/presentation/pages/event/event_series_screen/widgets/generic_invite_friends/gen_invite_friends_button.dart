import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event_series_invitation.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_screen/widgets/ess_invite_friends_widget.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_screen/widgets/generic_invite_friends/cubit/gen_invite_friends_cubit.dart';

import '../../../../../../domain/event/event_series.dart';
import '../../../../../../domain/profile/profile.dart';
import '../../../../../../l10n/app_strings.dart';
import '../../../../core/list_tiles/friend_list_tile.dart';
import '../../../../core/widgets/add_friends_dialog.dart';
import '../../../../core/widgets/styling_widgets.dart';

enum InviteFriendsButtonType {
  eventseries,
  event,
  todo,
}

class GenInviteFriendsButton<T> extends StatefulWidget {
  final InviteFriendsButtonType inviteFriendsButtonType;
  final String? eventSeriesId;
  final Widget? button;

  GenInviteFriendsButton({
    Key? key,
    this.button,
    this.eventSeriesId,
    required this.inviteFriendsButtonType,
  }) : super(key: key);

  @override
  GenInviteFriendsButtonState createState() => GenInviteFriendsButtonState<T>();
}

class GenInviteFriendsButtonState<T> extends State<GenInviteFriendsButton> {
  @override
  Widget build(BuildContext context) {
    return GenAddFriendsButton(context);
  }

  Widget GenAddFriendsButton(BuildContext context) {
    //Type T = widget.inviteFriendsButtonType == InviteFriendsButtonType.event ? Invitation : widget.inviteFriendsButtonType == InviteFriendsButtonType.eventseries ? EventSeriesInvitation : Todo;
    return BlocProvider(
      create: (context) => GenInviteFriendsCubit<T>(
          inviteFriendsButtonType: widget.inviteFriendsButtonType,
          seriesId: widget.eventSeriesId),
      child: BlocBuilder<GenInviteFriendsCubit<T>, GenInviteFriendsState<T>>(
        buildWhen: (previous, current) =>
            !(current.status == GenInviteFriendsStatus.loading),
        builder: (context, stateCubit) {
          return TextWithIconButton(
            text: AppStrings.inviteFriends,
            disabled: context.read<GenInviteFriendsCubit<T>>().disableButton,
            onPressed: () {
              context.read<GenInviteFriendsCubit<T>>().disableButton = true;
              if (stateCubit.status == GenInviteFriendsStatus.loaded ||
                  stateCubit.status == GenInviteFriendsStatus.refresh) {
                context.read<GenInviteFriendsCubit<T>>().disableButton = false;
                openInviteOverlay<T>(context, stateCubit.friends,
                    context.read<GenInviteFriendsCubit<T>>().state.genericInvs);
              } else {
                context.read<GenInviteFriendsCubit<T>>().loadFriendsAndStuff();
                //context.read<GenInviteFriendsCubit<T>>().disableButton = false;
              }
            },
            icon: Icons.group,
          );
        },
      ),
    );
  }
}

void openInviteOverlay<T>(BuildContext contextParent, List<Profile> friends,
    List<dynamic> genericInvs) {
  showDialog(
      context: contextParent,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (context, setState) {
          return GenAddFriendsDialog<T>(
            friends: friends,
            parentContext: contextParent,
            genericInvs: genericInvs,
          );
        });
      });
}

class GenAddFriendsDialog<T> extends StatefulWidget {
  /// the list with all the friends of the user
  final List<Profile> friends;

  final BuildContext parentContext;

  final List<dynamic> genericInvs;

  const GenAddFriendsDialog({
    Key? key,
    required this.friends,
    required this.parentContext,
    required this.genericInvs,
  }) : super(key: key);

  GenAddFriendsDialogState createState() => GenAddFriendsDialogState<T>();
}

class GenAddFriendsDialogState<T> extends State<GenAddFriendsDialog> {
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
        _ProfileListView(context, widget.parentContext)
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
  Widget _ProfileListView(BuildContext context, BuildContext cubitContext) {
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
              // Here the list tiles are generated
              return FriendListTile(
                profile: results[i],
                // here we check if that person is invited or only a friend. this map and contains returns an bool
                showCheck:
                    isShowCheck(results[i], cubitContext, widget.genericInvs),
                isHost:
                    isShowHost(results[i], cubitContext, widget.genericInvs),

                // the function given for the button on invitation!
                onAddFriend: (Profile profile) {
                  cubitContext
                      .read<GenInviteFriendsCubit<T>>()
                      .sendInvite(profile)
                      .then((value) => setState(() {}));
                },
                onRemoveFriend: (Profile profile) {
                  cubitContext
                      .read<GenInviteFriendsCubit<T>>()
                      .revokeInvite(profile)
                      .then((value) => setState(() {}));
                },
                //TODO: check if the inviter is host
                onAddHost: (Profile profile) {
                  cubitContext
                      .read<GenInviteFriendsCubit<T>>()
                      .sendInviteAsHost(profile)
                      .then((value) => setState(() {}));
                },
                onRemoveHost: (Profile profile) {
                  cubitContext
                      .read<GenInviteFriendsCubit<T>>()
                      .revokeInviteAsHost(profile)
                      .then((value) {
                    setState(() {});
                  });
                },
              );
            }));
  }

  bool isShowCheck(
      Profile profile, BuildContext cubitContext, List genericInvs) {
    switch (
        cubitContext.read<GenInviteFriendsCubit<T>>().inviteFriendsButtonType) {
      case InviteFriendsButtonType.eventseries:
        List<EventSeriesInvitation> esInvs =
            widget.genericInvs as List<EventSeriesInvitation>;
        if (esInvs
            .map((e) => e.invitedProfile.id.value)
            .contains(profile.id.value)) {
          return true;
        }
        return false;
      case InviteFriendsButtonType.event:
        // TODO: Handle this case.
        return false;
        break;
      case InviteFriendsButtonType.todo:
        // TODO: Handle this case.
        return false;
        break;
    }
  }

  bool isShowHost(
      Profile profile, BuildContext cubitContext, List genericInvs) {
    switch (
        cubitContext.read<GenInviteFriendsCubit<T>>().inviteFriendsButtonType) {
      case InviteFriendsButtonType.eventseries:
        List<EventSeriesInvitation> esInvs = cubitContext
            .read<GenInviteFriendsCubit<T>>()
            .state
            .genericInvs as List<EventSeriesInvitation>;
        if (esInvs
            .map((e) => e.invitedProfile.id.value)
            .contains(profile.id.value)) {
          var index = esInvs.indexWhere(
              (element) => element.invitedProfile.id.value == profile.id.value);
          if (esInvs[index].isHost == true) {
            return true;
          } else {
            return false;
          }
        }
        return false;
      case InviteFriendsButtonType.event:
        // TODO: Handle this case.
        return false;
        break;
      case InviteFriendsButtonType.todo:
        // TODO: Handle this case.
        return false;
        break;
    }
  }
}
