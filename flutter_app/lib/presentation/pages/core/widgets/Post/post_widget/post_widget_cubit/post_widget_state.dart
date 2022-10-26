part of 'post_widget_cubit.dart';

enum StatusPWS {loaded, editLoading, editSuccess, editFailure, deletionInProgress, deletionSuccess, deletionFailure}
@CopyWith()
class PostWidgetState{
  final Post post;
  final StatusPWS status;
  final NetWorkFailure? failure;

  PostWidgetState({required this.post, required this.status, this.failure});





}