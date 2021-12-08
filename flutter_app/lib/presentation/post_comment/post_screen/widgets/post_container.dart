import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/post_comment_base_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/post_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/post_comment/post_screen/cubit/post_screen_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class PostContainer extends StatelessWidget {

  const PostContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostScreenCubit, PostScreenState>(
      builder: (context, state) {
        return state.maybeMap(
            loaded: (loadedState) {
              // if we have the loaded state, map over the profile
              // profile has the base profile (list view) and an full profile
              return PostList(loadedState.posts);
            },
            orElse: () => Text(""));
      }
    );
  }
}
  /// generate list of posts
  Widget PostList(List<Post> posts) {
    return generateUnscrollablePostContainer(posts: posts, showAutor: true);
}
