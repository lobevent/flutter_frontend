import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/add_friends_dialog.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';

class InviteFriendsWidget extends StatefulWidget {
  const InviteFriendsWidget({
    Key? key,
  }) : super(key: key);

  _InviteFriendsWidgetState createState() => _InviteFriendsWidgetState();
}

class _InviteFriendsWidgetState extends State<InviteFriendsWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventFormCubit, EventFormState>(
        builder: (context, state) {
      return _AddFriendsButton(context, state);
    });
  }

  /// when this button is clicked, the add friends widget should appear
  /// if the friends are still loading, the button is inactive
  Widget _AddFriendsButton(BuildContext context, EventFormState state) {
    return Column(children: [
      TextWithIconButton(
        disabled: state.isLoadingFriends,
        onPressed: () => inviteFriends(context, state),
        icon: Icons.group,
        text: AppStrings.inviteFriends,
      ),
      if (state.isLoadingFriends) const LinearProgressIndicator()
    ]);
  }

  void inviteFriends(BuildContext contextWCubit, EventFormState state) {
    showDialog(
        context: contextWCubit,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AddFriendsDialog(
              friends: state.friends,
              invitedFriends: state.event.invitations,
              onAddFriend: (Profile profile) {
                contextWCubit.read<EventFormCubit>().addFriend(profile);
              },
              onRemoveFriend: (Profile profile) {
                contextWCubit.read<EventFormCubit>().removeFriend(profile);
              },
              onAddHost: (Profile profile) {
                contextWCubit.read<EventFormCubit>().addFriendAsHost(profile);
              },
            );
          });
        });
  }
}
