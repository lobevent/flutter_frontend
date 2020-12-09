import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';

import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/post/post_failure.dart';
import 'package:flutter_frontend/domain/post/post.dart';

// TODO rename this one since it's duplicated in domain/event/i_event_repository.dart -> really confusing
/// For dertermination of the List to load
/// for example for showing created posts or feed
enum Operation { own, feed, fromUser }

abstract class IPostRepository {
  Future<Either<PostFailure, List<Post>>> getList(Operation operation,
      DateTime lastCommentTime, int amount, Event eventParent,
      {Profile profile});
  Future<Either<PostFailure, Post>> getSingle(Id id);
  Future<Either<PostFailure, Post>> create(Post post);
  Future<Either<PostFailure, Post>> update(Post post);
  Future<Either<PostFailure, Post>> delete(Post post);
}
