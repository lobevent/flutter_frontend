import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/own_events_cubit/own_events_cubit.dart';
import 'package:flutter_frontend/domain/event/event.dart';

class OwnEventsBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnEventsCubit, OwnEventsState>(builder: (context, state)
    {
      return state.map((_) => Center(),
          initial: (_) {
            return const Center(child: Text("Rload"));
          },
          loading: (_) => const Center(
            child: CircularProgressIndicator(),
          ),
          loaded: (state) {
            return EventListView(events: state.events);
          },
          error: (value) => Center(child: Text(value.error)));
    });
  }

}


class EventListView extends StatelessWidget {


  final List<Event> events;


  const EventListView({required this.events});





  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemBuilder: (context, index) {

          final event = events[index];
          if (event.failureOption.isSome()) {
            return Container(
                color: Colors.red, width: 100, height: 100);
          } else {
            return Container(
              color: Colors.green,
              width: 100,
              height: 100,
              child: Text(events.first.name.getOrCrash()),
            );
          }
        },
        itemCount: events.length);
  }

}