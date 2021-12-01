import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/post_comment_base_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

/// this is the post widget, which should be used everywhere
class PostWidget extends StatelessWidget {
  /// the post attribute, which contains all the post data
  final Post post;
  final bool showAuthor;
  final bool showCommentAction;
  const PostWidget(
      {Key? key,
      required this.post,
      this.showAuthor = true,
      this.showCommentAction = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PostCommentBaseWidget(
        date: post.creationDate,
        content: post.postContent.getOrCrash(),
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
            ))
      ],
    );
  }
}


/// generate list of posts
Widget generateUnscrollablePostContainer({required List<Post> posts, Profile? profile, bool showAutor = false}) {
  if (posts.isEmpty) {
    return Text("Nothing here yet");
  }
  // Expanded because if you leave it, it expands infinitely and throws errors
  return Container(
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
            post: profile != null ? posts[index].copyWith(owner: profile) : posts[index],
            showAuthor: showAutor,
          );
        },
      ));
}