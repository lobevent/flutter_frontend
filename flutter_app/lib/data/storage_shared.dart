import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/data/storage_strings.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageShared {
  String? ownProfileId;

  //TODO: Maybe we should store it in fluttersecurestorage tho, idk if its harmful to know the string of uuid of an user

  ///fetch out of our sharedpreferences
  Future<String?> getOwnProfileFuture() async {
    final sharedStorage = await SharedPreferences.getInstance();
    final String ownProfile = sharedStorage.getString(StorageStrings.ownProfile)!;

    return ownProfile;
  }

  ///helper method
  String getOwnProfile(){
    getOwnProfileFuture().then((ownProfile) => ownProfileId= ownProfile);
    //check if its null
    ownProfileId ??= "";
    return ownProfileId!;
  }

  ///returns true if its the id of own profile
  bool checkIfOwnId(String checkId){
    return getOwnProfile()==checkId;
  }


  ///fetchs ownprofile id and secures it in storageshared
  Future<void> safeOwnProfile() async {
    //fetches profile
    final Either<NetWorkFailure, Profile> ownProfile =
        await GetIt.I<ProfileRepository>().getOwnProfile();
    //initialising sharedstorage
    final sharedStorage = await SharedPreferences.getInstance();
    //saving profile id in shared storage as string
    sharedStorage.setString(
        StorageStrings.ownProfile, ownProfile.fold((l) => "", (r) => r.id.value.toString()));
  }
}
