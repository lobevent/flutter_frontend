import 'package:dartz/dartz.dart';

import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/post/post_failure.dart';
import 'package:flutter_frontend/domain/post/post.dart';

// TODO rename this one since it's duplicated in domain/event/i_event_repository.dart -> really confusing
enum Operation{
  owned,
  notOwned
}

abstract class IPostRepository{
  Future <Either<PostFailure, List<Post>>> getList(Operation operation, {Profile profile});
  Future <Either<PostFailure, Post>> getSingle(Operation operation, {Profile profile});
  Future<Either<PostFailure, Unit>> create(Post post);
  Future<Either<PostFailure, Unit>> update(Post post);
  Future<Either<PostFailure, Unit>> delete(Post post);
}