
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/i_profile_repository.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/profile_failure.dart';

class ProfileRepository extends IProfileRepository{
  @override
  Future<Either<ProfileFailure, Profile>> create(Profile profile) async{
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Either<ProfileFailure, Profile>> delete(Profile profile) async{
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Either<ProfileFailure, List<Profile>>> getList(Operation operation) async{
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future<Either<ProfileFailure, Profile>> getSingleProfile(Id id) async{
    // TODO: implement getSingleProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<ProfileFailure, Profile>> update(Profile profile) async{
    // TODO: implement update
    throw UnimplementedError();
  }

}