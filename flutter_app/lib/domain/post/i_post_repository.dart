import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
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
  Future<Either<NetWorkFailure, List<Post>>> getList(Operation operation,
      DateTime lastPostTime, int amount, Event eventParent,
      {Profile profile});
  Future<Either<NetWorkFailure, Post>> getSingle(UniqueId id);
  Future<Either<NetWorkFailure, Post>> create(Post post);
  Future<Either<NetWorkFailure, Post>> update(Post post);
  Future<Either<NetWorkFailure, Post>> delete(Post post);
}
