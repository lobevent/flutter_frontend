import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/comment_failure.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';

enum Operation { own, fromUser, fromComment, fromPost }

abstract class ICommentRepository {
  Future<Either<CommentFailure, List<Comment>>> getList(
      Operation operation, DateTime lastCommentTime, int amount,
      {Profile profile, Comment commentParent, Post postParent});
  Future<Either<CommentFailure, Comment>> getSingleComment(UniqueId id);
  Future<Either<CommentFailure, Comment>> create(Comment comment);
  Future<Either<CommentFailure, Comment>> update(Comment comment);
  Future<Either<CommentFailure, Comment>> delete(Comment comment);
}
