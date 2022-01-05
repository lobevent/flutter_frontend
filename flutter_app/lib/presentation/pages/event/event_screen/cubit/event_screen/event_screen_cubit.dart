import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/todo/value_objects.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_repository.dart';
import 'package:flutter_frontend/presentation/pages/event/todos/todo_cubit/todo_cubit.dart';
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

  Future<void> createOrgaEvent(
      Event event, String orgaName, String orgaDesc) async {
    Either<NetWorkFailure, Todo> todoOrFailure;
    //create the new Toddo/Orgalist and assign parameters
    Todo newTodo = Todo(
      id: UniqueId(),
      name: TodoName(orgaName),
      description: TodoDescription(orgaDesc),
      items: [],
    );
    //pass the toddo instanly so we dont have to reload the whole shit event
    todoRepository.createOrga(event, newTodo).then((todoOrFailure) =>
        todoOrFailure.fold(
            (failure) => emit(EventScreenState.error(failure: failure)),
            (todo) => emit(EventScreenState.loaded(
                event: Event(
                    todo: todo,
                    owner: event.owner,
                    attendingCount: event.attendingCount,
                    status: event.status,
                    latitude: event.latitude,
                    longitude: event.longitude,
                    description: event.description,
                    name: event.name,
                    invitations: event.invitations,
                    creationDate: event.creationDate,
                    public: event.public,
                    visibleWithoutLogin: event.visibleWithoutLogin,
                    date: event.date,
                    id: event.id)))));
  }




}
