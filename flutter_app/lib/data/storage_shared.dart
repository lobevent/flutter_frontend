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
    final String ownProfile = sharedStorage.getString(StorageStrings.ownProfileId)!;

    return ownProfile;
  }

  ///helper method
  String getOwnProfileId(){
    getOwnProfileFuture().then((ownProfile) => ownProfileId= ownProfile);
    //check if its null
    ownProfileId ??= "";
    return ownProfileId!;
  }

  Future<String?> getOwnProfileImage() async{
    // return SharedPreferences.getInstance().then(
    //         (value) {
    //           return value.getString(StorageStrings.ownProfileImage) == '' ? null : ownProfilePicture;
    //         });
    var insance = await SharedPreferences.getInstance();
    return insance.getString(StorageStrings.ownProfileImage) == '' ? null : insance.getString(StorageStrings.ownProfileImage);
    // final sharedStorage = await SharedPreferences.getInstance();
    // final String ownProfilePicture =   sharedStorage.getString(StorageStrings.ownProfileImage)!;
    //return ownProfilePicture == ''? null : ownProfilePicture;

  }

  ///returns true if its the id of own profile
  bool checkIfOwnId(String checkId){
    return getOwnProfileId()==checkId;
  }


  ///fetchs ownprofile id and secures it in storageshared
  Future<void> safeOwnProfile() async {
    //fetches profile
    final Either<NetWorkFailure, Profile> ownProfile =
        await GetIt.I<ProfileRepository>().getOwnProfile();
    //initialising sharedstorage
    final sharedStorage = await SharedPreferences.getInstance();
    Profile? profile =  ownProfile.fold((l) => null, (r) => r);
    //saving profile id in shared storage as string
    sharedStorage.setString(
        StorageStrings.ownProfileId, profile?.id.value.toString()?? '');
    sharedStorage.setString(StorageStrings.ownProfileImage, profile?.images?[0]??'');
  }
}
