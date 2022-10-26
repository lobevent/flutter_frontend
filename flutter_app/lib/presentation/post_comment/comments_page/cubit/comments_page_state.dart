part of 'comments_page_cubit.dart';

enum StateCPS  {loading, loadingSuccessfull}
@CopyWith()
class CommentsPageState {
  final StateCPS state;
  final Either<Post, Comment>? parent;
  final Comment? comment;

  CommentsPageState({required this.state, this.parent, this.comment});
}

