import 'dart:convert';

import 'package:auto_route/auto_route.dart' hide Router;
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/post_comment_shared_widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/write_widget/write_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/gen_dialog.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/post_comment_base_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/post_widget/post_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/post_comment/comments_screen/cubit/comment_screen_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:get_it/get_it.dart';

import '../../../../infrastructure/core/local/common_hive/common_hive.dart';

@Deprecated("new is CommentPage")
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
                      loadedComment.comment.commentChildren ?? [], context),



                  WriteWidget(postContent: loadedComment.comment.commentContent.getOrEmptyString(), onSubmit:  (content) {
                    if(loadedComment.comment.commentParent == null) {
                      context.read<CommentScreenCubit>().postComment(content, loadedComment.comment.post);
                    }else {
                      context.read<CommentScreenCubit>().postComment(content, loadedComment.post, loadedComment.comment.commentParent);
                    }
                    },),

                ],
            loadedPost: (loadedPost) => [
                  PostWidget(post: loadedPost.post),
                  CommentList(loadedPost.post.comments ?? [], context),
                  WriteWidget(onSubmit: (content) => context.read<CommentScreenCubit>().postComment(content, loadedPost.post),),
                ],
            orElse: () => [Text("")]),
      );
    });
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
      padding: stdPadding.copyWith(right: 0.0),
      child: PostCommentBaseWidget(
        date: comment.creationDate,
        content: comment.commentContent.getOrCrash(),
        actionButtonsWidgets: ActionWidgets(context, comment),
        autor: comment.owner,
      ),
    );
  }


  /// generate the widget with the action buttons (like load children etc.)
  Widget ActionWidgets(BuildContext context, Comment comment) {
    return ActionWidgetsCommentPost(context, right(comment));
  }

  /// build this Widget as overlay!
  void showCommentEditOverlay(
      BuildContext context/* this is used to access the cubit inside of the overlay*/,
      Comment comment) async {
    //showPostEditOverlayCommentPost(context, comment.commentContent.getOrEmptyString(), (p0) => context.read<CommentScreenCubit>().postComment(commentDesc, loadedPost))
  }
}
