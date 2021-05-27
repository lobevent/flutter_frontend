import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/todo/todo_failure.dart';
import 'package:get_it/get_it.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_repository.dart';

part 'todo_state.dart';
part 'todo_cubit.freezed.dart';

class TodoCubit extends Cubit<TodoState> {
  final Event event;

  TodoCubit({required Event this.event}) : super(TodoState.initial()){
    emit(TodoState.initial());
    loadTodoList(event);
  }

  TodoRepository repository = GetIt.I<TodoRepository>();

  Future<void> loadTodoList(Event event) async{
    Either<NetWorkFailure, Todo> response = await repository.getTodoList(event);

    response.fold(
            (todoFailure) => emit(TodoState.error(error: todoFailure.toString())),
            (todo) => emit(TodoState.loaded(todo: todo)));
  }
}
