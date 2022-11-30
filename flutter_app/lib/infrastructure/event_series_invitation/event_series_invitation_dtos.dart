import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/domain/event/event_series_invitation.dart';
import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/profile/profile.dart';
import '../event_series/eventSeries_dtos.dart';
import '../profile/profile_dtos.dart';

part 'event_series_invitation_dtos.g.dart';

@JsonSerializable()
@ProfileConverter()
@EventSeriesConverter()
class EventSeriesInvitationDto extends BaseDto {
  bool accepted;
  bool isHost;
  String id;
  DateTime creationDate;
  @ProfileConverter()
  ProfileDto invitedProfile;
  @PostConverter()
  ProfileDto invitingProfile;
  @EventSeriesConverter()
  EventSeriesDto eventSeries;

  EventSeriesInvitationDto(
      {required this.isHost,
      required this.accepted,
      required this.creationDate,
      required this.invitedProfile,
      required this.invitingProfile,
      required this.eventSeries,
      required this.id}) {}

  @override
  EventSeriesInvitation toDomain() => EventSeriesInvitation(
      id: UniqueId.fromUniqueString(id),
      accepted: accepted,
      creationDate: creationDate,
      invitedProfile: invitedProfile.toDomain(),
      invitingProfile: invitingProfile.toDomain(),
      isHost: isHost,
      eventSeries: eventSeries.toDomain());

  factory EventSeriesInvitationDto.fromJson(Map<String, dynamic> json) =>
      _$EventSeriesInvitationDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EventSeriesInvitationDtoToJson(this);
}
