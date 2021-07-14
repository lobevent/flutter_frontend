part of 'comment_screen_cubit.dart';

@freezed
class CommentScreenState with _$CommentScreenState {

  factory CommentScreenState.loading() = Loading;
  factory CommentScreenState.loadedComment(Comment comment) = _LoadedComment;
  factory CommentScreenState.loadedPost(Post post) = _LoadedPost;
  factory CommentScreenState.error(String error) = _ErrorComment;
}

