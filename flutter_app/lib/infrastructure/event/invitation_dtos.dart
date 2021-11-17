

import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'event_dtos.dart';

part 'invitation_dtos.freezed.dart';
part 'invitation_dtos.g.dart';

@freezed
class InvitationDto extends BaseDto with _$InvitationDto{

  const InvitationDto._();

  const factory InvitationDto({
    required String id,
    EventDto? event,
    @ProfileConverter() required ProfileDto profile,
    required int userEventStatus
  }) = InvitationFull;

  @override
  Invitation toDomain() {
    return Invitation(
        id: UniqueId.fromUniqueString(id),
        profile: profile.toDomain(),
        event: event?.toDomain(),
        userEventStatus: userEventStatus);
  }

  factory InvitationDto.fromDomain(Invitation invitation){

    return InvitationDto(
        id:  invitation.id.value,
        profile: ProfileDto.fromDomain(invitation.profile as BaseProfile),
        userEventStatus: invitation.userEventStatus
    );
  }

  factory InvitationDto.fromJson(Map<String, dynamic> json) =>
      _$InvitationDtoFromJson(json);





}