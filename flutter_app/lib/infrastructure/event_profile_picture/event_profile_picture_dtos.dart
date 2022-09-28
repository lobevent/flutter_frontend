
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event_profile_picture.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../profile/profile_dtos.dart';

part 'event_profile_picture_dtos.g.dart';

@JsonSerializable()
@ProfileConverter()
class EventProfilePictureDto extends BaseDto{
  String id;
  @ProfileConverter()
  ProfileDto profile;
  String path;

  EventProfilePictureDto(this.profile, this.path, this.id){}


  @override
  EventProfilePicture toDomain() {
    return EventProfilePicture(
      id: UniqueId.fromUniqueString(id),
      profile: profile.toDomain(),
      path: path
    );
  }

  factory EventProfilePictureDto.fromJson(Map<String, dynamic> json) => _$EventProfilePictureDtoFromJson(json);

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    return _$EventProfilePictureDtoToJson(this);
  }

}