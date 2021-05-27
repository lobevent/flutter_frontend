
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:flutter_frontend/domain/profile/i_profile_repository.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_remote_service.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_remote_service.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:flutter_frontend/domain/profile/profile_failure.dart';

part 'profile_search_state.dart';
part 'profile_search_cubit.freezed.dart';

class ProfileSearchCubit extends Cubit<ProfileSearchState> {
  ProfileSearchCubit() : super(ProfileSearchState.initial());

  ProfileRepository repository = ProfileRepository(ProfileRemoteService());

  Future<void> searchByProfileName(String profileName) async {
    try {
      emit(ProfileSearchState.loading(profileName: profileName));
      final Either<ProfileFailure, List<Profile>> profiles =
          await repository.getList(Operation.search, 30);
    } catch (e) {
      emit(ProfileSearchState.error(error: e.toString()));
    }
  }
}
