import 'package:flutter/material.dart';

class CommentContainer extends StatelessWidget {
  const CommentContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*error: (errState) =>[ErrorMessage(errorText: errState.error)],
    loadedComment: (loadedComment) => [CommentContainer(context, null, loadedComment.comment)],
    loadedPost: (loadedPost) => [CommentContainer(context, loadedPost.post, null)],
    orElse: () => [CommentContainer(context, null, null)]*/
    return Container();
  }
}
