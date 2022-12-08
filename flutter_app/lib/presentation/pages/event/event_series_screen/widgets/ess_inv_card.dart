import 'package:flutter/material.dart';

import '../../../../../domain/event/event_series_invitation.dart';
import '../../../core/widgets/Profile/profile_popup.dart';

class EventSeriesInvCard extends StatefulWidget {
  final EventSeriesInvitation essInv;

  const EventSeriesInvCard({Key? key, required this.essInv}) : super(key: key);

  @override
  State<EventSeriesInvCard> createState() => _EventSeriesInvCardState();
}

class _EventSeriesInvCardState extends State<EventSeriesInvCard> {
  bool accepted = false;
  bool declinde = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.essInv.eventSeries.name.getOrCrash(),
        ),
        leading: ProfilePopup(
          profile: widget.essInv.invitingProfile,
          isLoading: false,
          loadingButtonSize: 40,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.check)),
            IconButton(onPressed: () {}, icon: Icon(Icons.lunch_dining)),
          ],
        ),
      ),
    );
  }
}
