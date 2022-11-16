import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/add_friends_dialog.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';

import '../cubit/event_series_screen_cubit.dart';

class EssInviteFriendsWidget extends StatefulWidget {
  const EssInviteFriendsWidget({
    Key? key,
  }) : super(key: key);

  _EssInviteFriendsWidgetState createState() => _EssInviteFriendsWidgetState();
}

class _EssInviteFriendsWidgetState extends State<EssInviteFriendsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventSeriesScreenCubit, EventSeriesScreenState>(
        builder: (context, state) {
      return _AddFriendsButton(context, state);
    });
  }

  /// when this button is clicked, the add friends widget should appear
  /// if the friends are still loading, the button is inactive
  Widget _AddFriendsButton(BuildContext context, EventSeriesScreenState state) {
    return Column(children: [
      TextWithIconButton(
        text: AppStrings.inviteFriends,
        disabled: false,
        //state.isLoadingFriends,
        onPressed: () => inviteFriends(context, state),
        icon: Icons.group,
      ),
      //if (state.isLoadingFriends) const LinearProgressIndicator()
    ]);
  }

  void inviteFriends(BuildContext contextWCubit, EventSeriesScreenState state) {
    showDialog(
        context: contextWCubit,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AddFriendsDialog(
              friends: [],
              //state.friends!,
              invitedFriends: [],
              //state.invitedFriends,
              onAddFriend: (Profile profile) {
                contextWCubit.read<EventFormCubit>().addFriend(profile);
              },
              onRemoveFriend: (Profile profile) {
                contextWCubit.read<EventFormCubit>().removeFriend(profile);
              },
              onAddHost: (Profile profile) {
                contextWCubit.read<EventFormCubit>().addFriendAsHost(profile);
              },
              onRemoveHost: (Profile profile) {
                contextWCubit
                    .read<EventFormCubit>()
                    .removeFriendAsHost(profile);
              },
            );
          });
        });
  }
}
