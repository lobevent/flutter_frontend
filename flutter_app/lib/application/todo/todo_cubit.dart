import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/value_objects.dart';
import 'package:get_it/get_it.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_repository.dart';

part 'todo_state.dart';
part 'todo_cubit.freezed.dart';

class TodoCubit extends Cubit<TodoState> {
  final Event event;

  TodoCubit({required this.event}) : super(TodoState.initial()){
    emit(TodoState.initial());
    loadTodoList(event);
  }

  TodoRepository repository = GetIt.I<TodoRepository>();

  Future<void> loadTodoList(Event eventId) async{
    Either<NetWorkFailure, Todo> response = await repository.getTodoList(event);

    response.fold(
            (failure) => emit(TodoState.error(failure: failure)),
            (todo) => emit(TodoState.loaded(todo: todo)));
  }

  Future<void> postItem({required String itemName, required String itemDescription}) async{

    _TodoLoaded myCastedState = state as _TodoLoaded;
    final Item newItem = Item(id: UniqueId(), profiles: [], name: ItemName(itemName), description: ItemDescription(itemDescription));
    repository.addItem(myCastedState.todo, newItem).then((itemOrFailure) =>
        itemOrFailure.fold(
                (failure) => emit(TodoState.error(failure: failure)),
                (item) {
              myCastedState.todo.items.add(newItem);
              emit(myCastedState);
            }
        )
    );
  }

}