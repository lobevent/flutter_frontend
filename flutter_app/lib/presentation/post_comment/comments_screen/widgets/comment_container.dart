import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/post_comment/comment_screen/comment_screen_cubit.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/post_widget.dart';

class CommentContainer extends StatelessWidget {
  const CommentContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocBuilder<CommentScreenCubit, CommentScreenState>(
      builder: (context, state){
        return Column(children: state.maybeMap(
            loadedComment: (loadedComment) => [CommentWidget(comment: loadedComment.comment), CommentList([])],
            loadedPost: (loadedPost) => [PostWidget(post: loadedPost.post), CommentList(loadedPost.post.comments?? [])],
            orElse: () => [Text("")]),);

      }
    );

    /**/
    return Container();
  }


  Widget CommentList(List<Comment> comments){
    return ListView.builder(
      itemCount: comments.length,
      itemBuilder: (context, index){
        return CommentWidget(comment: comments[index]);
      },);

  }

  Widget CommentWidget({required Comment comment}){
    return Text("test");
  }


}
