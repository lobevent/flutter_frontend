import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/post_comment_base_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/post_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/post_comment/comments_screen/cubit/comment_screen_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class CommentContainer extends StatelessWidget {
  const CommentContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentScreenCubit, CommentScreenState>(
        builder: (context, state) {
      return Column(
        children: state.maybeMap(
            //Display post-/coment widget at the top and than a comment list with padded Comments
            loadedComment: (loadedComment) => [
                  CommentWidget(
                      comment: loadedComment.comment, context: context),
                  CommentList(
                      loadedComment.comment.commentChildren ?? [], context)
                ],
            loadedPost: (loadedPost) => [
                  PostWidget(post: loadedPost.post),
                  CommentList(loadedPost.post.comments ?? [], context)
                ],
            orElse: () => [Text("")]),
      );
    });

    /**/
    return Container();
  }

  /// generates the list with the comments
  /// this is not scrollable
  Widget CommentList(List<Comment> comments, BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: comments.length,
      itemBuilder: (context, index) {
        return CommentWidget(comment: comments[index], context: context);
      },
    );
  }

  /// comment widget is the main widget to display comments
  /// as long as it only is used here, it will not be exportet
  Widget CommentWidget(
      {required Comment comment, required BuildContext context}) {
    return Container(
      child: PostCommentBaseWidget(
        date: comment.creationDate,
        content: comment.commentContent.getOrCrash(),
        actionButtonsWidgets: ActionWidgets(context, comment),
        autor: comment.owner,
      ),
      padding: stdPadding.copyWith(right: 0.0),
    );
  }

  /// generate the widget with the action buttons (like load children etc.)
  Widget ActionWidgets(BuildContext context, Comment comment) {
    return PaddingRowWidget(
      children: [
        StdTextButton(
            onPressed: () => context.router
                .push(CommentsScreenRoute(parentComment: comment)),
            child: Row(
              children: [
                Icon(Icons.comment),
                Text(comment.childCount.toString(),
                    style: TextStyle(color: AppColors.stdTextColor))
              ],
            ))
      ],
    );
  }
}
