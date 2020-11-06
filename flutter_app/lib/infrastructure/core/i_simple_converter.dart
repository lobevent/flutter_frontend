import 'package:flutter_frontend/infrastructure/core/i_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';

class SimpleConverter implements JsonConverter<ProfileDto,Map<String, dynamic>> {

  const SimpleConverter();

  @override
  ProfileDto fromJson(Map<String, dynamic> owner) {
    return ProfileDto.fromJson(owner);
  }

  @override
  Map<String, dynamic> toJson(ProfileDto profileDto) {
    return profileDto.toJson();
  }
}
  /*
  @override
  IDto fromDomain() {
    // TODO: implement fromDomain
    return T.fromJson(owner);
  }

  @override
  IDto fromJson(Map<String, dynamic> val) {
    return IDto.fromJson(val);
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson(IDto iDto) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}

   */

