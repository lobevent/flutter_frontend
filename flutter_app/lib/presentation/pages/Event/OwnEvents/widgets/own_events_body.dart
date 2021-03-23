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
      return state.map((_) => EventListView(events: []),
          initial: (_) => EventListView(events: []),
          loading: (_) => EventListView(events: []),
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
                color: Colors.red, width: 100, height: 100,
            child: Text(event.failureOption.fold(() => "", (a) => a.toString())),);

          } else {
            return ListTile(

              title: Text(events.first.name.getOrCrash()),
            );
          }
        },
        itemCount: events.length);
  }

}