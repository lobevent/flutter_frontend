import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/cubit/event_form_cubit.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/add_friends_dialog.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:auto_route/auto_route.dart';

class InviteFriendsWidget extends StatefulWidget{

  const InviteFriendsWidget({
  Key? key,
  }) : super(key: key);

  _InviteFriendsWidgetState createState() => _InviteFriendsWidgetState();
}

class _InviteFriendsWidgetState extends State<InviteFriendsWidget>{



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventFormCubit, EventFormState>(builder: (context, state) {

      return _AddFriendsButton(context, state);
    });
  }

  /// when this button is clicked, the add friends widget should appear
  /// if the friends are still loading, the button is inactive
  Widget _AddFriendsButton(BuildContext context, EventFormState state){
    return Column( children:
      [TextWithIconButton(
        disabled: state.isLoadingFriends,
        onPressed: () => inviteFriends(context, state),
        icon: Icons.group,
        text: AppStrings.inviteFriends,),
        if (state.isLoadingFriends) const LinearProgressIndicator()
      ]);
  }

  void inviteFriends(BuildContext context, EventFormState state){
    showDialog(context: context, builder: (BuildContext context) {
      return AddFriendsDialog(
        friends: state.friends,
        invitedFriends: state.invitedFriends,
        onAddFriend: (Profile profile){context.read<EventFormCubit>().addFriend(profile);},
        onRemoveFriend: (Profile profile){context.read<EventFormCubit>().removeFriend(profile);},);
    });
  }
}