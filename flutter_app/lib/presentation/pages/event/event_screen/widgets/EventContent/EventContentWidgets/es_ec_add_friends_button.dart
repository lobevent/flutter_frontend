import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/add_friends_dialog.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/add_friends/add_friends_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';

///
/// the add friends button class, here friends can be added to the event!
///
class AddFriendsButton extends StatelessWidget {
  const AddFriendsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext eventCubitContext) {
    return OutlinedNonOverflowbutton( text: "add Friends", icon: Icons.accessible,
        onPressed: () {
          // opens an dialog
          showDialog(context: eventCubitContext, builder: (noCubitContext) {
            return BlocProvider(
              create: (context) => AddFriendsCubit(),
              child: BlocBuilder<AddFriendsCubit, AddFriendsState>(
                builder: (context, state){
                  return state.map(
                      // loading state
                      loadingFriends:(state) => LoadingOverlay(child: Text(''), isLoading: true),
                      // loaded state
                      loadedFriends: (state) {
                        // show the add friends dialog
                        return AddFriendsDialog(
                            friends: state.friends,
                            //get the invitations from the event
                            invitedFriends: eventCubitContext.read<EventScreenCubit>().state.maybeMap(orElse: () => [], loaded: (state) => state.event.invitations),
                            // add friend function
                            onAddFriend: (friend) {onAddFriend(eventCubitContext, context, friend);},

                            onAddHost: (friend) {onAddHost(eventCubitContext, context, friend);},
                            onRemoveHost: (friend) {onRemoveHost(eventCubitContext, context, friend);},

                            //remove friend function
                            onRemoveFriend: (friend) {onRemoveInvite(eventCubitContext, context, friend);});
                      },
                      //error state
                      error: (state) => Text(state.failure.toString()));
                },
              ),
            );
          });
        });
  }

  ///
  /// on ad friend function, outsources so its better readable
  ///
  void onAddFriend(BuildContext eventCubitContext, BuildContext currentContext, Profile friend){
    currentContext.read<AddFriendsCubit>().inviteFriend(friend,
        eventCubitContext.read<EventScreenCubit>().state.maybeMap(orElse: () => throw LogicError(), loaded: (state) => state.event),
        false, eventCubitContext.read<EventScreenCubit>());
  }

  ///
  /// remove invite function, outsourced for readability
  ///
  void onRemoveInvite(BuildContext eventCubitContext, BuildContext currentContext, Profile friend){
    currentContext.read<AddFriendsCubit>().revokeInvitation(friend,
        eventCubitContext.read<EventScreenCubit>().state.maybeMap(orElse: () => throw LogicError(), loaded: (state) => state.event),
        eventCubitContext.read<EventScreenCubit>());
  }

  ///
  /// make an friend host, so they can add other friends too
  void onAddHost(BuildContext eventCubitContext, BuildContext currentContext, Profile friend) {
    currentContext.read<AddFriendsCubit>().onAddHost(friend,
        eventCubitContext.read<EventScreenCubit>().state.maybeMap(orElse: () => throw LogicError(), loaded: (state) => state.event),
        eventCubitContext.read<EventScreenCubit>());
  }

  ///
  /// make an friend host, so they can add other friends too
  void onRemoveHost(BuildContext eventCubitContext, BuildContext currentContext, Profile friend) {
    currentContext.read<AddFriendsCubit>().onRemoveHost(friend,
        eventCubitContext.read<EventScreenCubit>().state.maybeMap(orElse: () => throw LogicError(), loaded: (state) => state.event),
        eventCubitContext.read<EventScreenCubit>());
  }
}
