import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_dtos.freezed.dart';
part 'profile_dtos.g.dart';

@freezed
abstract class ProfileDto with _$ProfileDto {
  const ProfileDto._();

  const factory ProfileDto({
    @required int id,
    @required String name,
  }) = _ProfileDto;

  const factory ProfileDto.WithoutId({
    @required String name,
  }) = _ProfileDtoWithoutId;

  factory ProfileDto.fromDomain(Profile profile) {
    return ProfileDto(
      id: profile.id,
      name: profile.name.getOrCrash(),
    );
  }

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);

  Profile toDomain() {
    return Profile(
      id: id,
      name: ProfileName(name),
    );
  }
}
