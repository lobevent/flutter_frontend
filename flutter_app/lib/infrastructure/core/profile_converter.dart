import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:json_annotation/json_annotation.dart';

class ProfileConverter
    implements JsonConverter<ProfileDto, Map<String, dynamic>> {
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