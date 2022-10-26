import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/post/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/post/comment_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'comment_screen_cubit.freezed.dart';
part 'comment_screen_state.dart';

@Deprecated("new is CommentPageCubit, but dont use them either outside")
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
        comments = commentsErrorHandler(await repository.getCommentsFromPost(
            lastCommentTime: DateTime.now(),
            amount: 30,
            postParent: post!)) as List<Comment>?;
        if (comments != null) {
          // copy to the post thats given and emit state
          emit(CommentScreenState.loadedPost(
              post!.copyWith(comments: comments)));
        }
      } else {
        // this is the case if the comments are loaded from parent comment
        comments = commentsErrorHandler(await repository.getCommentsFromComment(
            lastCommentTime: DateTime.now(),
            amount: 30,
            commentParent: parentComment!)) as List<Comment>?;

        if (comments != null) {
          emit(CommentScreenState.loadedComment(
              //maybe bullshit
              parentComment!.post,
              // copy to the comment thats given and emit state
              parentComment!.copyWith(commentChildren: comments)));
        }
      }
    } catch (e) {
      emit(CommentScreenState.error(e.toString()));
    }
  }

  ///post a comment and add the comment to our loadpost state so we can reload and see the new comment
  Future<void> postComment(String commentDesc, Post loadedPost,
      [Comment? parentComment = null]) async {
    Comment comment = Comment(
      id: UniqueId(),
      creationDate: DateTime.now(),
      owner: Profile(id: UniqueId(), name: ProfileName("fake")),
      post: loadedPost,
      //decide if parent has comment or only post
      commentParent: parentComment != null ? parentComment : null,
      commentContent: CommentContent(commentDesc),
    );
    await state.maybeMap(
        //decision for loaded post
        loadedPost: (value) async {
          //emit "reloading"
          emit(CommentScreenState.loading());
          //access repo
          //wait repository
          //   .createComment(comment, loadedPost.id!.value.toString())
          //   .then((commentOrFailure) => commentOrFailure.fold(
          //           (failure) =>
          //               emit(CommentScreenState.error(failure.toString())),
          //           (comment) {
          //         //doesnt work yet, increment the childcount so it displays
          //             List<Comment>postCommentsAdded= [...value.post.comments!, comment];
          //         value.post.commentCount != null
          //             ? value.post.commentCount! + 1
          //             : value.post.commentCount == 1;
          //         //emit the loaded post, so we see our added comment
          //         emit(CommentScreenState.loadedPost(loadedPost));
          //       }));
        },
        loadedComment: (commentLoaded) async {
          //emit loading
          emit(CommentScreenState.loading());
          //call the backend
          //wait repository
          //   .createComment(comment, loadedPost.id!.value.toString(),
          //       commentLoaded.comment.id.value.toString())
          //   .then((commentOrFailure) => commentOrFailure.fold(
          //           (failure) =>
          //               emit(CommentScreenState.error(failure.toString())),
          //           (comment) {
          //         commentLoaded.comment.commentChildren!.add(comment);
          //         //emit out new state so we see our generated comment
          //         //emit(CommentScreenState.loadedComment(
          //         //    commentLoaded.post, parentComment!));
          //       }));
        },
        orElse: () => throw LogicError());
  }

  Future<void> deleteComment(Comment comment) async {
    final answer = await repository
        .deletePostComment(comment.id.value.toString())
        .then((value) {
      //emit loading to emit updated commentlist
      emit(CommentScreenState.loading());
      /*if (comment.post.comments!.isNotEmpty) {
        emit(CommentScreenState.loadedComment(
            comment.post, comment.post.comments![0]));
      } else {

       */
      emit(CommentScreenState.loadedPost(comment.post));
      //}
    });
  }

  // an simple error handler for eithers
  dynamic commentsErrorHandler(Either<NetWorkFailure, dynamic> response) {
    return response.fold(
        (networfailure) =>
            emit(CommentScreenState.error(networfailure.toString())),
        (payload) => payload);
  }
}
