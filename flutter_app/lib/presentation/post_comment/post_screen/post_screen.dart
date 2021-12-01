import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_message.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/post_comment/post_screen/widgets/post_container.dart';

import 'cubit/post_screen_cubit.dart';

class PostsScreen extends StatelessWidget {

  final Event event;

  const PostsScreen({Key? key, required this.event});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PostScreenCubit(event: event),
      child: BlocBuilder<PostScreenCubit, PostScreenState>(
        builder: (context, state) {
          return LoadingOverlay(
              isLoading: state is Loading,
              child: BasicContentContainer(
                children: state.maybeMap(

                    /// if the error state is not active, load the contents
                    error: (errState) =>
                        [ErrorMessage(errorText: errState.error)],
                    orElse: () => const [
                          PostContainer(),
                        ]),
              ));
        },
      ),
    );
  }
}
