import 'dart:convert';

import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';

import 'deserialization_factory_map.dart';
import 'exceptions.dart';

class ListConverter<DTO extends BaseDto> implements JsonConverter<List<DTO>, List<dynamic>>{
  const ListConverter();

  List<DTO> convertList(List<dynamic> json){
    List<DTO> dtoList;
    try {
      dtoList = json
          .map((e) => e as Map<String, dynamic>)
          .map((e) => factoryMap[DTO](e) as DTO) //factorymap is from the corefile deserialization_factory_map (single point of uglyness)
          .toList(); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>
    } on Exception {
      throw UnexpectedFormatException();
    }
    return dtoList;
  }

  @override
  List<DTO> fromJson(List<dynamic> list) {
    return convertList(list);
  }

  @override
  List<Map<String, dynamic>> toJson(List<DTO> object) {
    // TODO: implement toJson
    throw UnimplementedError();
  }

/*  @override
  Map<String, dynamic> toJson(ProfileDto profileDto) {
    return profileDto.toJson();
  }*/

}



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

