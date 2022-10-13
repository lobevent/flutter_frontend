import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../domain/event/event.dart';
import '../../../../../infrastructure/event/event_repository.dart';

part 'event_timer_state.dart';
part 'event_timer_cubit.freezed.dart';

class EventTimerCubit extends Cubit<EventTimerState> {
  EventTimerCubit() : super(EventTimerState.initial()){
    emit(EventTimerState.initial());
    loadNextAttEvent();
  }
  EventRepository repository = GetIt.I<EventRepository>();

  Future<void> loadNextAttEvent()async{
    emit(EventTimerState.loading());
    final Either<NetWorkFailure, Event?> nextAttEvent;
    nextAttEvent = await repository.getNextAttEvent();
    nextAttEvent.fold(
            (l) => emit(EventTimerState.error(error: l.toString())),
            (r) => emit(EventTimerState.loaded(event: r)));
  }

}
