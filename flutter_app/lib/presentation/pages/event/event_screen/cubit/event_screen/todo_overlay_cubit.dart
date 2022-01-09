import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/todo/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/event/event_screen/cubit/event_screen/event_screen_cubit.dart';

extension TodoOverlayCubit on EventScreenCubit {


  ///CRUD

  ///
  /// posts new item to the backend, loading state while waiting and new state with the item in the list
  /// [itemName] the name that the item should have
  /// [itemDescription] the description of the item
  /// [todo] the todolist
  ///
  Future<void> postItem({required String itemName, required String itemDescription, required Todo todo}) async {
    // new generated Item
    final Item newItem =
        Item(id: UniqueId(), name: ItemName(itemName), description: ItemDescription(itemDescription), maxProfiles: ItemMaxProfiles(3),);
            // //fake profile list //what do we have this for????
            // profiles: [Profile(id: UniqueId(), name: ProfileName("fake2")), Profile(id: UniqueId(), name: ProfileName("fake3"))]);

    await state.maybeMap(
        loaded: (value) async {
          //emit loading state so an change is triggered
          emit(EventScreenState.loading());
          await todoRepository.addItem(todo, newItem).then((itemOrFailure) => itemOrFailure.fold(
                  // if we have an failure make an add EditItem Failure state, where the event is preserved
                  (failure) => emit(EventScreenState.addEditItemFailute(failure: failure, event: value.event)),
                  // if successfull emit new state with the added item
                  (item) {
                //add item to the eventOrgalist
                value.event.todo!.items.add(item);
                emit(value);
              }));
        },
        // if we are not in the loaded state we have an error, we should not be here
        orElse: () => throw LogicError());
  }

  ///
  /// deletes item from the backend and emits state with the list without the item
  /// [todo] the todolist
  /// [item] the item to delete
  ///
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

  ///
  /// edit item function: sends edited item to backend and emits new state with the edited item in the list
  /// [todo] the todolist
  /// [item] the item to edit
  ///
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


  ///
  /// assigns profile to an item, and sends the request to backend. emits new state with the assigned profile at the item
  /// [item] the item where a profile should be assigned to
  /// [profile] the profile which has to be assigned, if no profile is given, the current profile will be assigned
  ///
  Future<void> assignProfile(Item item, Profile? profile) async {
    state.maybeMap(
        loaded: (loadedState) async {
          // await the deleteion
          bool success = await todoRepository.assignProfileToItem(item, null);
          if (success) {
            // emit the loading state, so we can trigger an state change
            emit(EventScreenState.loading());
            //and then remove the item and emit new state with the item deleted
            int itemPos = loadedState.event.todo!.items.indexWhere((i) => i.id.value == item.id.value);
            // TODO: we have to retrieve our own profile somehow, and allow user to add other profiles if they are host
            loadedState.event.todo!.items[itemPos].profiles?.add(Profile(id: UniqueId(), name: ProfileName('Its Mee')));

            emit(EventScreenState.loaded(event: loadedState.event));
          } else {
            // TODO: Fix this garbage! Never return booleans from requests, what if we have an networkfailure? The user will never know which??
            emit(EventScreenState.error(failure: NetWorkFailure.unexpected()));
          }
        },
        orElse: () => {});
  }

}
