import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/event/own_events_cubit/own_events_cubit.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles.dart';

class OwnEventsBody extends StatefulWidget{
  @override
  OwnEventsBodyState createState() => OwnEventsBodyState();
}

class OwnEventsBodyState extends State<OwnEventsBody> {
  List<Event> events = [];
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OwnEventsCubit, OwnEventsState>(

        builder: (context, state)
    {
      return state.map((_) => EventListView(), // TODO: Simplify to maybemap
          initial: (_) => EventListView(),
          loading: (_) => EventListView(),
          deleted: (_) => EventListView(),
          loaded: (state) {
            EventListView object = EventListView();
            return object;
          },
          error: (value) => Center(child: Text(value.error)));
    });
  }

}

class EventListView extends StatefulWidget{

  @override
  EventListViewState createState() => EventListViewState();


}

class EventListViewState extends State<EventListView> {

  List<Event> events = [];



  @override
  Widget build(BuildContext context) {

    List<Event> events = this.events;
    return
      BlocListener<OwnEventsCubit, OwnEventsState>(
        listener: (context, state) => {
          //this is the deletion and loading
          state.maybeMap(
                  (value) => {},
              loaded: (state) => {
                    if(this.events.isEmpty)
                      this.events = state.events
                    else
                     this.events.remove(this.events.toSet().difference(state.events.toSet()).toList()[0]),
                    //this.events = state.events,
                    setState((){})
              },
              deleted: (state) => {
                this.events.remove(state.event),
                setState(() {})
              },
              orElse: () => {})
        },
        child:
          ListView.builder(
            itemBuilder: (context, index) {
              final event = this.events[index];
              if (event.failureOption.isSome()) {
                return Ink(
                    color: Colors.red,
                    child: ListTile(
                      title: Text(
                          event.failureOption.fold(() => "", (a) => a.toString())),)
                );
              }
              if (this.events.isEmpty) {
                return Ink(
                    color: Colors.red,
                    child: ListTile(
                      title: Text("No own events available")
                ));
              }

              else{
                return EventListTiles(key: ObjectKey(event), event: this.events[index], allowEdit: true);
              }
            },
            itemCount: this.events.length)
      ,);
  }

}