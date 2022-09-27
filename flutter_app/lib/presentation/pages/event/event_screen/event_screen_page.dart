import 'package:dartz/dartz.dart' show left, Either;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/bottom_navigation.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_message.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/Post/post_widget.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/EventContent/es_event_content.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/es_header_visual.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/EventContent/EventContentWidgets/EventTodoWidget/es_ec_td_todo_widget.dart';
import 'package:flutter_frontend/presentation/post_comment/post_screen/post_screen.dart';

import '../../core/widgets/loading_overlay.dart';
import 'cubit/event_screen/event_screen_cubit.dart';

class EventScreenPage extends StatelessWidget {
  final UniqueId eventId;

  const EventScreenPage({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ///init the bloc provider
    return BlocProvider(
        create: (context) => EventScreenCubit(eventId),

        ///the blocbuilder is needed to determine the state class
        ///to determine what to show (errormessage, loadingoverlay or content)
        /// this part of the class therefore contains logic
        child: BlocBuilder<EventScreenCubit, EventScreenState>(
          builder: (context, state) {
            ///the loading Overlay wraps the whole tree
            return LoadingOverlay(
              isLoading: state is LoadInProgress,
              child: RefreshIndicator(
                onRefresh: () => _reload(context),
                child: BasicContentContainer(
                  bottomNavigationBar: const BottomNavigation(
                    selected: NavigationOptions.ownEvents,
                  ),
                  child_ren: state.maybeMap(

                      /// check if an error has occured and show error message in that case
                      /// wrapped in a list to match closure context
                      error: (failure) => left([
                            ErrorMessage(
                              errorText: failure.toString(),
                            )
                          ]),

                      loaded: (loadetState) => left([
                        /// the Header with the pictures etc
                        HeaderVisual(networkImagePath: loadetState.event.image),

                        /// the event contents and information
                        EventContent(),



                      ]),
                      /// if the error state is not active, load the contentS
                      orElse: () => left([
                            /// the Header with the pictures etc
                            HeaderVisual(),

                            /// the event contents and information
                            EventContent(),

                          ])),
                ),
              ),
            );
          },
        ));
  }


  Future<void> _reload(BuildContext context)async {
    context.read<EventScreenCubit>().reload();
  }
}
