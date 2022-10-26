part of 'comments_page_cubit.dart';

enum StatusCPS  {loading, loadingSuccessful, loadingFailure, posting, postingSuccess, postingFailure}
@CopyWith()
class CommentsPageState {
  final StatusCPS status;
  final Either<Post, Comment> entity;
  final List<Comment> children;
  final NetWorkFailure? failure;

  CommentsPageState({this.failure, required this.status, required this.entity, required this.children});
}

