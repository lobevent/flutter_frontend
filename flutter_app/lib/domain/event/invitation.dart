import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'event.dart';

part 'invitation.freezed.dart';

@freezed
class Invitation with _$Invitation{

  const Invitation._();

  const factory Invitation({
    UniqueId? id,
    required Profile profile,
    required Event event,
    required int userEventStatus,
  }) = FullInvitation;
}