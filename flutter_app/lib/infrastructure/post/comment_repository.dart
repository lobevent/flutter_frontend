import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/i_comment_repository.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions_handler.dart';

import 'comment_dtos.dart';
import 'comment_remote_service.dart';

class CommentRepository implements ICommentRepository {
  final CommentRemoteService _commentRemoteService;

  CommentRepository(this._commentRemoteService);

  @override
  Future<Either<NetWorkFailure, Comment>> create(Comment comment) async {
    try {
      final commentDto = CommentDto.fromDomain(comment);
      CommentDto returnedCommentDto =
          await _commentRemoteService.create(commentDto);
      return right(returnedCommentDto.toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, Comment>> delete(Comment comment) async {
    try {
      final commentDto = CommentDto.fromDomain(comment);
      CommentDto returnedCommentDto =
          await _commentRemoteService.delete(commentDto);
      return right(returnedCommentDto.toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, List<Comment>>> getList(
      Operation operation, DateTime lastCommentTime, int amount,
      {Profile? profile, Comment? commentParent, Post? postParent}) async {
    try {
      List<CommentDto> commentDtos;
      switch (operation) {
        case Operation.fromPost:
          if (postParent == null || postParent.id == null) {
            throw UnexpectedTypeError();
          }
          commentDtos = await _commentRemoteService.getCommentsFromPost(
              lastCommentTime, amount, postParent.id!.value.toString());
          break;
        case Operation.fromComment:
          if (commentParent == null || commentParent.id == null) {
            throw UnexpectedTypeError();
          }
          commentDtos =
              await _commentRemoteService.getCommentsFromCommentParent(
                  lastCommentTime,
                  amount,
                  commentParent.id.value.toString());
          break;
        case Operation.fromUser:
          if (profile == null) {
            throw UnexpectedTypeError();
          }
          commentDtos = await _commentRemoteService.getCommentsFromUser(
              lastCommentTime, amount, profile.id.value.toString());
          break;
        case Operation.own:
          commentDtos = await _commentRemoteService.getOwnComments(
              lastCommentTime, amount);
          break;
      }
      //convert the dto objects to domain Objects
      final List<Comment> comments =
          commentDtos.map((commentDtos) => commentDtos.toDomain()).toList();
      return right(comments);
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, Comment>> getSingleComment(UniqueId id) async {
    try {
      final CommentDto commentDto =
          await _commentRemoteService.getSingleComment(id.value);
      final Comment comment = commentDto.toDomain();
      return right(comment);
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, Comment>> update(Comment comment) async {
    try {
      final commentDto = CommentDto.fromDomain(comment);
      CommentDto returnedComment =
          await _commentRemoteService.update(commentDto);
      return right(returnedComment.toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }
}
