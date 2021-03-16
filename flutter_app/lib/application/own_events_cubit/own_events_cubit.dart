import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:flutter_frontend/domain/event/i_event_repository.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/event/event_local_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_remote_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/i_event_repository.dart';
import '';




part 'own_events_state.dart';
part 'own_events_cubit.freezed.dart';

class OwnEventsCubit extends Cubit<OwnEventsState> {
  OwnEventsCubit() : super(OwnEventsState.initial()) {
    var repository = EventRepository(EventRemoteService(), EventLocalService());
    emit(OwnEventsState.initial());
  }
  EventRepository repository;


  Future<void> _getOwnEvents() async {
    List<Event> ownEventsList = null;
    try {
      emit(OwnEventsState.loading());
      final ownEventsList = await repository.getList(Operation.owned, DateTime.now(), 5);
      emit(OwnEventsState.loaded(events: ownEventsList.fold((l) => throw EventFailure, (r) => r)));
    } catch (e) {
      emit(OwnEventsState.error());
    }
  }
}