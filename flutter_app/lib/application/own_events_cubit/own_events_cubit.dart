import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:flutter_frontend/domain/event/i_event_repository.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/infrastructure/event/event_local_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_remote_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/domain/event/event.dart';




part 'own_events_cubit.freezed.dart';
part 'own_events_state.dart';


class OwnEventsCubit extends Cubit<OwnEventsState> {
   OwnEventsCubit() : super(OwnEventsState.initial()) {
    emit(OwnEventsState.initial());
    getOwnEvents();
  }
  EventRepository repository = EventRepository(EventRemoteService(), EventLocalService());


  Future<void> getOwnEvents() async {
    try {
      emit(OwnEventsState.loading());
      final Either<List<Event>, EventFailure> ownEventsList = await Future.delayed(Duration(seconds: 2), () {
        return left([
          Event(id: Id(), name: EventName("test"), date: DateTime.now(), description: EventDescription("lalal"), creationDate: DateTime.now(), owner: Profile(id: Id(), name: ProfileName("ssss")), public: true),
        //Event.empty()
        ]);
      });
       //await repository.getList(Operation.owned, DateTime.now(), 5);
      emit(OwnEventsState.loaded(events: ownEventsList.fold((l) =>l, (r) => throw Exception)));
    } catch (e) {
      print ("test 11111111111111111");
      emit(OwnEventsState.error(error: e.toString()));
    }
  }
}