import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

import '../../../../../domain/event/event.dart';


part 'events_own_state.dart';
part 'events_own_cubit.freezed.dart';

class EventsOwnCubit extends Cubit<EventsOwnState> {
  EventRepository repository = GetIt.I<EventRepository>();

  EventsOwnCubit() : super(EventsOwnState.loading()){
    loadEvents();
  }

  Future<void> loadEvents() async{

  }


}
