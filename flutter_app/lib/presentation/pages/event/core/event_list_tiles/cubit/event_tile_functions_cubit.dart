import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'event_tile_functions_state.dart';

class EventTileFunctionsCubit extends Cubit<EventTileFunctionsState> {
  EventRepository repository = GetIt.I<EventRepository>();
  Event event;


  EventTileFunctionsCubit(this.event) : super(EventTileFunctionsInitial(event.status));

  Future<void> changeStatus(EventStatus status) async {
          emit(EventTileUESLoading(status));
          await repository
              .changeStatus(event, status)
              .then((value) {value.fold(
                    (failure) =>
                        emit(EventTileUESError(failure, status)),
                    (event) {
                  emit(EventTileUESLoaded(status));
                });
        });
  }

  /// deletes Event if its own event list
  Future<bool> deleteEvent(Event event) async {
    final Either<NetWorkFailure, Event> deletedEvent =
    await repository.delete(event);

    deletedEvent.fold((failure) {
      emit(EventTileDeletionError(failure: failure));
      return false;
    }, (event) => emit(EventTileDeletionSuccess(status: state.status)));


    // map because of our states
    // this.state.maybeMap(
    //     loaded: (state) {
    //       //state.events.remove(event);
    //       if(recent){
    //         List<Event> events = state.recent_events;
    //         events.remove(event);
    //         // we want to have the events in the state, so we emit the events again!
    //         emit(EventsUserState.loaded(recent_events: events, future_events: state.future_events, ));
    //       }else{
    //         List<Event> events = state.future_events;
    //         events.remove(event);
    //         // we want to have the events in the state, so we emit the events again!
    //         emit(EventsUserState.loaded(recent_events: state.recent_events, future_events: events, ));
    //       }
    //
    //       //this one is for the listview but
    //       //emit(EventsMultilistState.deleted(event: event));
    //
    //     },
    //     orElse: () => throw Exception('LogicError'));

    return true;
  }
}
