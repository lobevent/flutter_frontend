import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
part 'event_series_invitation.g.dart';

@CopyWith()
class EventSeriesInvitation {
  UniqueId id;
  bool accepted;
  DateTime creationDate;
  Profile invitedProfile;
  Profile invitingProfile;
  EventSeries eventSeries;
  bool isHost;

  EventSeriesInvitation(
      {required this.id,
      required this.eventSeries,
      required this.creationDate,
      required this.invitingProfile,
      required this.invitedProfile,
      required this.accepted,
      required this.isHost}) {}
}
