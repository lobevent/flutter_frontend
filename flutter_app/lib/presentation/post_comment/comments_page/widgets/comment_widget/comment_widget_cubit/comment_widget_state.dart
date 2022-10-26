part of 'comment_widget_cubit.dart';

enum StatusCWS {loaded, editLoading, editSuccess, editFailure, deletionInProgress, deletionSuccess, deletionFailure}
@CopyWith()
class CommentWidgetState{
  final Comment comment;
  final StatusCWS status;
  final NetWorkFailure? failure;

  CommentWidgetState({required this.comment, required this.status, this.failure});





}