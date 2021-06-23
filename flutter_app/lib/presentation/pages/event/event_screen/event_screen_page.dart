import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_message.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/header_visual.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/event_content.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/todo_widget.dart';

import '../../core/widgets/loading_overlay.dart';

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
            child:
              BasicContentContainer(
                children:
                  state.maybeMap(
                      /// check if an error has occured and show error message in that case
                      /// wrapped in a list to match closure context
                      error: (failure) => [ErrorMessage(errorText: failure.toString(),)],

                      /// if the error state is not active, load the contentS
                      orElse: () => [
                        /// the Header with the pictures etc
                        HeaderVisual(),
                        /// the event contents and information
                        EventContent(),
                        /// todoevents list
                        TodoWidget(),
                      ]),
              )
          );
        },
      )
    );
  }



}

