// Copyright 2019 Aleksander Woźniak
// SPDX-License-Identifier: Apache-2.0

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:flutter_frontend/presentation/pages/event/events_multilist/cubit/events_mulitlist_cubit.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderWidget extends StatefulWidget {
  @override
  _CalenderWidgetState createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime kLastDay = DateTime(DateTime.now().year,DateTime.now().month+3, DateTime.now().day);
  DateTime kFirstDay = DateTime(DateTime.now().year, DateTime.now().month-6, DateTime.now().day);
  DateTime? _selectedDay;
  List<Event> events = [];
  late Map<DateTime, Event> eventsMap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => EventsMultilistCubit(
        option: EventScreenOptions.owned),
    child: BlocConsumer<EventsMultilistCubit, EventsMultilistState>(
    listener: (context, state) => {},
    builder: (context, state) {
      state.maybeMap(
              (value) => null,
          loaded: (loadedState){
                events = loadedState.events;
                eventsMap= { for (var e in events) e.date : e };
          },
          orElse: (){
          });
      bool isLoading = state.maybeMap((_) => false,
          loadedInvited: (s) => false,
          loaded: (s) => true,
          loading: (_) => false,
          orElse: () => false);
      return state.maybeMap(
              (value) => const Text(""),
          loaded: (loadedState){
            return CalenderScaffold();

          },
          orElse: (){
                return const Text('');
          });
    }),
    );
  }

  List _getEventsForDay(DateTime day) {

    List output = [];

    eventsMap.forEach((key, value) {
      if(isSameDay(key, day)){
        output.add(key);
      }
    });

    return output;

  }

  Widget CalenderScaffold(){
    return Scaffold(
      appBar: AppBar(
        title: Text('TableCalendar - Basics'),
      ),
      body: TableCalendar(
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
          }
      ),
    );
  }
}