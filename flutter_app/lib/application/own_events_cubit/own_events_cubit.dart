import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:flutter_frontend/domain/event/i_event_repository.dart';
import 'package:flutter_frontend/infrastructure/event/event_local_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_remote_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/domain/event/event.dart';




part 'own_events_cubit.freezed.dart';
part 'own_events_state.dart';


class OwnEventsCubit extends Cubit<OwnEventsState> {
  OwnEventsCubit() : super(OwnEventsState.initial()) {
    var repository = EventRepository(EventRemoteService(), EventLocalService());
    emit(OwnEventsState.initial());
  }
  EventRepository repository;


  Future<void> getOwnEvents() async {
    Option<Either<EventFailure, Unit>> saveFailureOrSuccessOption;
    List<Event> ownEventsList = null;
    try {
      emit(OwnEventsState.loading());
      final Either<List<Event>, EventFailure> ownEventsList = await Future.delayed(Duration(seconds: 5), () {
        return left([Event(id: null, name: null, date: null, description: null, creationDate: null, owner: null, public: true)]);
      });
       //await repository.getList(Operation.owned, DateTime.now(), 5);
      emit(OwnEventsState.loaded(events: ownEventsList.fold((l) => throw EventFailure, (r) => null)));
    } catch (e) {
      emit(OwnEventsState.error(saveFailureOrSuccessOption: saveFailureOrSuccessOption));
    }
  }
}