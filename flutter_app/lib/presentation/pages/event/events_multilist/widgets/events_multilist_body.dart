import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/stylings/std_choice_text_chip.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/event/events_multilist/cubit/events_mulitlist_cubit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class EventsMultilistBody extends StatefulWidget {
  @override
  EventsMultilistBodyState createState() => EventsMultilistBodyState();
}

class EventsMultilistBodyState extends State<EventsMultilistBody> {
  List<Event> events = [];
  List<Invitation> invitations = [];
  bool isInvites = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventsMultilistCubit, EventsMultilistState>(
        // listener used here for deleting events
        listener: (context, state) => {
              //this is the deletion and loading
              state.maybeMap((value) => {},
                  loaded: (state) => {this.events = state.events, this.isInvites = false, setState(() {})},
                  deleted: (state) => {
                        //this is for updating the listview when deleting
                        this.events.remove(state.event),
                        setState(() {})
                      },
                  loadedInvited: (state) => {this.invitations = state.invites, isInvites = true, setState(() {})},
                  orElse: () => {})
            },
        buildWhen: (previous, current) {
          return current.maybeMap((value) => true, deleted: (state) => false, orElse: () => true);
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // Add the app bar to the CustomScrollView.
              SliverAppBar(
                elevation: 10.0,
                backgroundColor: AppColors.appBarCollor,
                automaticallyImplyLeading: false,
                pinned: true,
                flexibleSpace: Row(
                  children: [
                    ChipChoice(list: {
                      "recent" : (bool bla) {context.read<EventsMultilistCubit>().getEvents(EventScreenOptions.recent);},
                      "invited" : (bool bla) {
                        context.read<EventsMultilistCubit>().getEvents(EventScreenOptions.invited);},
                      "own" : (bool bla) {print("invited");},
                      "attending" : (bool bla) {print("attending");},
                    },),
                  ],
                ),
              ),
              // Next, create a SliverList
              SliverList(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                  (context, index) {
                    if (isInvites) {
                      return ItemBuilder(index, this.invitations[index].event!, this.invitations[index].userEventStatus);
                    } else {
                      return ItemBuilder(index, events[index], null);
                    }
                  },
                  // Builds 1000 ListTiles
                  childCount: isInvites ? this.invitations.length : this.events.length,
                ),
              ),
            ],
          );
        });
  }

  ///
  /// builds the items, but generic for invitations and events
  ///
  Widget ItemBuilder(int index, Event event, EventStatus? userEventStatus) {
    // Errors
    if (event.failureOption.isSome()) {
      return Ink(
          color: Colors.red,
          child: ListTile(
            title: Text(event.failureOption.fold(() => "", (a) => a.toString())),
          ));
    }
    if (this.events.isEmpty && !this.isInvites || this.invitations.isEmpty && this.isInvites) {
      return Ink(color: Colors.red, child: ListTile(title: Text("No events available")));
    } else {
      return EventListTiles(
        key: ObjectKey(event),
        eventStatus: userEventStatus,
        isInvitation: isInvites,
        event: event,
        onDeletion: context.read<EventsMultilistCubit>().option == EventScreenOptions.owned
            ? (Event event) {
                context.read<EventsMultilistCubit>().deleteEvent(event);
              }
            : null,
      );
    }
  }
}

class ChipChoice extends StatefulWidget {
  final Map<String, Function(bool)> list;

  const ChipChoice({Key? key, required this.list}) : super(key: key);

  @override
  State<ChipChoice> createState() => _ChipChoiceState();
}

class _ChipChoiceState extends State<ChipChoice> {
  int? _value = 1;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Wrap(
      alignment: WrapAlignment.spaceAround,
      children: List<Widget>.generate(
        widget.list.length,
        (int index) {
          return StdChoiceTextChip(
            label: (widget.list.keys.toList()[index]),
            selected: _value == index,
            onSelected: (bool selected) {
              widget.list.values.toList()[index](selected);
              setState(() {
                _value = index;
              });
            },
          );
        },
      ).toList(),
    ));
  }
}
