import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';

enum Operation { own, fromUser, fromComment, fromPost }

abstract class ICommentRepository {
  Future<Either<NetWorkFailure, List<Comment>>> getList(
      Operation operation, DateTime lastCommentTime, int amount,
      {Profile profile, Comment commentParent, Post postParent});
  Future<Either<NetWorkFailure, Comment>> getSingleComment(UniqueId id);
  Future<Either<NetWorkFailure, Comment>> create(Comment comment);
  Future<Either<NetWorkFailure, Comment>> update(Comment comment);
  Future<Either<NetWorkFailure, Comment>> delete(Comment comment);
}
