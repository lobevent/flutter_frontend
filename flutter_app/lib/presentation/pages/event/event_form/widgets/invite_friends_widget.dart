import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/event_form/event_form_cubit.dart';
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

      return _AddFriendsButton(context);
    });
  }

  Widget _AddFriendsButton(BuildContext context){
    return TextWithIconButton(
        onPressed: () => inviteFriends(context),
        icon: Icons.group,
        text: AppStrings.inviteFriends);
  }

  void inviteFriends(BuildContext context){
    showDialog(context: context, builder: (BuildContext context) {
      return AddFriendsDialog(
        friends: [Profile(id: UniqueId(), name: ProfileName("ssss")), Profile(id: UniqueId(), name: ProfileName("ssss"))],
        invitedFriends: [], onAddFriend: (){}, onRemoveFriend: (){},);
    });
  }
}