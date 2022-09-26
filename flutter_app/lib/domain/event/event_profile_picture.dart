import 'package:freezed_annotation/freezed_annotation.dart';

import '../profile/profile.dart';

part 'event_profile_picture.freezed.dart';

@freezed
class EventProfilePicture with _$EventProfilePicture {

  const EventProfilePicture._();

  const factory EventProfilePicture({
    required Profile profile,
    required String path,
  }) = EPP;

}
