

import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'event_dtos.dart';

part 'invitation_dtos.freezed.dart';
part 'invitation_dtos.g.dart';

@freezed
class InvitationDto extends BaseDto with _$InvitationDto{

  const InvitationDto._();

  const factory InvitationDto({
    String? id,
    required EventDto event,
    required ProfileDto profile,
    required int userEventStatus
  }) = InvitationFull;

  @override
  toDomain() {
    return Invitation(
        profile: profile.toDomain(),
        event: event.toDomain(),
        userEventStatus: userEventStatus);
  }

  factory InvitationDto.fromJson(Map<String, dynamic> json) =>
      _$InvitationDtoFromJson(json);




}