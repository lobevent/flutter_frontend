


import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_screen.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/widgets/event_screen_description.dart';

import '../../core/widgets/loading_overlay.dart';

class EventScreenPage extends StatelessWidget {

  final UniqueId eventId;
  const EventScreenPage({Key? key, required this.eventId}): super(key: key);




  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => EventScreenCubit(eventId),
        child: BlocConsumer<EventScreenCubit, EventScreenState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Stack(
              children: <Widget>[
                state.maybeMap(
                    loaded: (loadState) =>  EventScreenBody(eventFailureOption: some(left(loadState.event))),
                    error: (errState) => EventScreenBody(eventFailureOption: some(right(errState.failure))),
                    orElse: () => EventScreenBody(eventFailureOption: none())),
                LoadingOverlay(isLoading: state is LoadInProgress, text: "Loading")
              ],
            );
          },
        ));
  }
}

class EventScreenBody extends StatelessWidget {
  final Option<Either<Event, EventFailure>> eventFailureOption;
  const EventScreenBody({
    required this.eventFailureOption,
    Key? key
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event")
      ),
      body: eventFailureOption.fold(
              () => Center(),
              (some) => some.fold((event) =>
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        EventScreenDescription(description: event.description),
                      ],
                    ),
                  ),
               (failure) => ErrorScreen(fail: failure.runtimeType.toString()))
      )
    );
  }

}