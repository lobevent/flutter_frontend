import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/todo/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';
import 'package:get_it/get_it.dart';

extension TodoOverlayCubit on EventScreenCubit {
  //TodoOverlayCubit(UniqueId id) : super(id);

  // Future<void> loadTodoList(Event eventId) async {
  //   Either<NetWorkFailure, Todo> response = await todoRepository.getTodoList(event);
  //
  //   response.fold((failure) => emit(TodoState.error(failure: failure)),
  //           (todo) => emit(TodoState.loaded(todo: todo)));
  // }

  ///CRUD
  Future<void> postItem({required String itemName, required String itemDescription, required Todo todo}) async {
    // new generated Item
    final Item newItem =
        Item(id: UniqueId(), name: ItemName(itemName), description: ItemDescription(itemDescription));
            //, maxProfiles: ItemMaxProfiles(3),); //what do we have this for????
            // //fake profile list
            // profiles: [Profile(id: UniqueId(), name: ProfileName("fake2")), Profile(id: UniqueId(), name: ProfileName("fake3"))]);

    await state.maybeMap(
        loaded: (value) async {
          emit(EventScreenState.loading());
          await todoRepository.addItem(todo, newItem).then((itemOrFailure) => itemOrFailure.fold(
                  // if we have an failure make an add EditItem Failure state, where the event is preserved
                  (failure) => emit(EventScreenState.addEditItemFailute(failure: failure, event: value.event)),
                  // if successfull emit new state with the added item
                  (item) {
                //add item to the eventOrgalist
                value.event.todo!.items.add(item);
                //emit loading state so an change is triggered

                emit(value.copyWith());
              }));
        },
        // if we are not in the loaded state we have an error, we should not be here
        orElse: () => throw LogicError());
  }

  Future<void> deleteItem(Todo todo, Item item) async {
    //map on the current state
    state.maybeMap(
        loaded: (loadedState) async {
          // await the deleteion
          bool success = await todoRepository.deleteItem(item);
          if (success) {
            // emit the loading state, so we can trigger an state change
            emit(EventScreenState.loading());
            //and then remove the item and emit new state with the item deleted
            loadedState.event.todo!.items.removeWhere((i) => i.id.value == item.id.value);
            emit(EventScreenState.loaded(event: loadedState.event));
          } else {
            // TODO: Fix this garbage! Never return booleans from requests, what if we have an networkfailure? The user will never know which??
            emit(EventScreenState.error(failure: NetWorkFailure.unexpected()));
          }
        },
        orElse: () => {});
  }

  Future<void> editItem(Todo todo, Item item) async {
    Either<NetWorkFailure, Item> failureOrSuccess = await todoRepository.updateItem(item);

    state.maybeMap(
        loaded: (loadedState) {
          todoRepository.updateItem(item).then((itemOrFailure) => itemOrFailure.fold(
                  // if we have an failure make an add EditItem Failure state, where the event is preserved
                  (failure) => emit(EventScreenState.addEditItemFailute(failure: failure, event: loadedState.event)), (itemBack) {
                //find position of the item
                int itemPos = todo.items.indexWhere((i) => i.id.value == item.id.value);
                // set the item at the position to the returned Item
                todo.items[itemPos] = itemBack;

                emit(EventScreenState.loaded(event: loadedState.event));
              }));
        },
        // if we are not in the loaded state we have an error, we should not be here
        orElse: () => throw LogicError());
  }

  Future<bool> assignProfile(Item item, Profile? profile) async {
    final success = await todoRepository.assignProfileToItem(item, null);
    return success;
  }
}
