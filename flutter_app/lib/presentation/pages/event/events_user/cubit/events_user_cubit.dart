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

enum View {declined, owned}
class EventsUserCubit extends Cubit<EventsUserState> {
  Profile profile;
  View view;
  EventRepository repository = GetIt.I<EventRepository>();

  EventsUserCubit(this.profile, {this.view = View.owned}) : super(EventsUserState.loading()){
    loadEvents();
  }

  /// loads first events
  /// uses [_upcomingFunction] to determine the correct repository call
  Future<void> loadEvents() async{
    emit(EventsUserState.loading());
    final Either<NetWorkFailure, List<Event>> eventsList;
    final Either<NetWorkFailure, List<Event>> eventsListRecent;


    eventsList = await _upcomingFunction(DateTime.now(), 30, profile);
    eventsListRecent = await _recentFunction(DateTime.now(), 30, profile, descending: true);

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



  /// generic function for upcoming events to reduce boilerplate and code duplication
  Future<Either<NetWorkFailure, List<Event>>> _upcomingFunction(DateTime lastEventTime, int amount, Profile profile,
      {bool descending = false}) async{
    switch (view){
      case View.declined:
        return await repository.getAttendingEvents(lastEventTime, amount, status: EventStatus.notAttending, descending: descending,);
        break;
      case View.owned:
        return await repository.getEventsFromUserUpcoming(DateTime.now(), 30, profile, descending: descending);
        break;
    }

  }
  /// generic function for recent events to reduce boilerplate and code duplication
  Future<Either<NetWorkFailure, List<Event>>> _recentFunction(DateTime lastEventTime, int amount, Profile profile,
      {bool descending = true}) async{
    switch (view){

      case View.declined:
        return await repository.getAttendingEvents(lastEventTime, amount, status: EventStatus.notAttending, descending: descending,);
        break;
      case View.owned:
        return await repository.getEventsFromUserRecent(DateTime.now(), 30, profile, descending: descending);
        break;
    }

  }


}



