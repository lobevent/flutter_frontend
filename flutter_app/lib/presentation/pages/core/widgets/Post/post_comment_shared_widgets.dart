import 'package:auto_route/auto_route.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/l10n/app_strings.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/write_widget/write_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/gen_dialog.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/stylings/dismissible_overlay.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart' hide Router;

List<PopupMenuItem>? PopupItemsCommentPost(BuildContext context, VoidCallback onEdit, VoidCallback onDelete) {
    return [
      PopupMenuItem(
        onTap: () {
          onEdit();
        },
        child: Row(
          children: [Icon(Icons.edit), Text(AppStrings.edit)],
        ),
      ),
      PopupMenuItem(
        onTap: () {
          // Future delayed is used here, so the dialog is not instantly closed
          Future.delayed(
              const Duration(seconds: 0),
                  () => GenDialog.genericDialog(context, AppStrings.deleteCommentDialogAbort, AppStrings.deleteCommentDialogText,
                  AppStrings.deleteCommentDialogConfirm, AppStrings.deleteCommentDialogAbort)
                  .then((value) async => {
                {
                  if (value) onDelete() else print("abort delete post"),
                }
              }));
        },
        child: Row(
          children: [Icon(Icons.delete), Text(AppStrings.delete)],
        ),
      )
    ];
}



Widget ActionWidgetsCommentPost(BuildContext context, Either<Post, Comment> comment_or_post) {
  return Row(
    //mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        flatButton(
          onPressed: () => context.router.push(comment_or_post.fold((l) => CommentsScreenRoute(post: l), (r) => CommentsScreenRoute(parentComment: r))),
          icon: Row(
            children: [Icon(Icons.comment), Text(comment_or_post.fold((l) => l.commentCount.toString(), (r) => r.childCount.toString()),
                style: TextStyle(color: AppColors.stdTextColor))],
          ),
        ),
      ]);
}

Widget flatButton({required Widget icon, required VoidCallback onPressed}) {
  return Expanded(
      child: Container(
        height: 40,
        decoration: BoxDecoration(border: Border.all(width: 0.5, color: AppColors.darkGrey)),
        child: MaterialButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          child: FittedBox(child: icon),
        ),
      ));
}


/// build this Widget as overlay!
void showPostEditOverlayCommentPost(BuildContext context, String content, Function(String) onSubmit) async {
  //initialise overlaystate and entries
  final OverlayState overlayState = Overlay.of(context)!;
  //have to do it nullable

  OverlayEntry? overlayEntry;

  //this is the way to work with overlays
  overlayEntry = OverlayEntry(builder: (buildContext) {
    return DismissibleOverlay(
      overlayEntry: overlayEntry!,
      child: Scaffold(
        body: WriteWidget(
          changeImages: (images) {},
          onSubmit: (postContent) {
            onSubmit(postContent);
            //remove Overlay
            overlayEntry?.remove();
          },
          postContent: content,
        ),
      ),
    );
  });

  //insert the entry in the state to make it accesible
  overlayState.insert(overlayEntry);
}