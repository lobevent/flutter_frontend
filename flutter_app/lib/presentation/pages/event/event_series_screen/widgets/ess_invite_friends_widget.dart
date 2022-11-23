import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/add_friends_dialog.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';

import '../../../../../domain/event/event_series_invitation.dart';
import '../../../core/widgets/error_widget.dart';
import '../cubit/event_series_screen_cubit.dart';

class EssInviteFriendsWidget extends StatefulWidget {
  const EssInviteFriendsWidget({
    Key? key,
  }) : super(key: key);

  _EssInviteFriendsWidgetState createState() => _EssInviteFriendsWidgetState();
}

class _EssInviteFriendsWidgetState extends State<EssInviteFriendsWidget> {
  bool disableButton = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventSeriesScreenCubit, EventSeriesScreenState>(
        builder: (context, state) {
      if (state.status == EventSeriesScreenStatus.error) {
        return NetworkErrorWidget(failure: state.failure!);
      }
      return _AddFriendsButton(context, state);
    });
  }

  /// when this button is clicked, the add friends widget should appear
  /// if the friends are still loading, the button is inactive
  Widget _AddFriendsButton(BuildContext context, EventSeriesScreenState state) {
    return Column(children: [
      TextWithIconButton(
        text: AppStrings.inviteFriends,
        disabled: disableButton,
        //state.isLoadingFriends,
        onPressed: () {
          context
              .read<EventSeriesScreenCubit>()
              .getFriendsAndEsInv()
              .then((value) => inviteFriends(context, state));
        },
        icon: Icons.group,
      ),
      //if (state.isLoadingFriends) const LinearProgressIndicator()
    ]);
  }

  void inviteFriends(BuildContext contextWCubit, EventSeriesScreenState state) {
    if (state.friends.isNotEmpty) {
      showDialog(
          context: contextWCubit,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AddFriendsDialog(
                friends: state.friends,
                //state.friends!,
                invitedFriends: [],
                esInvitations: state.esInv,
                //state.invitedFriends,
                onAddFriend: (Profile profile) {
                  contextWCubit
                      .read<EventSeriesScreenCubit>()
                      .addFriend(state.eventSeries, true, profile, false);
                },
                onRemoveFriend: (Profile profile) {
                  contextWCubit
                      .read<EventSeriesScreenCubit>()
                      .removeFriend(profile);
                },
                onAddHost: (Profile profile) {
                  contextWCubit
                      .read<EventSeriesScreenCubit>()
                      .addFriendAsHost(profile);
                },
                onRemoveHost: (Profile profile) {
                  contextWCubit
                      .read<EventSeriesScreenCubit>()
                      .removeFriendAsHost(profile);
                },
              );
            });
          });
    }
  }
}
