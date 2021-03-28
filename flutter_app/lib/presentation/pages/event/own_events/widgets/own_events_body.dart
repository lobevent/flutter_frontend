import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/own_events_cubit/own_events_cubit.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles.dart';

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
            return Ink(
                color: Colors.red,
                child: ListTile(
                  title: Text(
                      event.failureOption.fold(() => "", (a) => a.toString())),)
            );
          }
          if (events.isEmpty) {
            return Ink(
                color: Colors.red,
                child: ListTile(
                  title: Text("No own events available")
            ));
          }

          else{
            return EventListTiles(event: events[index], allowEdit: true);
            // return ListTile(
            //
            //   title: Text(events[index].name.getOrCrash()),
            // );
          }
        },
        itemCount: events.length);
  }

}