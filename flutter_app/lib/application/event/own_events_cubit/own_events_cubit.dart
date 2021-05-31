import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:flutter_frontend/domain/event/i_event_repository.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';

part 'own_events_cubit.freezed.dart';
part 'own_events_state.dart';


class OwnEventsCubit extends Cubit<OwnEventsState> {
  OwnEventsCubit() : super(OwnEventsState.initial()) {
    emit(OwnEventsState.initial());
    getOwnEvents();
  }
  EventRepository repository = GetIt.I<EventRepository>();


  Future<void> getOwnEvents() async {
    try {
      emit(OwnEventsState.loading());

      final Either<EventFailure,List<Event>> ownEventsList= await repository.getList(Operation.owned, DateTime.now(), 30, descending: true);

      emit(OwnEventsState.loaded(events: ownEventsList.fold((l) => throw Exception, (r) => r)));
    } catch (e) {
      emit(OwnEventsState.error(error: e.toString()));
    }
  }

  Future<bool> deleteEvent(Event event) async{

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