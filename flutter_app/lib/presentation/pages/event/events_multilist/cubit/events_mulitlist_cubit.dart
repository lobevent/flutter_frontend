import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';

part 'events_mulitlist_cubit.freezed.dart';
part 'events_mulitlist_state.dart';

enum EventScreenOptions { owned, fromUser, ownAttending, unreacted, invited }

class EventsMultilistCubit extends Cubit<EventsMultilistState> {
  EventScreenOptions option = EventScreenOptions.owned;
  Profile? profile;
  EventsMultilistCubit({this.option = EventScreenOptions.owned, this.profile})
      : super(EventsMultilistState.initial()) {
    emit(EventsMultilistState.initial());
    getEvents();
  }
  EventRepository repository = GetIt.I<EventRepository>();

  /// gets events from backend, swiches on the options
  Future<void> getEvents() async {
    final Either<NetWorkFailure, List<Event>> eventsList;
    try {
      emit(EventsMultilistState.loading());
      switch (this.option) {
        case EventScreenOptions.owned:
          eventsList = await repository.getOwnedEvents(DateTime.now(), 30,
              descending: true);
          break;
        case EventScreenOptions.fromUser:
          if (profile == null) {
            // profile must be set for this!
            throw UnexpectedTypeError();
          }
          eventsList = await repository.getEventsFromUser(
              DateTime.now(), 30, profile!,
              descending: true);
          break;
        case EventScreenOptions.ownAttending:
          eventsList = await repository.getAttendingEvents(DateTime.now(), 30);
          break;
        case EventScreenOptions.unreacted:
          eventsList = await repository.getUnreactedEvents(DateTime.now(), 30);
          break;
        case EventScreenOptions.invited:
          eventsList = await repository.getInvitedEvents(DateTime.now(), 30, descending: false);
          break;
      }
      emit(EventsMultilistState.loaded(
          events: eventsList.fold((l) => throw Exception, (r) => r)));
    } catch (e) {
      emit(EventsMultilistState.error(error: e.toString()));
    }
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
}
