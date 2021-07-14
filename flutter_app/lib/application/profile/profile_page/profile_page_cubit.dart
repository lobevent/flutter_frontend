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
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_page_state.dart';
part 'profile_page_cubit.freezed.dart';

class ProfilePageCubit extends Cubit<ProfilePageState> {
  final UniqueId profileId;

  ProfilePageCubit({required UniqueId this.profileId}) : super(ProfilePageState.loading()){

    loadProfile(profileId);
  }

  ProfileRepository repository = GetIt.I<ProfileRepository>();


  Future<void> loadProfile(UniqueId profileId) async{
    emit(ProfilePageState.loading());
    Either<NetWorkFailure, Profile> response = await repository.getSingleProfile(profileId);

    response.fold(
            (NetWorkFailure f) => emit(ProfilePageState.error(error: f.toString())),
            (Profile pro) => emit(ProfilePageState.loaded(profile: pro)));
  }




}
