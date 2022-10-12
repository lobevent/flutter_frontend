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


}



