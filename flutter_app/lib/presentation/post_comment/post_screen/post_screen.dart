import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/unscrollable_post_container.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/animations/LoadingEventsAnimation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_message.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';

import '../../pages/core/widgets/Post/write_widget/write_widget.dart';
import 'cubit/post_screen_cubit.dart';

class PostsScreen extends StatelessWidget {
  final Event event;

  const PostsScreen({Key? key, required this.event});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostScreenCubit(event: event),
      child: BlocBuilder<PostScreenCubit, PostScreenState>(
        builder: (context, state) {
          return BasicContentContainer(
            scrollable: true,
            child_ren: left(state.maybeMap(
                /// if the error state is not active, load the contents
                error: (errState) => [ErrorMessage(errorText: errState.error)],
                loaded: (loadedState) => [
                  WriteWidget(
                      changeImages: context.read<PostScreenCubit>().changePictures,
                      onSubmit: (content) {
                        context.read<PostScreenCubit>().postPost(content, event.id.value.toString());
                      }),
                  UnscrollablePostContainer(event: event, posts: loadedState.posts, showAuthor: true),
                ],
                orElse: () => [
                      SizedBox(
                          child: LoadingEventsAnimation(), height: MediaQuery.of(context).size.height*.8,)
                    ]
            )),
          );
        },
      ),
    );
  }
}
