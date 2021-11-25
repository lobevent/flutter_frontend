import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'event_screen_cubit.freezed.dart';
part 'event_screen_state.dart';

class EventScreenCubit extends Cubit<EventScreenState> {
  EventScreenCubit(UniqueId id) : super(EventScreenState.loading()) {
    emit(EventScreenState.loading());
    getEvent(id);
  }

  EventRepository repository = GetIt.I<EventRepository>();
  TodoRepository todoRepository = GetIt.I<TodoRepository>();

  Future<void> getEvent(UniqueId id) async {
    repository.getSingle(id).then((eventOrFailure) => eventOrFailure.fold(
        (failure) => emit(EventScreenState.error(failure: failure)),
        (event) => emit(EventScreenState.loaded(event: event))));
  }

  Future<void> createOrgaEvent(Event event) async {
    Either<NetWorkFailure, bool> failureOrSuccess =
        await todoRepository.createOrga(event);
  }
}
