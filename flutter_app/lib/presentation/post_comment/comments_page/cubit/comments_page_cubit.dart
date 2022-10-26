import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/post/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../../infrastructure/post/comment_repository.dart';

part 'comments_page_state.dart';
part 'comments_page_cubit.g.dart';

class CommentsPageCubit extends Cubit<CommentsPageState> {
  final CommentRepository repository = GetIt.I<CommentRepository>();
  late UniqueId id;


  CommentsPageCubit({required Either<Post, Comment> entity}) : super(
      CommentsPageState(status: StatusCPS.loading, entity: entity, children: [])) {
    id = entity.fold((l) => l.id!, (r) => r.id);
    loadChildren();
  }

  ///
  /// loads children of the entity, whether from the backend or directly from the entity
  ///
  Future<void> loadChildren()async{
    if(state.entity.fold((l) => l.comments?.isEmpty??true, (r) => r.commentChildren?.isEmpty??true)){
      state.entity.fold((post){
        repository.getCommentsFromPost(lastCommentTime: DateTime.now(), amount: 30, postParent: post).then(
                (value) => _emitFailureOrChildren(value));
      }, (comment){
        repository.getCommentsFromComment(lastCommentTime: DateTime.now(), amount: 30, commentParent: comment).then(
                (value) => _emitFailureOrChildren(value));
      });
    }
    else{
      state.entity.fold(
              (l) => emit(state.copyWith(status: StatusCPS.loadingSuccessful, children: l.comments)),
              (r) => emit(state.copyWith(status: StatusCPS.loadingSuccessful, children: r.commentChildren)));
    }
  }


  ///
  /// generates new [Comment], sends it to backend, and updates ui
  ///
  postComment(String content){
    emit(state.copyWith(status: StatusCPS.posting));
    Comment comment = Comment(
      id: UniqueId(),
      creationDate: DateTime.now(),
      owner: Profile(id: UniqueId(), name: ProfileName("fake")),
      post: Post.createDummyPost(),
      //decide if parent has comment or only post
      commentContent: CommentContent(content),
    );
    repository.createComment(comment, id).then((value) => value.fold(
            (l) => emit(state.copyWith(status: StatusCPS.postingFailure, failure: l)),
            (r) => emit(state.copyWith(
                status: StatusCPS.postingSuccess,
                entity: _entityAddChildCount(1),
                children: state.children.toList()..add(r)
            )
            )
    ));
  }

  ///
  /// adds [count] to either comment or post comment child property
  ///
  Either<Post, Comment> _entityAddChildCount(int count){
    return state.entity.fold(
            (l) => left(l.copyWith(commentCount: (l.commentCount??0) + count)),
            (r) => right(r.copyWith(childCount: (r.childCount??0) + count)));
  }

  /// folds the either with [List] children or [NetWorkFailure]
  /// and emits respective state
  _emitFailureOrChildren(Either<NetWorkFailure, List<Comment>> either){
    either.fold(
        (l) => emit(state.copyWith(status: StatusCPS.loadingFailure)),
        (r) => emit(state.copyWith(status: StatusCPS.loadingSuccessful, children: r)));
  }
}
