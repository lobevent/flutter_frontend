import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_remote_service.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';

part 'like_cubit.freezed.dart';
part 'like_state.dart';

enum LikeTypeOption{Event, Post, Comment}

class LikeCubit extends Cubit<LikeState>{
  final UniqueId entityId;

  LikeCubit(this.entityId): super(LikeState.loading()){
    emit(LikeState.loading());
  }

  ProfileRepository repository = GetIt.I<ProfileRepository>();

  Future<void> getLikes(UniqueId objectId) async{
    try{
      //final Either<NetWorkFailure, List<Profile>>  = await repository.getList());

    }catch(e){

    }

  }

  Future<bool> like(UniqueId objectId, LikeTypeOption option)async{
    final success = repository.like(objectId, option);

    return success;
  }

}