import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/PostImagePickerWidget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/post_comment_base_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/pick_image_widget.dart';
import 'package:flutter_frontend/presentation/post_comment/comments_screen/cubit/comment_screen_cubit.dart';
import 'package:flutter_frontend/presentation/post_comment/comments_screen/widgets/comment_container.dart';
import 'package:flutter_frontend/presentation/post_comment/post_screen/cubit/post_screen_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/src/provider.dart';

import '../../../../../data/common_hive.dart';
import '../../../../../domain/post/value_objects.dart';
import '../../../../post_comment/post_screen/widgets/post_widget_cubit/post_widget_cubit.dart';
import '../gen_dialog.dart';
import '../write_widget.dart';

/// this is the post widget, which should be used everywhere
class PostWidget extends StatefulWidget {
  /// the post attribute, which contains all the post data
  final Post post;
  final Event? event;
  final bool showAuthor;
  final bool showCommentAction;
  final BuildContext context;

  const PostWidget(
      {Key? key,
      required this.post,
      this.event,
      this.showAuthor = true,
      this.showCommentAction = true,
      required this.context})
      : super(key: key);

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
    return PostCommentBaseWidget(
        date: widget.post.creationDate,
        content: widget.post.postContent.getOrCrash(),
        images: widget.post.images == null ? [] : widget.post.images!,
        autor: widget.showAuthor ? widget.post.owner : null,
        actionButtonsWidgets: ActionWidgets(context));
  }

  Widget ActionWidgets(BuildContext context) {
    return PaddingRowWidget(children: [
      StdTextButton(
          onPressed: () => context.router.push(CommentsScreenRoute(post: widget.post)),
          child: Row(
            children: [
              Icon(Icons.comment),
              Text(widget.post.commentCount.toString(),
                  style: TextStyle(color: AppColors.stdTextColor))
            ],
          )),
      //delete a post
      if (CommonHive.checkIfOwnId(widget.post.owner!.id.value.toString())) ...[
        StdTextButton(
            onPressed: () {
              showPostEditOverlay(context);
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
                        {
                          if (value)
                            context.read<PostWidgetCubit>().deletePost(widget.post)
                          else
                            print("abort delete post"),
                        }
                      });
            },
            child: Icon(Icons.delete))
      ],
    ]);
  }

  /// build this Widget as overlay!
  void showPostEditOverlay(
      BuildContext
          cubitContextLocal /* this is used to access the cubit inside of the overlay*/) async {
    //initialise overlaystate and entries
    final OverlayState overlayState = Overlay.of(cubitContextLocal)!;
    //have to do it nullable
    OverlayEntry? overlayEntry;

    //this is the way to work with overlays
    overlayEntry = OverlayEntry(builder: (buildContext) {
      return DismissibleOverlay(
        overlayEntry: overlayEntry!,
        child: Scaffold(
          body: WriteWidget(
              cubitContext: cubitContextLocal,
              event: widget.event!,
              post: widget.post,
              overlayEntry: overlayEntry),
        ),
      );
    });

    //insert the entry in the state to make it accesible
    overlayState.insert(overlayEntry);
  }
}

/// generate list of posts
Widget generateUnscrollablePostContainer(
    {required List<Post> posts,
    Profile? profile,
    bool showAutor = false,
    Event? event,
    BuildContext? context}) {
  if (posts.isEmpty) {
    return Column(
      children: [
        Text("No Posts available."),
      ],
    );
  }
  return Column(
    children: [
      Container(
        // building the list of post widgets
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          // the padding is set to the std padding defined in styling widgets
          padding: stdPadding,
          scrollDirection: Axis.vertical,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return BlocProvider(
              create: (context) =>
                  PostWidgetCubit(post: posts[index]),
              child: BlocBuilder<PostWidgetCubit, PostWidgetState>(
                  builder: (context, state) {
                return state.maybeMap(
                  initial: (init) {
                    return PostWidget(
                        post: posts[index],
                        showAuthor: showAutor,
                        event: posts[index].event,
                        context: context);
                  },
                    loaded: (st) {
                      return PostWidget(
                          post: posts[index],
                          showAuthor: showAutor,
                          event: posts[index].event,
                          context: context);
                    },
                    edited: (ed) {
                      return PostWidget(
                          post: ed.post,
                          showAuthor: showAutor,
                          event: posts[index].event,
                          context: context);
                    },
                    error: (err) {
                      return Text(err.toString());
                    },
                    deleted: (del) => SizedBox.shrink(),
                    orElse: () => const Text("OrELse error in post widget"));
              }),
            );
          },
        ),
      ),
    ],
  );
}
