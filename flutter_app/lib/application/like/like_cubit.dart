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

//for the different entities
enum LikeTypeOption{Event, Post, Comment}

class LikeCubit extends Cubit<LikeState>{
  final UniqueId entityId;
  bool? likeStatus = false;

  LikeCubit(this.entityId): super(LikeState.loading()){
    emit(LikeState.loading());
    getOwnLikeStatus(entityId);
  }

  ProfileRepository repository = GetIt.I<ProfileRepository>();

  ///!= return the profiles which have liked the entity (+ the count)
  Future<void> getLikes(UniqueId objectId) async{
    try{
      //final Either<NetWorkFailure, List<Profile>>  = await repository.getList());

    }catch(e){

    }

  }

  ///just like 1 entity and pass option to handle different route in remote service
  Future<bool> like(UniqueId objectId, LikeTypeOption option)async{
    final success = repository.like(objectId, option);

    return success;
  }

  ///just unlike 1 entity and pass option to handle different route in remote service
  Future<bool> unlike(UniqueId objectId, LikeTypeOption option)async{
    final success = repository.unlike(objectId, option);

    return success;
  }

  ///return own like status to show indicator for like
  Future<bool> getOwnLikeStatus(UniqueId objectId) async{
    final success = repository.checkLikeStatus(objectId);

    this.likeStatus= await success;
    return success;


  }

}