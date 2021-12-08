import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/todo/value_objects.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';

part 'todo_cubit.freezed.dart';
part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final Event event;

  TodoCubit({required this.event}) : super(TodoState.initial()) {
    emit(TodoState.initial());
  }

  TodoRepository repository = GetIt.I<TodoRepository>();

  Future<void> loadTodoList(Event eventId) async {
    Either<NetWorkFailure, Todo> response = await repository.getTodoList(event);

    response.fold((failure) => emit(TodoState.error(failure: failure)),
        (todo) => emit(TodoState.loaded(todo: todo)));
  }

  ///CRUD
  Future<void> postItem(
      {required String itemName,
      required String itemDescription,
      required Todo todo}) async {
    final Item newItem = Item(
        id: UniqueId(),
        name: ItemName(itemName),
        description: ItemDescription(itemDescription),
        maxProfiles: ItemMaxProfiles(3),
        //fake profile list
        profiles: [
          Profile(id: UniqueId(), name: ProfileName("fake2")),
          Profile(id: UniqueId(), name: ProfileName("fake3"))
        ]);
    repository.addItem(todo, newItem).then((itemOrFailure) => itemOrFailure
            .fold((failure) => emit(TodoState.error(failure: failure)), (item) {
          todo.items.add(newItem);
          emit(TodoState.loaded(todo: todo));
        }));
  }

  Future<void> createTodo(Todo todo, Event event) async {
    Either<NetWorkFailure, Todo> failureOrSuccess =
        await repository.create(todo, event);
    emit(TodoState.loaded(
        todo: failureOrSuccess.fold((l) => throw Exception(), (r) => r)));
  }

  Future<bool> deleteItem(Todo todo, Item item) async {
    final success = await repository.deleteItem(item);
    return success;
  }

  Future<void> editItem(Todo todo, Item item) async {
    Either<NetWorkFailure, Item> failureOrSuccess =
        await repository.updateItem(item);
    emit(TodoState.loaded(
        todo: failureOrSuccess.fold((l) => throw Exception(), (itemBack) {
      //remove item

      int itemPos = todo.items.indexWhere((i) => i.id.value == item.id.value);
      todo.items[itemPos] = itemBack;
      return Todo(
          id: todo.id,
          description: todo.description,
          event: todo.event,
          items: todo.items,
          name: todo.name);
    })));
  }
  /*
  Future<void> saveItem() async{
    return updateEditItem(() => repository.updateItem(state.item));
  }

  Future<void> updateEditItem(Future<Either<NetworkFailure, Todo>> Function() servercall) async{

  }

   */
}
