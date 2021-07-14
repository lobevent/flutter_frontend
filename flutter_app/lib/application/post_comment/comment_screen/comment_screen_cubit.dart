import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'comment_screen_state.dart';
part 'comment_screen_cubit.freezed.dart';

class CommentScreenCubit extends Cubit<CommentScreenState> {
  final UniqueId? postId;
  final UniqueId? parentCommentId;

  CommentScreenCubit({this.postId, this.parentCommentId}): super(CommentScreenState.loading()){
    emit(CommentScreenState.loading());
  }


}
