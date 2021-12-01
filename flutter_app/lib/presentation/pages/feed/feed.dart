import 'package:auto_route/auto_route.dart' hide Router;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/bottom_navigation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_message.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/main_app_bar.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/post_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/feed/cubit/feed_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

class FeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
            create: (context) => FeedCubit(),
            child: BlocBuilder<FeedCubit, FeedState>(
              // buildWhen: (previousState, state) {
              //   return previousState.isLoading != state.isLoading;
              // },
              builder: (context, state) {
                return BasicContentContainer(
                  appBar: MainAppBar(),
                  bottomNavigationBar: const BottomNavigation(selected: NavigationOptions.home),
                  children: [
                    LoadingOverlay(
                      isLoading: state.isLoading,
                      child:  state.error.isSome() ? ErrorMessage(errorText: state.error.fold(() {}, (a) => a)) : generateUnscrollablePostContainer(state.posts), )
                  ],
                );
              },
            ),
    );
  }
}
