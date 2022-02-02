import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageShared {
  //secures own profile in the sharedpreferences as json string
  Future<void> setOwnProfile(Profile profile) async {
    final sharedStorage = await SharedPreferences.getInstance();
    sharedStorage.setString(
        'profile', jsonEncode(ProfileDto.fromDomain(profile).toJson()));
  }

  Future<Profile> getOwnProfile() async {
    final sharedStorage = await SharedPreferences.getInstance();
    String jsonOwnProfile = sharedStorage.getString('profile')!;
    Profile ownProfile = jsonEncode(jsonOwnProfile) as Profile;

    return ownProfile;
  }

  //fetchs ownprofile and secures it in storageshared
  Future<void> safeOwnProfile() async {
    final Either<NetWorkFailure, Profile> ownProfile =
        await GetIt.I<ProfileRepository>().getOwnProfile();
    StorageShared().setOwnProfile(
        ownProfile.fold((failure) => throw LogicError(), (profile) => profile));
  }
}
