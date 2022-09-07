import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/timer_widget.dart';
import 'package:flutter_frontend/presentation/pages/event/events_multilist/cubit/events_mulitlist_cubit.dart';

import '../../../../domain/event/event.dart';

class FeedEventTimer extends StatelessWidget {
  const FeedEventTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EventsMultilistCubit(option: EventScreenOptions.owned),
      child: BlocBuilder<EventsMultilistCubit, EventsMultilistState>(
        builder: (context, state) {
          return state.maybeMap((value) => Text(''), loaded: (loadedState) {
            List<Event> events = loadedState.events;
            oderByDate(events);
            return EventTimer(events.first);
          }, orElse: () {
            return Text('');
          });
        },
      ),
    );
  }

  oderByDate(List<Event> events) {
    events.sort((a, b) {
      return a.date.compareTo(b.date);
    });
  }

  Widget EventTimer(Event event) {
    return Container(
      child: TimerWidget(dateTime: event.date),
    );
  }
}
