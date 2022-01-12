

import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'invitation_dtos.freezed.dart';
part 'invitation_dtos.g.dart';

@freezed
class InvitationDto extends BaseDto with _$InvitationDto{

  static final Map dtoToDomainStatus = {
    0: EventStatus.notAttending,
    1: EventStatus.attending,
    2: EventStatus.interested,
    3: EventStatus.invited,
  };

  static final Map domainToDtoStatus =
  dtoToDomainStatus.map((key, value) => MapEntry(value, key));

  const InvitationDto._();

  const factory InvitationDto({
    required String id,
    @EventConverter() EventDto? event,
    @ProfileConverter() required ProfileDto profile,
    required int userEventStatus
  }) = InvitationFull;

  @override
  Invitation toDomain() {
    var test =  dtoToDomainStatus[3];
    return Invitation(
        id: UniqueId.fromUniqueString(id),
        profile: profile.toDomain(),
        event: event?.toDomain(),
        userEventStatus: dtoToDomainStatus[userEventStatus] as EventStatus);
  }

  factory InvitationDto.fromDomain(Invitation invitation){

    return InvitationDto(
        id:  invitation.id.value,
        profile: ProfileDto.fromDomain(invitation.profile as BaseProfile),
        userEventStatus: domainToDtoStatus[invitation.userEventStatus] as int
    );
  }

  factory InvitationDto.fromJson(Map<String, dynamic> json) =>
      _$InvitationDtoFromJson(json);





}