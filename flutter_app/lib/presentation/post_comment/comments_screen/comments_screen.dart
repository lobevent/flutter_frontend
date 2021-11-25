import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_message.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/post_comment/comments_screen/widgets/comment_container.dart';

import 'comment_screen/comment_screen_cubit.dart';

class CommentsScreen extends StatelessWidget {
  final Post? post;
  final Comment? parentComment;
  const CommentsScreen({Key? key, this.post, this.parentComment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
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
  }
}
