import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';


class MockProfile extends Mock implements Profile {}

main() {
  test("Profile Convertion", ()
  {
    ProfileDto testProfileDto = ProfileDto(id: 1,name: "manfred");
    ProfileDto convertedProfileDto =
    ProfileDto.fromJson(ProfileDto.fromDomain(testProfileDto.toDomain()).toJson());
    expect(testProfileDto, convertedProfileDto);
  });
}
