import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';


import '../../../../../domain/event/event.dart';


part 'events_user_cubit.freezed.dart';
part 'events_user_state.dart';

class EventsUserCubit extends Cubit<EventsUserState> {
  Profile profile;
  EventRepository repository = GetIt.I<EventRepository>();

  EventsUserCubit(this.profile) : super(EventsUserState.loading()){
    loadEvents();
  }

  Future<void> loadEvents() async{
    emit(EventsUserState.loading());
    final Either<NetWorkFailure, List<Event>> eventsList;
    final Either<NetWorkFailure, List<Event>> eventsListRecent;


    eventsList = await repository.getEventsFromUserUpcoming(DateTime.now(), 30, profile);
    eventsListRecent = await repository.getEventsFromUserRecent(DateTime.now(), 30, profile, descending: true);

    if(eventsList.fold((l) {emit(EventsUserState.failure(failure: l)); return true;}, (r) => false)) {
      return;
    }

    if(eventsListRecent.fold((l) {emit(EventsUserState.failure(failure: l)); return true;}, (r) => false)) {
      return;
    }

    emit(EventsUserState.loaded(
        future_events: eventsList.fold((l) => throw Exception, (r) => r),
        recent_events:
        eventsListRecent.fold((l) => throw Exception, (r) => r)));
  }



  // /// deletes Event if its own event list
  // Future<bool> deleteEvent(Event event, bool recent) async {
  //
  //   final Either<NetWorkFailure, Event> deletedEvent =
  //   await repository.delete(event);
  //
  //   deletedEvent.fold((failure) {
  //     emit(EventsUserState.failure(failure: failure));
  //     return false;
  //   }, (event) => null);
  //
  //   // map because of our states
  //   this.state.maybeMap(
  //       loaded: (state) {
  //         //state.events.remove(event);
  //         if(recent){
  //           List<Event> events = state.recent_events;
  //           events.remove(event);
  //           // we want to have the events in the state, so we emit the events again!
  //           emit(EventsUserState.loaded(recent_events: events, future_events: state.future_events, ));
  //         }else{
  //           List<Event> events = state.future_events;
  //           events.remove(event);
  //           // we want to have the events in the state, so we emit the events again!
  //           emit(EventsUserState.loaded(recent_events: state.recent_events, future_events: events, ));
  //         }
  //
  //         //this one is for the listview but
  //         //emit(EventsMultilistState.deleted(event: event));
  //
  //       },
  //       orElse: () => throw Exception('LogicError'));
  //
  //   return true;
  // }

}



