// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/core/style.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/error_message.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/loading_overlay.dart';
import 'package:flutter_frontend/presentation/pages/core/widgets/styling_widgets.dart';
import 'package:flutter_frontend/presentation/pages/event/core/event_list_tiles/event_list_tiles.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/events_multilist/cubit/events_mulitlist_cubit.dart';
import 'package:flutter_frontend/presentation/routes/router.gr.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderWidget extends StatefulWidget {

  CalenderWidget({Key? key}):super(key:key);

  @override
  CalenderWidgetState createState() => CalenderWidgetState();
}

class CalenderWidgetState extends State<CalenderWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  //start and end of calender needs to be defined here
  DateTime _focusedDay = DateTime.now();
  DateTime kLastDay = DateTime(
      DateTime.now().year, DateTime.now().month + 3, DateTime.now().day);
  DateTime kFirstDay = DateTime(
      DateTime.now().year, DateTime.now().month - 6, DateTime.now().day);
  DateTime _selectedDay = DateTime.now();
  //events which are loaded
  List<Event> events = [];
  //map for accessing events via datetime key
  Map<DateTime, Event>? eventsMap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      //use this cubit to fetch own/attending events
          EventsMultilistCubit(option: EventScreenOptions.owned),
      child: BlocConsumer<EventsMultilistCubit, EventsMultilistState>(
          listener: (context, state) => {},
          builder: (context, state) {
            state.maybeMap((value) => null, loaded: (loadedState) {
              //get events out of State
              events = loadedState.events;
              //create a map <DateTime,Event>
              eventsMap = {for (var e in events) e.date: e};
            }, orElse: () {});
            bool isLoading = state.maybeMap((_) => false,
                loadedInvited: (s) => false,
                loaded: (s) => false,
                loading: (_) => true,
                orElse: () => false);
            //if loading return loadingcircle
            return LoadingOverlay(
                isLoading: isLoading,
                child: CalenderScaffold());
          }),
    );
  }

  //look for a specific day, if there are events
  List _getEventsForDay(DateTime day) {
    final List output = [];
    if(eventsMap!=null){
      eventsMap!.forEach((key, value) {
        if (isSameDay(key, day)) {
          output.add(key);
        }
      });
    }else{
      return [];
    }
    return output;
  }

  ///real calender widget, with all calender logic
  Widget CalenderScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Calender'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              // Use `selectedDayPredicate` to determine which day is currently selected.
              // If this returns true, then `day` will be marked as selected.

              // Using `isSameDay` is recommended to disregard
              // the time-part of compared DateTime objects.
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
            eventLoader: (day) {
              //decide for each day to build events
              return _getEventsForDay(day);
            },
            ///styling shit
            calendarStyle:  const CalendarStyle(
              isTodayHighlighted: true,
              markerDecoration: BoxDecoration(color: AppColors.white, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(
                color: AppColors.accentButtonColor,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(color: AppColors.textOnAccentColor),
            ),
          ),
          // here build for a selected day the eventlisttiles, if there are any
          ..._getEventsForDay(_selectedDay).map((e)  => EventListTiles(key: ObjectKey(eventsMap![e]!), event: eventsMap![e]!)
              //ListTile(title: Text(eventsMap![e]!.name.toString()),)
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: (){
        //TODO: pass the DateTime argument to this route
        context.router.push(EventFormPageRoute());
      }, label: const Text("Add Event")),
    );
  }
}
