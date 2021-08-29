import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:auto_route/auto_route.dart';

class InviteFriendsWidget extends StatefulWidget{

  _InviteFriendsWidgetState createState() => _InviteFriendsWidgetState();
}

class _InviteFriendsWidgetState extends State<InviteFriendsWidget>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  Widget _AddFriendsButton(BuildContext context){
    return TextWithIconButton(
        onPressed: () => context.router.push(InviteFriendsWidgetRoute()),
        icon: Icons.group,
        text: AppStrings.inviteFriends);
  }

}