import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/timer_widget.dart';
import 'package:flutter_frontend/presentation/pages/event/events_multilist/cubit/events_mulitlist_cubit.dart';
import 'package:flutter_frontend/presentation/pages/feed/event_timer/cubit/event_timer_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';

import '../../../../domain/event/event.dart';

class FeedEventTimer extends StatelessWidget {
  const FeedEventTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventTimerCubit(),
      child: BlocBuilder<EventTimerCubit, EventTimerState>(
        builder: (context, state) {
          return state.maybeMap((value) => const SizedBox.shrink(),
              initial: (init) {
            return const SizedBox.shrink();
          }, loading: (loadingState) {
            return const CircularProgressIndicator();
          }, loaded: (loadedState) {
            //check if events is in 7 days
            //if (loadedState.event!.date.isBefore(DateTime.now().add(const Duration(days: 7)))) {
            return EventTimer(loadedState.event!, context);
            //} else {
            //return const SizedBox.shrink();
            //}
          }, error: (err) {
            return ErrorWidget(err.error);
          }, orElse: () {
            return const SizedBox.shrink();
          });
        },
      ),
    );
    /*return

     */
  }

  oderByDate(List<Event> events) {
    events.sort((a, b) {
      return a.date.compareTo(b.date);
    });
  }

  Widget EventTimer(Event event, BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Text(event.name.getOrCrash()),
          TimerWidget(dateTime: event.date)
        ],
      ),
      onTap: () => context.router.push(EventScreenPageRoute(eventId: event.id)),
    );
  }
}
