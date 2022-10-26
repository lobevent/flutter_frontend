import 'package:auto_route/auto_route.dart' hide Router;
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/post_comment_shared_widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/post_widget/post_widget_cubit/post_widget_cubit.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/post_comment_base_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/post_comment/comments_page/widgets/comment_widget/comment_widget_cubit/comment_widget_cubit.dart';
import 'package:provider/src/provider.dart';

import '../../../../../../infrastructure/core/local/common_hive/common_hive.dart';
import '../../../../../../domain/post/value_objects.dart';

/// this is the post widget, which should be used everywhere
class CommentWidget extends StatefulWidget {
  /// the post attribute, which contains all the post data
  final Comment comment;
  final bool showAuthor;
  final bool showCommentAction;

  const CommentWidget({Key? key, required this.comment, this.showAuthor = true, this.showCommentAction = true}) : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommentWidgetCubit(comment: widget.comment),
      child: BlocBuilder<CommentWidgetCubit, CommentWidgetState>(
        builder: (context, state) {
          return Visibility(
            visible: state.status != StatusPWS.deletionSuccess,
            child: Container(
              padding: stdPadding.copyWith(right: 0.0),
              child: PostCommentBaseWidget(
                  popUpItems: PopupItems(context),
                  date: state.comment.creationDate,
                  content: state.comment.commentContent.getOrEmptyString(), //widget.post.postContent.getOrEmptyString(),//
                  //images: state.post.images == null ? [] : state.post.images!,
                  autor: widget.showAuthor ? widget.comment.owner : null,
                  actionButtonsWidgets: ActionWidgets(context)),
            ),
          );
        },
      ),
    );
  }

  /// Provides List of PopUpMenuItems
  List<PopupMenuItem>? PopupItems(BuildContext context) {
    if (widget.comment.owner == null || CommonHive.checkIfOwnId(widget.comment.owner?.id.value.toString() ?? "")) {
      return PopupItemsCommentPost(context, () {showCommentEditOverlay(context);}, () { context.read<CommentWidgetCubit>().deleteComment(widget.comment);});
    }
  }

  ///Provides Row of ActionWidgets
  Widget ActionWidgets(BuildContext context) {
    return ActionWidgetsCommentPost(context, right(widget.comment));
  }



  /// build this Widget as overlay!
  void showCommentEditOverlay(BuildContext cubitContextLocal /* this is used to access the cubit inside of the overlay*/) async {
    Comment stateComment = cubitContextLocal.read<CommentWidgetCubit>().state.comment;
    showPostEditOverlayCommentPost(cubitContextLocal, stateComment.commentContent.getOrEmptyString(),
            (postContent) => stateComment.copyWith(commentContent: CommentContent(postContent)
            )
    );
  }
}
