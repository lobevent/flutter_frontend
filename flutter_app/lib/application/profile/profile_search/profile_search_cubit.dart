import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/i_profile_repository.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/profile_failure.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_remote_service.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_remote_service.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:get_it/get_it.dart';

part 'profile_search_state.dart';
part 'profile_search_cubit.freezed.dart';

class ProfileSearchCubit extends Cubit<ProfileSearchState> {
  ProfileSearchCubit() : super(ProfileSearchState.initial());

  ProfileRepository repository = GetIt.I<ProfileRepository>();

  Future<void> searchByProfileName(String profileName) async{
    try {
      emit(ProfileSearchState.loading());
      final Either<ProfileFailure, List<Profile>> profileList = await repository.getList(Operation.search, 10, searchString: profileName);
      emit(ProfileSearchState.loaded(profiles: profileList.fold((l) => throw Exception, (r) => r)));
    } catch(e){
      emit(ProfileSearchState.error(error: e.toString()));
    }

  }

  Future<void> loadProfile(String id) async{
    repository.getSingleProfile(UniqueId.fromUniqueString(id)).then(
            (value) => value.fold(
                    (failure) => emit(ProfileSearchState.error(error: failure.toString())),
                    (profile) => profile)); //todo emit to profilepage
  }



}


