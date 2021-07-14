import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/post_comment/comment_screen/comment_screen_cubit.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_message.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/post_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/post_comment/comments_screen/widgets/comment_container.dart';

class CommentsScreen extends StatelessWidget {

  final UniqueId? postId;
  final UniqueId? parentCommentId;
  const CommentsScreen({Key? key, required this.postId, this.parentCommentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CommentScreenCubit(postId: postId, parentCommentId: parentCommentId),
        child: BlocBuilder<CommentScreenCubit, CommentScreenState>(
          builder: (context, state){
            return LoadingOverlay(
                isLoading: state is Loading,
                child: BasicContentContainer(
                    children:
                    state.maybeMap(
                      /// if the error state is not active, load the contents
                        error: (errState) =>[ErrorMessage(errorText: errState.error)],
                        orElse: () =>
                        const [
                          CommentContainer(),
                        ]
                    ),
            )
          );
        },
      ),
    );
  }

}
