import 'dart:convert';

import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/gen_dialog.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/post_comment_base_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/post_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/post_comment/comments_screen/cubit/comment_screen_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:get_it/get_it.dart';

import '../../../../infrastructure/core/local/common_hive/common_hive.dart';

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
                  WriteWidget(context, loadedComment.comment.post,
                      loadedComment.comment),
                ],
            loadedPost: (loadedPost) => [
                  PostWidget(post: loadedPost.post, context: context),
                  CommentList(loadedPost.post.comments ?? [], context),
                  WriteWidget(context, loadedPost.post),
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

  Widget PositionedFloatingButton() {
    return Positioned(
      right: 20,
      bottom: 20,
      child: Align(
        alignment: Alignment.bottomRight,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.green,
          child: const Icon(Icons.navigation),
        ),
      ),
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

  Widget WriteWidget(
    BuildContext context,
    Post? loadedPost, [
    Comment? parentComment,
    OverlayEntry? overlay,
  ]) {
    TextEditingController postWidgetController = TextEditingController();
    return Container(
        width: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            gradient: const LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.white12,
                Colors.white70,
              ],
            )),
        child: Title(
          title: "Post a comment.",
          color: Colors.black,
          child: Column(
            children: [
              FullWidthPaddingInput(
                password: false,
                maxLines: 6,
                controller: postWidgetController,
              ),
              TextWithIconButton(
                  onPressed: () {
                    parentComment == null
                        ? context
                            .read<CommentScreenCubit>()
                            .postComment(postWidgetController.text, loadedPost!)
                        : context.read<CommentScreenCubit>().postComment(
                            postWidgetController.text,
                            loadedPost!,
                            parentComment);
                  },
                  text: "Post"),
            ],
          ),
        ));
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
            )),
        //delete an comment button
        //check if its the own comment to display delete button
        if (CommonHive.checkIfOwnId(comment.owner.id.value.toString())) ...[
          StdTextButton(
              onPressed: () {
                showCommentEditOverlay(context, comment);
              },
              child: Icon(Icons.edit)),
          StdTextButton(
              onPressed: () {
                GenDialog.genericDialog(
                        context,
                        AppStrings.deleteCommentDialogAbort,
                        AppStrings.deleteCommentDialogText,
                        AppStrings.deleteCommentDialogConfirm,
                        AppStrings.deleteCommentDialogAbort)
                    .then((value) async => {
                          if (value)
                            context
                                .read<CommentScreenCubit>()
                                .deleteComment(comment)
                          else
                            print("abort delete Comment"),
                        });
              },
              child: Icon(Icons.delete))
        ],
      ],
    );
  }

  /// build this Widget as overlay!
  void showCommentEditOverlay(
      BuildContext
          cubitContextLocal /* this is used to access the cubit inside of the overlay*/,
      Comment comment) async {
    //initialise overlaystate and entries
    final OverlayState overlayState = Overlay.of(cubitContextLocal)!;
    //have to do it nullable
    OverlayEntry? overlayEntry;

    //this is the way to work with overlays
    overlayEntry = OverlayEntry(builder: (buildContext) {
      return DismissibleOverlay(
        overlayEntry: overlayEntry!,
        child: Scaffold(
            body: WriteWidget(cubitContextLocal, null, comment, overlayEntry)
            //WriteWidget(context: cubitContextLocal, event: event!, post: post, overlayEntry: overlayEntry),
            ),
      );
    });

    //insert the entry in the state to make it accesible
    overlayState.insert(overlayEntry);
  }
}
