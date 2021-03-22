import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/profile_failure.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_remote_service.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_page_state.dart';
part 'profile_page_cubit.freezed.dart';

class ProfilePageCubit extends Cubit<ProfilePageState> {
  ProfilePageCubit() : super(ProfilePageState.initial()){
  emit(ProfilePageState.initial());}

  ProfileRepository repository = ProfileRepository(ProfileRemoteService());


}
