import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/pages/core/list_tiles/friend_list_tile.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/stylings/core_widgets_stylings_text_with_icon.dart';

class InvitedPersonsContent extends StatelessWidget {
  final List<Invitation> invitations;
  const InvitedPersonsContent({Key? key, required this.invitations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 4, child:
      Scaffold(
          appBar: TabBar(tabs: [
              Tab(child: FittedBox(child: TextWithIcon(text: "Invited", icon: Icons.person,))),
              Tab(child: FittedBox(child: TextWithIcon(text: "Interested", icon: Icons.person,))),
              Tab(child: FittedBox(child: TextWithIcon(text: "Attending", icon: Icons.person,))),
              Tab(child: FittedBox(child: TextWithIcon(text: "Refused", icon: Icons.person,))),
            ],
          ),
        body: TabBarView(children: [
          _InvitedPersons(),
          _InterestedPersons(),
          _AttendingPersons(),
          _NotAttendingPersons()
        ],
        ),
      )
    );
  }

  // ---------------------------------------------------------------------------------------------------------
  // +++++++++++++++++++++++++++++++++++ THE PROFILE LISTS +++++++++++++++++++++++++++++++++++++++++++++++++++
  // ---------------------------------------------------------------------------------------------------------

  /**
   * returns an Widget with the invited profiles as list
   */
  Widget _InvitedPersons(){
    List<Invitation> noReactionInvitations = invitations.where((invitation) => invitation.userEventStatus == EventStatus.invited).toList();
    return _generateListView(noReactionInvitations);
  }
  /**
   * returns an Widget with the invited profiles as list
   */
  Widget _InterestedPersons(){
    List<Invitation> noReactionInvitations = invitations.where((invitation) => invitation.userEventStatus == EventStatus.interested).toList();
    return _generateListView(noReactionInvitations);
  }

  /**
   * returns an Widget with the attending profiles as list
   */
  Widget _AttendingPersons(){
    List<Invitation> noReactionInvitations = invitations.where((invitation) => invitation.userEventStatus == EventStatus.attending).toList();
    return _generateListView(noReactionInvitations);
  }

  /**
   * returns an Widget with the not attending profiles as list
   */
  Widget _NotAttendingPersons(){
    List<Invitation> noReactionInvitations = invitations.where((invitation) => invitation.userEventStatus == EventStatus.notAttending).toList();
    return _generateListView(noReactionInvitations);
  }



  /**
   * generates the ListView with the profiles
   */
  Widget _generateListView(List<Invitation> invites){
    return ListView.builder(
        itemCount: invites.length,
        itemBuilder: (context, i) {
          return FriendListTile(profile: invites[i].profile, showCheck: false /* so we dont show the green checker */, onAddFriend: (Profile profile){}, onRemoveFriend: (Profile profile){}, showUninviteButton: true,);
        });
  }



}
