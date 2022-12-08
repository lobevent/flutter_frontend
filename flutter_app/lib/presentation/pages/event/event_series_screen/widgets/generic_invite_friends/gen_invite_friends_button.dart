import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event_series_invitation.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/gen_dialog.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_screen/widgets/ess_invite_friends_widget.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_screen/widgets/generic_invite_friends/cubit/gen_invite_friends_cubit.dart';

import '../../../../../../domain/event/event.dart';
import '../../../../../../domain/event/event_series.dart';
import '../../../../../../domain/profile/profile.dart';
import '../../../../../../l10n/app_strings.dart';
import '../../../../core/list_tiles/friend_list_tile.dart';
import '../../../../core/widgets/add_friends_dialog.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/styling_widgets.dart';

///which cases for inviting friends we have
enum InviteFriendsButtonType {
  eventseries,
  event,
  todo,
}

class GenInviteFriendsButton<T> extends StatelessWidget {
  final InviteFriendsButtonType inviteFriendsButtonType;
  final String? eventSeriesId;
  final Event? event;
  final Widget? button;

  const GenInviteFriendsButton({
    Key? key,
    this.button,
    this.eventSeriesId,
    required this.inviteFriendsButtonType,
    this.event,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return GenAddFriendsButton(context);
  }

  ///return button and handle states, for loading friends and loading invited
  Widget GenAddFriendsButton(BuildContext context) {
    return BlocProvider(
      create: (context) => GenInviteFriendsCubit<T>(
          inviteFriendsButtonType: inviteFriendsButtonType,
          seriesId: eventSeriesId,
          eventId: event?.id.value),
      child: BlocConsumer<GenInviteFriendsCubit<T>, GenInviteFriendsState<T>>(
        listenWhen: (p, c) => p.status != c.status,
        listener: (context, state) async {
          //open overlay if data is there
          if (state.status == GenInviteFriendsStatus.loaded) {
            openInviteOverlay(context, state.friends, state.genericInvs);
          }
        },
        builder: (context, state) {
          if (state.status == GenInviteFriendsStatus.error) {
            //TODO error handling
            print(state.failure.toString());
          }
          return TextWithIconButton(
              onPressed: () async {
                //fetch stuff
                if (state.status == GenInviteFriendsStatus.initial) {
                  context
                      .read<GenInviteFriendsCubit<T>>()
                      .loadFriendsAndStuff(event?.invitations as List<T>?);
                } else {
                  //open the overlay, because data is there
                  if (state.status == GenInviteFriendsStatus.loaded ||
                      state.status == GenInviteFriendsStatus.refresh) {
                    openInviteOverlay(
                        context, state.friends, state.genericInvs);
                  }
                }
              },
              text: state.status == GenInviteFriendsStatus.loading
                  ? "Loading"
                  : AppStrings.inviteFriends);
        },
      ),
    );
  }
}

///open the overlay for showing and searching friends to invite
void openInviteOverlay<T>(
    BuildContext contextParent, List<Profile> friends, List<T> genericInvs) {
  showDialog(
      context: contextParent,
      builder: (BuildContext dialogContext) {
        return GenAddFriendsDialog<T>(
          friends: friends,
          parentContext: contextParent,
          genericInvs: genericInvs,
        );
      });
}

class GenAddFriendsDialog<T> extends StatefulWidget {
  /// the list with all the friends of the user
  final List<Profile> friends;

  /// our gen cubit context
  final BuildContext parentContext;

  /// our gen invites, which are fetched with friends
  final List<T> genericInvs;

  const GenAddFriendsDialog({
    Key? key,
    required this.friends,
    required this.parentContext,
    required this.genericInvs,
  }) : super(key: key);

  GenAddFriendsDialogState createState() => GenAddFriendsDialogState<T>();
}

class GenAddFriendsDialogState<T> extends State<GenAddFriendsDialog> {
  //input search bar
  final TextEditingController controller = TextEditingController();

  ///our friends
  List<Profile> results = [];

  ///for loadingindicator after inviting/revoking a friend
  List<bool> resultsStatusFetching = [];

  ///our generic invites in the state
  List<T> genInvs = [];

  ///init the lists
  @override
  void initState() {
    genInvs = widget.genericInvs as List<T>;
    results = List<Profile>.from(widget.friends);
    resultsStatusFetching = List<bool>.filled(results.length, false);
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

  ///clear the lists for friendlisttiles and handle which to show
  void onSearchTextChanged(String text) {
    // clear the results before working with it
    results.clear();
    resultsStatusFetching = [];
    if (text.isEmpty) {
      results = List<Profile>.from(widget.friends);
      resultsStatusFetching = List<bool>.filled(results.length, false);
      setState(() {});
      return;
    }
    // add each friend that contains the string
    for (Profile friend in widget.friends) {
      if (friend.name.getOrCrash().contains(text)) {
        results.add(friend);
        resultsStatusFetching.add(false);
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
                isLoading: resultsStatusFetching[i],
                profile: results[i],
                // here we check if that person is invited or only a friend. this map and contains returns an bool
                showCheck: isShowCheck(results[i], cubitContext, genInvs),
                isHost: isShowHost(results[i], cubitContext, genInvs),

                // the function given for the button on invitation!
                onAddFriend: (Profile profile) async {
                  // set loading to true
                  setState(() {
                    resultsStatusFetching[i] = true;
                  });
                  await cubitContext
                      .read<GenInviteFriendsCubit<T>>()
                      .sendInvite(profile);
                  var stateX =
                      cubitContext.read<GenInviteFriendsCubit<T>>().state;
                  // emit rebuild and loading = false
                  setState(() {
                    genInvs = stateX.genericInvs;
                    resultsStatusFetching[i] = false;
                  });
                },
                onRemoveFriend: (Profile profile) async {
                  setState(() {
                    resultsStatusFetching[i] = true;
                  });
                  await cubitContext
                      .read<GenInviteFriendsCubit<T>>()
                      .revokeInvite(profile);
                  var stateX =
                      cubitContext.read<GenInviteFriendsCubit<T>>().state;
                  setState(() {
                    genInvs = stateX.genericInvs;
                    resultsStatusFetching[i] = false;
                  });
                },
                //TODO: check if the inviter is host
                onAddHost: (Profile profile) async {
                  setState(() {
                    resultsStatusFetching[i] = true;
                  });
                  await cubitContext
                      .read<GenInviteFriendsCubit<T>>()
                      .sendInviteAsHost(profile);
                  var stateX =
                      cubitContext.read<GenInviteFriendsCubit<T>>().state;
                  setState(() {
                    genInvs = stateX.genericInvs;
                    resultsStatusFetching[i] = false;
                  });
                },
                onRemoveHost: (Profile profile) async {
                  setState(() {
                    resultsStatusFetching[i] = true;
                  });
                  await cubitContext
                      .read<GenInviteFriendsCubit<T>>()
                      .revokeInviteAsHost(profile);
                  var stateX =
                      cubitContext.read<GenInviteFriendsCubit<T>>().state;
                  setState(() {
                    genInvs = stateX.genericInvs;
                    resultsStatusFetching[i] = false;
                  });
                },
              );
            }));
  }

  ///handle if we show the check depending on the Types of genericInv
  bool isShowCheck(
      Profile profile, BuildContext cubitContext, List genericInvs) {
    switch (
        cubitContext.read<GenInviteFriendsCubit<T>>().inviteFriendsButtonType) {
      case InviteFriendsButtonType.eventseries:
        List<EventSeriesInvitation> esInvs =
            genericInvs as List<EventSeriesInvitation>;
        if (esInvs
            .map((e) => e.invitedProfile.id.value)
            .contains(profile.id.value)) {
          return true;
        }
        return false;
      case InviteFriendsButtonType.event:
        List<Invitation> invs = genericInvs as List<Invitation>;
        if (invs.map((e) => e.profile.id.value).contains(profile.id.value)) {
          return true;
        }
        return false;
        break;
      case InviteFriendsButtonType.todo:
        // TODO: Handle this case.
        return false;
        break;
    }
  }

  ///handle if we show the crown depending on the Types of genericInv and if he is host
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
        List<Invitation> invs = genericInvs as List<Invitation>;
        if (invs.map((e) => e.profile.id.value).contains(profile.id.value)) {
          var index = invs.indexWhere(
              (element) => element.profile.id.value == profile.id.value);
          if (invs[index].addHost == true) {
            return true;
          }
        }
        return false;
        break;
      case InviteFriendsButtonType.todo:
        // TODO: Handle this case.
        return false;
        break;
    }
  }
}
