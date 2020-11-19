import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/comment_failure.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';



enum Operation{
  own,
  feed,
  fromUser
}

abstract class ICommentRepository{
  Future <Either<CommentFailure, List<Comment>>> getList(Operation operation, {Profile profile});
  Future <Either<CommentFailure, Comment>> getSingleComment(Id id);
  Future<Either<CommentFailure, Comment>> create(Comment comment);
  Future<Either<CommentFailure, Comment>> update(Comment comment);
  Future<Either<CommentFailure, Comment>> delete(Comment comment);
}