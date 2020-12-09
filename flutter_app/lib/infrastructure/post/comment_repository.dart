import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/domain/post/i_comment_repository.dart';
import 'package:flutter_frontend/domain/post/comment_failure.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'comment_dtos.dart';
import 'comment_remote_service.dart';

class CommentRepository implements ICommentRepository {
  final CommentRemoteService _commentRemoteService;

  CommentRepository(this._commentRemoteService);

  @override
  Future<Either<CommentFailure, Comment>> create(Comment comment) async {
    try {
      final commentDto = CommentDto.fromDomain(comment);
      CommentDto returnedCommentDto =
          await _commentRemoteService.create(commentDto);
      return right(returnedCommentDto.toDomain());
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<CommentFailure, Comment>> delete(Comment comment) async {
    try {
      final commentDto = CommentDto.fromDomain(comment);
      CommentDto returnedCommentDto =
          await _commentRemoteService.delete(commentDto);
      return right(returnedCommentDto.toDomain());
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<CommentFailure, List<Comment>>> getList(Operation operation, DateTime lastCommentTime, int amount, {Profile profile, Comment commentParent, Post postParent}) async {
    try {
      List<CommentDto> commentDtos;
      switch (operation) {
        case Operation.fromPost:
          commentDtos = await _commentRemoteService.getCommentsFromPost(lastCommentTime, amount, postParent
              .maybeMap(
                  (value) => value.id.getOrCrash().toString(), //need to be done, as post parent has classes where the id is not included
              orElse: throw UnexpectedFormatException()));
          break;
        case Operation.fromComment:
          commentDtos = await _commentRemoteService.getCommentsFromCommentParent(lastCommentTime, amount, commentParent
              .maybeMap(
                  (value) => value.id.getOrCrash().toString(),
              parent: (value) => value.id.getOrCrash().toString(),
              orElse: throw UnexpectedFormatException()));
          break;
        case Operation.fromUser:
          commentDtos = await _commentRemoteService.getCommentsFromUser(lastCommentTime, amount, profile.id.getOrCrash().toString());
          break;
        case Operation.own:
          commentDtos = await _commentRemoteService.getOwnComments(lastCommentTime, amount);
          break;
      }
      //convert the dto objects to domain Objects
      final List<Comment> comments =
      commentDtos.map((commentDtos) => commentDtos.toDomain()).toList();
      return right(comments);
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<CommentFailure, Comment>> getSingleComment(Id id) async {
    try {
      final CommentDto commentDto =
      await _commentRemoteService.getSingleComment(id.getOrCrash());
      final Comment comment = commentDto.toDomain();
      return right(comment);
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<CommentFailure, Comment>> update(Comment comment) async {
    try {
      final commentDto = CommentDto.fromDomain(comment);
      CommentDto returnedComment = await _commentRemoteService.update(commentDto);
      return right(returnedComment.toDomain());
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  CommentFailure _reactOnCommunicationException(CommunicationException e) {
    switch (e.runtimeType) {
      case NotFoundException:
        return const CommentFailure.notFound();
        break;
      case InternalServerException:
        return const CommentFailure.internalServer();
        break;
      case NotAuthenticatedException:
        return const CommentFailure.notAuthenticated();
        break;
      case NotAuthorizedException:
        return const CommentFailure.insufficientPermissions();
        break;
      case UnexpectedFormatException:
        return const CommentFailure.unexpected();
      default:
        return const CommentFailure.unexpected();
        break;
    }
  }
}
