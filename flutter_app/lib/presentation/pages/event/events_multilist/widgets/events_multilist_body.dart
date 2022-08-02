import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/presentation/core/styles/colors.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/stylings/std_choice_text_chip.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles/event_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_screen/widgets_tabs/ess_page_eventTabs.dart';
import 'package:flutter_frontend/presentation/pages/event/events_multilist/cubit/events_mulitlist_cubit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class EventsMultilistBody extends StatefulWidget {
  final bool profileView;

  const EventsMultilistBody({Key? key, required this.profileView})
      : super(key: key);
  @override
  EventsMultilistBodyState createState() => EventsMultilistBodyState();
}

class EventsMultilistBodyState extends State<EventsMultilistBody> {
  List<Event> events = [];
  List<Event> eventsRecent = [];
  List<Invitation> invitations = [];
  bool isInvites = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EventsMultilistCubit, EventsMultilistState>(
        // listener used here for deleting events
        listener: (context, state) => {
              //this is the deletion and loading
              state.maybeMap((value) => {},
                  loaded: (state) => {
                        this.events = state.events,
                        this.isInvites = false,
                        setState(() {})
                      },
                  loadedOwnBoth: (state) => {
                        this.events = state.eventsUpcoming,
                        this.eventsRecent = state.eventsRecent,
                        setState(() {})
                      },
                  deleted: (state) => {
                        //this is for updating the listview when deleting
                        this.events.remove(state.event),
                        setState(() {})
                      },
                  loadedInvited: (state) => {
                        this.invitations = state.invites,
                        isInvites = true,
                        setState(() {})
                      },
                  orElse: () => {})
            },
        buildWhen: (previous, current) {
          return current.maybeMap((value) => true,
              deleted: (state) => false, orElse: () => true);
        },
        builder: (context, state) {
          // ---------------------------------------------------------------------------------------------------------------
          // -------------------------------------------------- WIDGET FROM HERE -------------------------------------------
          // ---------------------------------------------------------------------------------------------------------------
          if (eventsRecent.isNotEmpty) {
            return EventTabs(upcoming: events, recendEvents: eventsRecent);
          }

          return CustomScrollView(
            slivers: [
              // Add the app bar to the CustomScrollView.
              if (!widget.profileView) EventList_Bar(),
              // Next, create a SliverList
              SliverList(
                // Use a delegate to build items as they're scrolled on screen.
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                  (context, index) {
                    if (isInvites) {
                      return ItemBuilder(index, this.invitations[index].event!,
                          this.invitations[index].userEventStatus);
                    } else {
                      return ItemBuilder(index, events[index], null);
                    }
                  },
                  // Builds 1000 ListTiles
                  childCount:
                      isInvites ? this.invitations.length : this.events.length,
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
            title:
                Text(event.failureOption.fold(() => "", (a) => a.toString())),
          ));
    }
    if (this.events.isEmpty && !this.isInvites ||
        this.invitations.isEmpty && this.isInvites) {
      return Ink(
          color: Colors.red,
          child: ListTile(title: Text("No events available")));
    } else {
      return EventListTiles(
        key: ObjectKey(event),
        eventStatus: userEventStatus,
        isInvitation: isInvites,
        event: event,
        onDeletion: context.read<EventsMultilistCubit>().option ==
                EventScreenOptions.owned
            ? (Event event) {
                context.read<EventsMultilistCubit>().deleteEvent(event);
              }
            : null,
      );
    }
  }
}

class EventList_Bar extends StatelessWidget {
  const EventList_Bar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 10.0,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      automaticallyImplyLeading: false,
      pinned: true,
      flexibleSpace: Row(
        children: [
          ChipChoice(
            list: {
              "own": (bool bla) {
                context
                    .read<EventsMultilistCubit>()
                    .getEvents(EventScreenOptions.owned);
              },
              "near": (bool bla) {
                context
                    .read<EventsMultilistCubit>()
                    .getEvents(EventScreenOptions.near);
              },
              "recent": (bool bla) {
                context
                    .read<EventsMultilistCubit>()
                    .getEvents(EventScreenOptions.recent);
              },
              "invited": (bool bla) {
                context
                    .read<EventsMultilistCubit>()
                    .getEvents(EventScreenOptions.invited);
              },
              "attending": (bool bla) {
                context
                    .read<EventsMultilistCubit>()
                    .getEvents(EventScreenOptions.ownAttending);
              },
            },
          ),
        ],
      ),
    );
  }
}
