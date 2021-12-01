import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_message.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/post_comment/comments_screen/widgets/comment_container.dart';

//import 'comment_screen/comment_screen_cubit.dart';

class PostsScreen extends StatelessWidget {
  
  final UniqueId eventId;

  const PostsScreen({Key? key, required this.eventId});
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  /*  return BlocProvider(
      create: (context) =>
          CommentScreenCubit(post: post, parentComment: parentComment),
      child: BlocBuilder<CommentScreenCubit, CommentScreenState>(
        builder: (context, state) {
          return LoadingOverlay(
              isLoading: state is Loading,
              child: BasicContentContainer(
                children: state.maybeMap(

                    /// if the error state is not active, load the contents
                    error: (errState) =>
                        [ErrorMessage(errorText: errState.error)],
                    orElse: () => const [
                          CommentContainer(),
                        ]),
              ));
        },
      ),
    );
  */}
}
