import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_frontend/application/core/geo_functions.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:flutter_frontend/infrastructure/invitation/invitation_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';

import '../../../../../application/core/geo_functions_cubit.dart';

part 'events_mulitlist_cubit.freezed.dart';
part 'events_mulitlist_state.dart';

enum EventScreenOptions {
  owned,
  near,
  fromUser,
  recent,
  ownAttending,
  unreacted,
  invited
}

// TODO: this has to be debugged. When calling a new function to fast, the old one will emit a wrong state
@Deprecated("Thx daniel")
class EventsMultilistCubit extends Cubit<EventsMultilistState> {
  int checknumber = 0;
  EventScreenOptions option = EventScreenOptions.near;
  Profile? profile;
  double kilometersVal = 5;

  bool LoadPastEvents = false;
  EventsMultilistCubit({this.option = EventScreenOptions.near, this.profile})
      : super(EventsMultilistState.initial()) {
    emit(EventsMultilistState.initial());
    controller.addListener(_scrollListener);
    getEvents(this.option);
  }
  ScrollController controller = ScrollController();
  EventRepository repository = GetIt.I<EventRepository>();
  InvitationRepository invRepo = GetIt.I<InvitationRepository>();

  /// gets events from backend, swiches on the options
  Future<void> getEvents(EventScreenOptions option,
      [int? distanceKilometers]) async {
    checknumber = Random().nextInt(1000000000);
    int localCheckNumber = checknumber;
    final Either<NetWorkFailure, List<Event>> eventsList;
    final Either<NetWorkFailure, List<Event>> eventsListRecent;
    final Either<NetWorkFailure, List<Invitation>> invitationList;
    // try {
    emit(EventsMultilistState.loading());
    bool isInvite = false;
    switch (option) {
      case EventScreenOptions.owned:
        eventsList = await repository.getOwnedEvents(DateTime.now(), 30,
            descending: false);
        /*return emit(EventsMultilistState.loadedOwnBoth(
            eventsUpcoming: eventsList.fold((l) => throw Exception, (r) => r),
            eventsRecent:
                eventsListRecent.fold((l) => throw Exception, (r) => r)));

         */
        break;
      case EventScreenOptions.fromUser:
        if (profile == null) {
          // profile must be set for this!
          throw UnexpectedTypeError();
        }
        eventsList = await repository.getEventsFromUserUpcoming(
            DateTime.now(), 30, profile!);
        eventsListRecent = await repository.getEventsFromUserRecent(
            DateTime.now(), 30, profile!,
            descending: true);
        return emit(EventsMultilistState.loadedOwnBoth(
            eventsUpcoming: eventsList.fold((l) => throw Exception, (r) => r),
            eventsRecent:
                eventsListRecent.fold((l) => throw Exception, (r) => r)));
        break;
      case EventScreenOptions.near:
        final Position? position =
            await GeoFunctions().checkIfNeedToFetchPosition(5);
        eventsList = await repository.getNearEvents(position!.latitude,
            position.longitude, kilometersVal.ceil(), DateTime.now(), 30);
        break;
      case EventScreenOptions.ownAttending:
        eventsList = await repository.getAttendingEvents(DateTime.now(), 30);
        break;
      case EventScreenOptions.unreacted:
        eventsList = await repository.getUnreactedEvents(DateTime.now(), 30);
        break;
      case EventScreenOptions.recent:
        eventsList = await repository.getRecentEvents(DateTime.now(), 30,
            descending: true);
        break;
      case EventScreenOptions.invited:
        {
          invitationList = await invRepo.getInvitations(DateTime.now(), 30,
              descending: false);
          isInvite = true;
          invitationList.fold(
              (l) => EventsMultilistState.error(error: l.toString()), (r) {
            if (localCheckNumber == checknumber) {
              //checks whether the function was called again and had been ready
              emit(EventsMultilistState.loadedInvited(invites: r));
            }
          });
        }
        return;
        break;
    }
    //checks whether the function was called again and had been ready
    if (localCheckNumber == checknumber) {
      emit(EventsMultilistState.loaded(
          events: eventsList.fold((l) => throw Exception, (r) => r)));
    }
    // } catch (e) {
    //   throw e;
    //   emit(EventsMultilistState.error(error: e.toString()));
    // }
  }

  /// deletes Event if its own event list
  Future<bool> deleteEvent(Event event) async {
    if (option != EventScreenOptions.owned) {
      return false;
    }

    final Either<NetWorkFailure, Event> deletedEvent =
        await repository.delete(event);

    deletedEvent.fold((failure) {
      emit(EventsMultilistState.error(error: "Error deleteing event!"));
      return false;
    }, (event) => null);

    // map because of our states
    this.state.maybeMap((value) => null,
        loaded: (state) {
          state.events.remove(event);
          List<Event> events = state.events;
          //this one is for the listview but
          emit(EventsMultilistState.deleted(event: event));
          // we want to have the events in the state, so we emit the events again!
          emit(EventsMultilistState.loaded(events: events));
        },
        orElse: () => throw Exception('LogicError'));

    return true;
  }

  Future<void> loadMore() async {
    // if(lastLoadedDate.toIso8601String() == state.posts.last.creationDate.toIso8601String()){
    //   return;
    // }
    final Position? position =
        await GeoFunctions().checkIfNeedToFetchPosition(5);

    List<Event> oldEvent = [];
    state.maybeMap((value) => null, loaded: (loadedState) {
      oldEvent = loadedState.events;
    }, orElse: () {});

    final Either<NetWorkFailure, List<Event>> eventsList =
        await repository.getNearEvents(position!.latitude, position.longitude,
            kilometersVal.ceil(), oldEvent.last.creationDate, 30);

    List<Event> eventsNew = eventsList.fold((l) => throw Exception(), (r) => r);

    state.maybeMap((value) => null, loaded: (loadedState) {
      oldEvent = loadedState.events;
    }, orElse: () {});
    //oldEvent.addAll(eventsNew);
    emit(EventsMultilistState.initial());
    emit(EventsMultilistState.loaded(events: eventsNew));
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      kilometersVal = kilometersVal + 5;
      loadMore();
    }
    if (controller.offset <= controller.position.minScrollExtent &&
        !controller.position.outOfRange) {}
  }
}
