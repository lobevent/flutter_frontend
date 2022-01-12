import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/event/events_multilist/cubit/events_mulitlist_cubit.dart';

class EventsMultilistBody extends StatefulWidget {
  @override
  EventsMultilistBodyState createState() => EventsMultilistBodyState();
}

class EventsMultilistBodyState extends State<EventsMultilistBody> {
  List<Event> events = [];
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventsMultilistCubit, EventsMultilistState>(
      // listener used here for deleting events
      listener: (context, state) => {
        //this is the deletion and loading
        state.maybeMap((value) => {},
            loaded: (state) => {this.events = state.events, setState(() {})},
            deleted: (state) => {
                  //this is for updating the listview when deleting
                  this.events.remove(state.event),
                  setState(() {})
                },
            orElse: () => {})
      },
      buildWhen: (previous, current) {
        return current.maybeMap((value) => true, deleted: (state) => false, orElse: () => true);
      },
      builder: (context, state) {
          return ListView.builder(
              itemBuilder: (context, index) {
                final event = this.events[index];
                // Errors
                if (event.failureOption.isSome()) {
                  return Ink(
                      color: Colors.red,
                      child: ListTile(
                        title: Text(event.failureOption.fold(() => "", (a) => a.toString())),
                      ));
                }
                if (this.events.isEmpty) {
                  return Ink(color: Colors.red, child: ListTile(title: Text("No events available")));
                } else {
                  return EventListTiles(
                    key: ObjectKey(event),
                    event: this.events[index],
                    onDeletion: context.read<EventsMultilistCubit>().option == EventScreenOptions.owned
                        ? (Event event) {
                            context.read<EventsMultilistCubit>().deleteEvent(event);
                          }
                        : null,
                  );
                }
              },
              itemCount: this.events.length);
        });
  }
}
