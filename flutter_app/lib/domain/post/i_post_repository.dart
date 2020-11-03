import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';

import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/post/post_failure.dart';
import 'package:flutter_frontend/domain/post/post.dart';

// TODO rename this one since it's duplicated in domain/event/i_event_repository.dart -> really confusing
/// For dertermination of the List to load
/// for example for showing created posts or feed
enum Operation{
  own,
  feed,
  fromUser
}

abstract class IPostRepository{
  Future <Either<PostFailure, List<Post>>> getList(Operation operation, {Profile profile});
  Future <Either<PostFailure, Post>> getSingle(Id id);
  Future<Either<PostFailure, Unit>> create(Post post);
  Future<Either<PostFailure, Unit>> update(Post post);
  Future<Either<PostFailure, Unit>> delete(Post post);
}