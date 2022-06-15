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

import '../../../../../domain/post/value_objects.dart';
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
    return PaddingRowWidget(children: [
      StdTextButton(
          onPressed: () => context.router.push(CommentsScreenRoute(post: post)),
          child: Row(
            children: [
              Icon(Icons.comment),
              Text(post.commentCount.toString(),
                  style: TextStyle(color: AppColors.stdTextColor))
            ],
          )),
      //delete a post
      if (GetIt.I<StorageShared>()
          .checkIfOwnId(post.owner!.id.value.toString())) ...[
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
                        if (value)
                          context.read<PostScreenCubit>().deletePost(post)
                        else
                          print("abort delete post"),
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
          body: WriteWidget(cubitContext: cubitContextLocal, event: event!, post: post),
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
        if (event != null && context != null) WriteWidget(cubitContext: context, event: event)
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
        WriteWidget(cubitContext: context, event: event)
      else
        Text("")
    ],
  );
}









//------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------Write Widget    Todo: export to own file
//------------------------------------------------------------------------------------------------------------------------

class WriteWidget extends StatefulWidget{
  final Event event;
  final Post? post;
  final BuildContext cubitContext;
  WriteWidget({
    Key? key,
    required this.cubitContext,
    required this.event,
    this.post
  }): super(key: key);

  @override
  State<WriteWidget> createState() => _WriteWidgetState();
}

class _WriteWidgetState extends State<WriteWidget> {
  late TextEditingController postWidgetController;

  @override
  void initState(){
    super.initState();
    if(this.widget.post != null){
      postWidgetController = TextEditingController(text: widget.post!.postContent.getOrEmptyString());
    }
    else {
      postWidgetController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
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
              if (widget.post == null) PostImagePickerWidget() else Text(""),
              TextWithIconButton(
                  onPressed: () {
                    widget.post == null
                        ? widget.cubitContext.read<PostScreenCubit>().postPost(
                        postWidgetController.text, widget.event.id.value.toString())
                        : widget.cubitContext.read<PostScreenCubit>().editPost(
                        widget.post!.copyWith(
                            postContent:
                            PostContent(postWidgetController.text)));
                  },
                  text: "Post")
            ],
          ),
        ));
  }
}
// Widget WriteWidget(BuildContext cubitContext, Event event, {Post? post}) {
//   TextEditingController postWidgetController = TextEditingController();
//   if(post != null){
//     postWidgetController.text = post.postContent.getOrEmptyString();
//   }
//   // post!=null? post.postContent.value
//   //    .fold((l) => l.toString(), (postContent) => postContent.toString())
//
//   return Container(
//       decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
//       width: 300,
//       child: Title(
//         title: "Post something.",
//         color: Colors.black,
//         child: Column(
//           children: [
//             FullWidthPaddingInput(
//               password: false,
//               maxLines: 6,
//               controller: postWidgetController,
//             ),
//             if (post == null) PostImagePickerWidget() else Text(""),
//             TextWithIconButton(
//                 onPressed: () {
//                   post == null
//                       ? cubitContext.read<PostScreenCubit>().postPost(
//                           postWidgetController.text, event.id.value.toString())
//                       : cubitContext.read<PostScreenCubit>().editPost(
//                           post.copyWith(
//                               postContent:
//                                   PostContent(postWidgetController.text)));
//                 },
//                 text: "Post")
//           ],
//         ),
//       ));
// }
