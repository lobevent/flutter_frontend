import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/material.dart';
import 'package:flutter_frontend/data/storage_shared.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/PostImagePickerWidget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/post_comment_base_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_form/widgets/pick_image_widget.dart';
import 'package:flutter_frontend/presentation/post_comment/comments_screen/cubit/comment_screen_cubit.dart';
import 'package:flutter_frontend/presentation/post_comment/comments_screen/widgets/comment_container.dart';
import 'package:flutter_frontend/presentation/post_comment/post_screen/cubit/post_screen_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/src/provider.dart';

import '../gen_dialog.dart';

/// this is the post widget, which should be used everywhere
class PostWidget extends StatelessWidget {
  /// the post attribute, which contains all the post data
  final Post post;
  final Event? event;
  final bool showAuthor;
  final bool showCommentAction;
  const PostWidget(
      {Key? key,
      required this.post,
      this.event,
      this.showAuthor = true,
      this.showCommentAction = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PostCommentBaseWidget(
        date: post.creationDate,
        content: post.postContent.getOrCrash(),
        images: post.images == null ? [] : post.images!,
        autor: showAuthor ? post.owner : null,
        actionButtonsWidgets: ActionWidgets(context));
  }

  Widget ActionWidgets(BuildContext context) {
    return PaddingRowWidget(
      children: [
        StdTextButton(
            onPressed: () =>
                context.router.push(CommentsScreenRoute(post: post)),
            child: Row(
              children: [
                Icon(Icons.comment),
                Text(post.commentCount.toString(),
                    style: TextStyle(color: AppColors.stdTextColor))
              ],
            )),
        //delete a post
        if(GetIt.I<StorageShared>().checkIfOwnId(post.owner!.id.value.toString()))...[
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
                    context.read<PostScreenCubit>().deletePost(post)
                  else
                    print("abort delete post"),
                });
              },
              child: Icon(Icons.delete))
      ],
    ]
    );
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
       if(event!=null&&context!=null) WriteWidget(context, event)

      ],
    );

    //return Text("Nothing here yet");
  }
  // Expanded because if you leave it, it expands infinitely and throws errors
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
            return PostWidget(
                post: profile != null
                    ? posts[index].copyWith(owner: profile)
                    : posts[index],
                showAuthor: showAutor,
                event: event);
          },
        ),
        //WriteWidget(context!, event!)
      ),
      //check if we need to build it or if we are on the feedscreen
      if (event != null && context != null)
        WriteWidget(context, event)
      else
        Text("")
    ],
  );
}

Widget WriteWidget(BuildContext context, Event event) {
  TextEditingController postWidgetController = TextEditingController();
  return Container(
    decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent)
      ),
      width: 300,
      child: Title(
        title: "Post something.",
        color: Colors.black,
        child: Column(
          children: [
            FullWidthPaddingInput(
              password: false,
              maxLines: 6,
              controller: postWidgetController,
            ),
            PostImagePickerWidget(),
            TextWithIconButton(
                onPressed: () {
                  context.read<PostScreenCubit>().postPost(
                      postWidgetController.text, event.id.value.toString());
                },
                text: "Post")
          ],
        ),
      ));
}
