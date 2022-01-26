import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/repository.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions_handler.dart';

import 'comment_dtos.dart';
import 'comment_remote_service.dart';

class CommentRepository extends Repository {
  final CommentRemoteService _commentRemoteService;

  CommentRepository(this._commentRemoteService);

  // -------------------------------- Single Crud operations --------------------------------------

  ///
  /// Creates an comment in the backend or returns failure
  ///
  Future<Either<NetWorkFailure, Comment>> create(Comment comment) async {
    return localErrorHandler<Comment>(() async {
      final commentDto = CommentDto.fromDomain(comment);
      CommentDto returnedCommentDto =
          await _commentRemoteService.create(commentDto);
      return right(returnedCommentDto.toDomain());
    });
  }

  ///
  /// deletes an comment in the backend or returns failure
  ///
  Future<Either<NetWorkFailure, Comment>> delete(Comment comment) async {
    return localErrorHandler<Comment>(() async {
      final commentDto = CommentDto.fromDomain(comment);
      CommentDto returnedCommentDto =
          await _commentRemoteService.delete(commentDto);
      return right(returnedCommentDto.toDomain());
    });
  }

  ///
  /// gets an single comment in the backend or returns failure
  ///
  Future<Either<NetWorkFailure, Comment>> getSingleComment(UniqueId id) async {
    return localErrorHandler<Comment>(() async {
      final CommentDto commentDto =
          await _commentRemoteService.getSingleComment(id.value);
      final Comment comment = commentDto.toDomain();
      return right(comment);
    });
  }

  ///
  /// updates an comment in the backend or returns failure
  ///
  Future<Either<NetWorkFailure, Comment>> update(Comment comment) async {
    return localErrorHandler(() async {
      final commentDto = CommentDto.fromDomain(comment);
      CommentDto returnedComment =
          await _commentRemoteService.update(commentDto);
      return right(returnedComment.toDomain());
    });
  }

  // ------------------------------------------ Comments from list section -----------------------------------

  ///
  /// loads comment that have an parent post
  ///
  Future<Either<NetWorkFailure, List<Comment>>> getCommentsFromPost(
      {required DateTime lastCommentTime,
      required int amount,
      required Post postParent}) async {
    return localErrorHandler<List<Comment>>(() async {
      List<CommentDto> commentDtos =
          await _commentRemoteService.getCommentsFromPost(
              lastCommentTime, amount, postParent.id!.value.toString());
      return right(convertToDomainList(commentDtos));
    });
  }

  ///
  /// loads comments that have an parent comment
  ///
  Future<Either<NetWorkFailure, List<Comment>>> getCommentsFromComment({
    required DateTime lastCommentTime,
    required int amount,
    required Comment commentParent,
  }) async {
    return localErrorHandler<List<Comment>>(() async {
      List<CommentDto> commentDtos =
          await _commentRemoteService.getCommentsFromCommentParent(
              lastCommentTime, amount, commentParent.id.value.toString());
      return right(convertToDomainList(commentDtos));
    });
  }

  ///
  /// load all public user comments
  ///
  Future<Either<NetWorkFailure, List<Comment>>> getCommentsFromUser({
    required DateTime lastCommentTime,
    required int amount,
    required Profile profile,
  }) async {
    return localErrorHandler<List<Comment>>(() async {
      List<CommentDto> commentDtos =
          await _commentRemoteService.getCommentsFromUser(
              lastCommentTime, amount, profile.id.value.toString());
      return right(convertToDomainList(commentDtos));
    });
  }

  ///
  /// load all own comments
  ///
  Future<Either<NetWorkFailure, List<Comment>>> getOwnComments(
      {required DateTime lastCommentTime, required int amount}) async {
    return localErrorHandler<List<Comment>>(() async {
      List<CommentDto> commentDtos =
          await _commentRemoteService.getOwnComments(lastCommentTime, amount);
      return right(convertToDomainList(commentDtos));
    });
  }

  ///
  /// converts to domain list
  ///
  List<Comment> convertToDomainList(List<CommentDto> commentDtos) {
    return commentDtos.map((commentDtos) => commentDtos.toDomain()).toList();
  }

  ///---------------------------------------------------------------------Comment ADD/EDIT/DELETE-----------------------------------------------------
  ///
  /// adds a comment
  ///
  Future<Either<NetWorkFailure, Comment>> createComment(
      Comment comment, String postId,
      [String parentId = ""]) async {
    return localErrorHandler<Comment>(() async {
      final commentDto = CommentDto.fromDomain(comment);
      CommentDto returnedCommentDto = await _commentRemoteService.createComment(
          commentDto, postId, parentId);
      return right(returnedCommentDto.toDomain());
    });
  }

  Future<void> deletePostComment(String postOrCommentId) async {
    final answer =
        await _commentRemoteService.deletePostOrComment(postOrCommentId);
  }
}
