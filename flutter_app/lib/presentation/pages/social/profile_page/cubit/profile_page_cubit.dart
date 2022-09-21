import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/data/common_hive.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../../../../domain/core/errors.dart';
import '../../../../../infrastructure/profile/achievements_dtos.dart';

part 'profile_page_cubit.freezed.dart';
part 'profile_page_state.dart';

class ProfilePageCubit extends Cubit<ProfilePageState> {
  final UniqueId profileId;

  ProfilePageCubit({required UniqueId this.profileId})
      : super(ProfilePageState.loading()) {
    loadProfile(profileId);
  }

  ProfileRepository repository = GetIt.I<ProfileRepository>();

  Future<void> loadProfile(UniqueId profileId) async {
    emit(ProfilePageState.loading());
    Either<NetWorkFailure, Profile> response =
        await repository.getSingleProfile(profileId);

    response.fold(
        (NetWorkFailure f) => emit(ProfilePageState.error(error: f.toString())),
        (Profile pro) => emit(ProfilePageState.loaded(profile: pro)));
  }

  void changePictures(List<XFile?> images) {
    state.maybeMap(
        orElse: () {},
        loaded: (loadedState) {
          emit(loadedState.copyWith(images: images));
        });
  }

  Future<void> postProfilePics() async {
    await state.maybeMap(
      loaded: (value) async {
        Either<NetWorkFailure, String> filePathOrFail = await repository
            .uploadImages(value.profile.id, value.images.first!);
        //add our post to posts and emit the postsscreen
        filePathOrFail.fold(
            (fail) => emit(ProfilePageState.error(error: fail.toString())),
            (filePath) {
          emit(ProfilePageState.loading());
          value.profile.images!.insert(0, filePath);
          emit(ProfilePageState.loaded(profile: value.profile));
        });
      },
      orElse: () => throw LogicError(),
    );
  }

  ///
  /// Uploads all images in the state one by one to the server and returns altered Post with the images inside
  ///
  Future<Profile> uploadImages(
      Profile profile, _ProfilePageLoaded loaded) async {
    if (profile.images == null) {
      profile = profile.copyWith(images: []);
    }
    for (XFile? element in loaded.images) {
      if (element != null) {
        await repository.uploadImages(profile.id, element).then((value) {
          value.fold(
              (l) => null, (imagePath) => profile.images!.add(imagePath));
        });
      }
    }
    ;
    return profile;
  }

  //gets own profilescore as string, or shows 0
  Future<String> getProfileScore(Profile profile) async {
    return await repository
        .getScore(profile.id.value.toString())
        .then((value) => value.fold((l) => '0', (r) {
              //safe profilescore in commonhive
              CommonHive.saveBoxEntry(
                  r, "profileScore", CommonHive.ownProfileIdAndPic);
              return r;
            }));
  }

  //fetch profiles and maybe do some logic here
  Future<void> getAchievements(Profile profile) async {
    return await repository
        .getAchievements(profile.id.value.toString())
        .then((value) => value.fold((l) => null, (r) => r));
  }
}
