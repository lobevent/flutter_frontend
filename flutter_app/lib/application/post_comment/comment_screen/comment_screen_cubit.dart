import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/i_comment_repository.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/infrastructure/post/comment_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'comment_screen_cubit.freezed.dart';
part 'comment_screen_state.dart';

class CommentScreenCubit extends Cubit<CommentScreenState> {
  final Post? post;
  final Comment? parentComment;
  final CommentRepository repository = GetIt.I<CommentRepository>();

  CommentScreenCubit({this.post, this.parentComment})
      : super(CommentScreenState.loading()) {
    emit(CommentScreenState.loading());
    loadComments();
  }

  /// the function that actually loads the comments
  loadComments() async {
    List<Comment>? comments = null;

    // the try catch is for any casting error or type exceptions in the lower regions
    try {
      // this is the case if post is set (so load comments to a post)
      if (post != null) {
        comments = commentsErrorHandler(await repository.getList(
                Operation.fromPost, DateTime.now(), 30, postParent: post))
            as List<Comment>?;
        if (comments != null) {
          emit(CommentScreenState.loadedPost(
              // copy to the post thats given and emit state
              post!.copyWith(comments: comments)));
        }
      } else {
        // this is the case if the comments are loaded from parent comment
        comments = commentsErrorHandler(await repository.getList(
            Operation.fromComment, DateTime.now(), 30,
            commentParent: parentComment)) as List<Comment>?;
        if (comments != null) {
          emit(CommentScreenState.loadedComment(
              // copy to the comment thats given and emit state
              parentComment!.copyWith(commentChildren: comments)));
        }
      }
    } catch (e) {
      emit(CommentScreenState.error(e.toString()));
    }
  }

  // an simple error handler for eithers
  dynamic commentsErrorHandler(Either<NetWorkFailure, dynamic> response) {
    return response.fold(
        (networfailure) =>
            emit(CommentScreenState.error(networfailure.toString())),
        (payload) => payload);
  }
}
