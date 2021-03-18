import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';

class ProfileConverter implements JsonConverter<ProfileDto,Map<String, dynamic>> {

  const ProfileConverter();

  @override
  ProfileDto fromJson(Map<String, dynamic> owner) {
    return ProfileDto.fromJson(owner);
  }

  @override
  Map<String, dynamic> toJson(ProfileDto profileDto) {
    return profileDto.toJson();
  }
}

// class DatetimeConverter implements JsonConverter<DateTime, String>{
//   @override
//   DateTime fromJson(String json) {
//     // TODO: implement fromJson
//     throw UnimplementedError();
//   }
//
//   @override
//   String toJson(DateTime object) {
//     // TODO: implement toJson
//     throw UnimplementedError();
//   }
//
// }

