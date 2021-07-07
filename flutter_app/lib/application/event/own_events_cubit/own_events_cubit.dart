import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:flutter_frontend/domain/event/i_event_repository.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';

part 'own_events_cubit.freezed.dart';
part 'own_events_state.dart';


enum EventScreenOptions { owned, fromUser, ownAttending, unreacted }

class OwnEventsCubit extends Cubit<OwnEventsState> {
  EventScreenOptions option = EventScreenOptions.owned;
  Profile? profile;
  OwnEventsCubit({this.option = EventScreenOptions.owned, this.profile}) : super(OwnEventsState.initial()) {
    emit(OwnEventsState.initial());
    getEvents();
  }
  EventRepository repository = GetIt.I<EventRepository>();


  /// gets events from backend, swiches on the options
  Future<void> getEvents() async {
    final Either<EventFailure,List<Event>> eventsList;
    try {
      emit(OwnEventsState.loading());
      switch(this.option){
        case EventScreenOptions.owned:
          eventsList= await repository.getList(Operation.owned, DateTime.now(), 30, descending: true);
          break;
        case EventScreenOptions.fromUser:
          if(profile == null){ // profile must be set for this!
            throw UnexpectedTypeError();
          }
          eventsList= await repository.getList(Operation.fromUser, DateTime.now(), 30, descending: true, profile: profile);
          break;
        case EventScreenOptions.ownAttending:
          eventsList= await repository.getList(Operation.attending, DateTime.now(), 30, descending: true);
          break;
        case EventScreenOptions.unreacted:
          eventsList= await repository.getList(Operation.unreacted, DateTime.now(), 30, descending: true);
          break;
      }
      emit(OwnEventsState.loaded(events: eventsList.fold((l) => throw Exception, (r) => r)));
    } catch (e) {
      emit(OwnEventsState.error(error: e.toString()));
    }
  }

  /// deletes Event if its own event list
  Future<bool> deleteEvent(Event event) async{
    if(option != EventScreenOptions.owned) {
      return false;
    }

    final Either<EventFailure, Event> deletedEvent = await repository.delete(event);

    deletedEvent.fold(
            (failure) {
          emit(OwnEventsState.error(error: "Error deleteing event!"));
          return false;
        },
            (event) => null);

    // map because of our states
    this.state.maybeMap((value) => null, loaded: (state)  {
      state.events.remove(event);
      List<Event> events = state.events;
      //this one is for the listview but
      emit(OwnEventsState.deleted(event: event));
      // we want to have the events in the state, so we emit the events again!
      emit(OwnEventsState.loaded(events: events));

    }, orElse: () => throw Exception('LogicError'));

    return true;
  }
}