import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/infrastructure/profile/achievements_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:flutter_frontend/presentation/pages/social/profile_page/cubit/profile_page_cubit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';

import '../../../../domain/core/failures.dart';
import '../../../../infrastructure/core/local/common_hive/common_hive.dart';
import '../../../../domain/profile/profile.dart';

part 'profile_score_cubit.freezed.dart';

part 'profile_score_state.dart';

class ProfileScoreCubit extends Cubit<ProfileScoreState> {
  final UniqueId profileId;
  final bool isOwnProfile;

  ProfileScoreCubit({required this.profileId, required this.isOwnProfile})
      : super(ProfileScoreState.loading()) {
    emit(ProfileScoreState.loading());
  }

  ProfileRepository repository = GetIt.I<ProfileRepository>();

  ///gets own profilescore and saves it to commonhive, if its our own profile
  Future<void> getProfileScore(Profile profile) async {
    return repository.getScore(profile.id.value.toString()).then((value) =>
        value.fold((l) => emit(ProfileScoreState.error(error: l.toString())),
            (r) async {
          //safe profilescore in commonhive
          if (isOwnProfile) {
            CommonHive.saveBoxEntry<String>(
                r, "profileScore", CommonHive.ownProfileIdAndPic);
          }
          emit(ProfileScoreState.loaded(
            score: r,
          ));
        }));
  }

  ///fetch achievements
  Future<AchievementsDto?> getAchievements(Profile profile) async {
    return repository
        .getAchievements(profile.id.value.toString())
        .then((value) => value.fold((l) => null, (r) {
              return r;
            }));
  }

  ///check achievements and save in commonhive
  void checkOwnAchievements(Profile profile, AchievementsDto achievementsDto) {
    if (achievementsDto.eventsAttended > 5) {
      CommonHive.getAchievement('eventsAttended') ??
          CommonHive.saveAchievement('eventsAttended');
    }
    if (achievementsDto.eventsCount > 5) {
      CommonHive.getAchievement('eventsCount') != null
          ? null
          : CommonHive.saveAchievement('eventsCount');
    }
    if (achievementsDto.peopleAttendedUrEvent > 20) {
      CommonHive.getAchievement('peopleAttendedUrEvent') != null
          ? null
          : CommonHive.saveAchievement('peopleAttendedUrEvent');
    }
    if (achievementsDto.profilePicUploaded == true) {
      CommonHive.getAchievement('profilePicUploaded') != null
          ? null
          : CommonHive.saveAchievement('profilePicUploaded');
    }
  }
}
