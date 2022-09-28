import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../profile/profile.dart';

part 'event_profile_picture.freezed.dart';

@freezed
class EventProfilePicture with _$EventProfilePicture {

  const EventProfilePicture._();

  const factory EventProfilePicture({
    required UniqueId id,
    required Profile profile,
    required String path,
  }) = EPP;

}
