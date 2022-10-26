import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';



import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/post_widget/post_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/write_widget/write_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/LoadingEventsAnimation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_message.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/post_comment/comments_page/cubit/comments_page_cubit.dart';
import 'package:flutter_frontend/presentation/post_comment/comments_page/widgets/comment_widget/comment_widget.dart';
import 'package:flutter_frontend/presentation/post_comment/comments_screen/widgets/comment_container.dart';



class CommentsPage extends StatelessWidget {
  final Either<Post, Comment> entity;
  const CommentsPage({Key? key, required this.entity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CommentsPageCubit(entity: entity),
      child: BlocBuilder<CommentsPageCubit, CommentsPageState>(
        builder: (context, state) {
          return BasicContentContainer(
            //floating action button to scroll down
            /*floatingActionButton: FloatingActionButton.small(
              elevation: 0.0,
              onPressed: () {},
              backgroundColor: Colors.green,
              child: const Icon(Icons.navigation),
            ),

             */
            child_ren: left([
            state.entity.fold((l) => PostWidget(post: l), (r) => CommentWidget(comment: r)),
              CommentList(state.children, state.status == StatusCPS.loading, context),
              if(state.status != StatusCPS.loading)
                WriteWidget(onSubmit: (content) =>context.read<CommentsPageCubit>().postComment(content))
            ]),
          );
        },
      ),
    );
  }



  /// generates the list with the comments
  /// this is not scrollable
  Widget CommentList(List<Comment> comments, bool isLoading, BuildContext context) {
    if(isLoading){
      return SizedBox(
        height: MediaQuery.of(context).size.height*.8,
        child: const LoadingEventsAnimation(),);
    }
    return Container(
      padding: entity.isRight()? stdPadding.copyWith(right: 0.0) : null,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: comments.length,
        itemBuilder: (context, index) {
          return CommentWidget(comment: comments[index]);
        },
      ),
    );
  }
}