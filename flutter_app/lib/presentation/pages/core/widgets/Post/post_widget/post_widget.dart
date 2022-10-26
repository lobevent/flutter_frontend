import 'package:auto_route/auto_route.dart' hide Router;
import 'package:dartz/dartz.dart' hide State;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/post_comment_shared_widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/write_widget/write_widget_post_image_picker.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/post_widget/post_widget_cubit/post_widget_cubit.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/post_comment_base_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/pick_image_widget.dart';
import 'package:flutter_frontend/presentation/post_comment/comments_screen/cubit/comment_screen_cubit.dart';
import 'package:flutter_frontend/presentation/post_comment/comments_screen/widgets/comment_container.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/src/provider.dart';

import '../../../../../../infrastructure/core/local/common_hive/common_hive.dart';
import '../../../../../../domain/post/value_objects.dart';
import '../../gen_dialog.dart';
import '../write_widget/write_widget.dart';

/// this is the post widget, which should be used everywhere
class PostWidget extends StatefulWidget {
  /// the post attribute, which contains all the post data
  final Post post;
  final Event? event;
  final bool showAuthor;
  final bool showCommentAction;

  const PostWidget({Key? key, required this.post, this.event, this.showAuthor = true, this.showCommentAction = true}) : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostWidgetCubit(post: widget.post),
      child: BlocBuilder<PostWidgetCubit, PostWidgetState>(
        builder: (context, state) {
          return Visibility(
            visible: state.status != StatusPWS.deletionSuccess,
            child: PostCommentBaseWidget(
                popUpItems: PopupItems(context),
                date: state.post.creationDate,
                content: state.post.postContent.getOrEmptyString(), //widget.post.postContent.getOrEmptyString(),//
                images: state.post.images == null ? [] : state.post.images!,
                autor: widget.showAuthor ? widget.post.owner : null,
                actionButtonsWidgets: ActionWidgets(context)),
          );
        },
      ),
    );
  }

  List<PopupMenuItem>? PopupItems(BuildContext context) {
    if (widget.post.owner == null || CommonHive.checkIfOwnId(widget.post.owner?.id.value.toString() ?? "")) {
      return PopupItemsCommentPost(context, () {showPostEditOverlay(context);}, () { context.read<PostWidgetCubit>().deletePost(widget.post);});
    }
  }

  Widget ActionWidgets(BuildContext context) {
    return ActionWidgetsCommentPost(context, left(widget.post));
  }



  /// build this Widget as overlay!
  void showPostEditOverlay(BuildContext cubitContextLocal /* this is used to access the cubit inside of the overlay*/) async {
    showPostEditOverlayCommentPost(cubitContextLocal, widget.post.postContent.getOrEmptyString(),
            (postContent) => cubitContextLocal.read<PostWidgetCubit>().editPost(widget.post.copyWith(postContent: PostContent(postContent))));
  }
}
