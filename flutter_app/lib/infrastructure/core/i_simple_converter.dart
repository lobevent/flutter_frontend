import 'package:flutter_frontend/infrastructure/core/i_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class SimpleConverter implements JsonConverter<IDto, Map<String, dynamic>>{

  const SimpleConverter();
  @override
  IDto fromDomain() {
    // TODO: implement fromDomain
    throw UnimplementedError();
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

//TODO ProfileDto and owner
class Converter<T> implements JsonConverter<T, Map<String, dynamic>>{
  const Converter();
  @override
  T fromJson(Map<String, dynamic> owner) {
    return T.fromJson(owner);
  }

  @override
  Map<String, dynamic> toJson(ProfileDto profileDto) {
    return profileDto.toJson();
  }