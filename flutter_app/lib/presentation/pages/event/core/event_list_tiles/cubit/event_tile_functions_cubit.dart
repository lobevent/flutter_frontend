import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'event_tile_functions_state.dart';

class EventTileFunctionsCubit extends Cubit<EventTileFunctionsState> {
  EventRepository repository = GetIt.I<EventRepository>();
  Event event;


  EventTileFunctionsCubit(this.event) : super(EventTileFunctionsInitial());

  Future<void> changeStatus(EventStatus status) async {
          emit(EventTileUESLoading());
          await repository
              .changeStatus(event, status)
              .then((value) {value.fold(
                    (failure) => emit(EventTileUESError(failure)),
                    (event) {
                  emit(EventTileUESLoaded());
                });
        });
  }
}
