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
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

extension TodoOverlayCubit on EventScreenCubit {
  ///CRUD

  ///
  /// posts new item to the backend, loading state while waiting and new state with the item in the list
  /// [itemName] the name that the item should have
  /// [itemDescription] the description of the item
  /// [todo] the todolist
  ///
  Future<void> postItem(
      {required String itemName,
      required String itemDescription,
      required Todo todo}) async {
    // new generated Item
    final Item newItem = Item(
      id: UniqueId(),
      name: ItemName(itemName),
      description: ItemDescription(itemDescription),
      maxProfiles: ItemMaxProfiles(3),
    );
    // //fake profile list //what do we have this for????
    // profiles: [Profile(id: UniqueId(), name: ProfileName("fake2")), Profile(id: UniqueId(), name: ProfileName("fake3"))]);

    await state.maybeMap(
        loaded: (value) async {
          emit(value.copyWith(addingItem: true));
          //emit loading state so an change is triggered
          //emit(EventScreenState.loading());
          await todoRepository.addItem(todo, newItem).then((itemOrFailure) =>
              itemOrFailure.fold(
                  // if we have an failure make an add EditItem Failure state, where the event is preserved
                  (failure) => emit(EventScreenState.addEditItemFailute(
                      failure: failure, event: value.event)),
                  // if successfull emit new state with the added item
                  (item) {
                //add item to the eventOrgalist
                List<Item> items = List.from(value.event.todo!.items);

                items.insert(0, item);
                emit(value.copyWith(
                    addingItem: false,
                    event: value.event
                        .copyWith(todo: todo.copyWith(items: items))));
              }));
        },
        // if we are not in the loaded state we have an error, we should not be here
        orElse: () {});
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
          final Either<NetWorkFailure, Item> itemBack =
              await todoRepository.deleteItem(item);

          itemBack.fold((l) => emit(EventScreenState.error(failure: l)), (r) {
            emit(EventScreenState.loading());
            List<Item> items = loadedState.event.todo!.items.toList();
            items.removeWhere((i) => i.id.value == item.id.value);
            emit(loadedState.copyWith(
                event: loadedState.event
                    .copyWith(todo: todo.copyWith(items: items))));
          });
        },
        orElse: () {});
  }

  ///
  /// edit item function: sends edited item to backend and emits new state with the edited item in the list
  /// [todo] the todolist
  /// [item] the item to edit
  ///
  Future<void> editItem(Todo todo, Item item) async {
    Either<NetWorkFailure, Item> failureOrSuccess =
        await todoRepository.updateItem(item);

    state.maybeMap(
        loaded: (loadedState) {
          todoRepository.updateItem(item).then((itemOrFailure) =>
              itemOrFailure.fold(
                  // if we have an failure make an add EditItem Failure state, where the event is preserved
                  (failure) => emit(EventScreenState.addEditItemFailute(
                      failure: failure, event: loadedState.event)), (itemBack) {
                //find position of the item
                List<Item> items = List.from(loadedState.event.todo!.items);
                Todo? todo = loadedState.event.todo;

                int itemPos =
                    items.indexWhere((i) => i.id.value == item.id.value);
                items[itemPos] = itemBack;

                var newState = loadedState.copyWith(
                    event: loadedState.event
                        .copyWith(todo: todo!.copyWith(items: items)));
                emit(newState);
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
    Either<NetWorkFailure, Item> itemFailure =
        await todoRepository.assignProfileToItem(item, profile);

    state.maybeMap(
        loaded: (loadedState) async {
          // await the deleteion
          todoRepository.assignProfileToItem(item, profile).then(
              (itemOrFailure) => itemOrFailure.fold(
                      (fail) => emit(EventScreenState.addEditItemFailute(
                          event: loadedState.event,
                          failure: fail)), (itemBack) {
                    emit(EventScreenState.loading());

                    List<Item> items = List.from(loadedState.event.todo!.items);
                    Todo? todo = loadedState.event.todo;

                    int itemPos =
                        items.indexWhere((i) => i.id.value == item.id.value);
                    items[itemPos] = itemBack;

                    var newState = loadedState.copyWith(
                        event: loadedState.event
                            .copyWith(todo: todo!.copyWith(items: items)));
                    emit(newState);
                  }));
        },
        orElse: () => throw LogicError);
  }

  Future<void> deassignProfile(Item item, Profile? profile) async {
    Either<NetWorkFailure, Item> itemFailure =
        await todoRepository.deassignProfileToItem(item, profile);

    state.maybeMap(
        loaded: (loadedState) async {
          // await the deleteion
          todoRepository.deassignProfileToItem(item, profile).then(
              (itemOrFailure) => itemOrFailure.fold(
                      (fail) => emit(EventScreenState.addEditItemFailute(
                          event: loadedState.event,
                          failure: fail)), (itemBack) {
                    emit(EventScreenState.loading());
                    List<Item> items = List.from(loadedState.event.todo!.items);
                    Todo? todo = loadedState.event.todo;

                    int itemPos =
                        items.indexWhere((i) => i.id.value == item.id.value);
                    items[itemPos] = itemBack;

                    var newState = loadedState.copyWith(
                        event: loadedState.event
                            .copyWith(todo: todo!.copyWith(items: items)));
                    emit(newState);
                  }));
        },
        orElse: () => throw LogicError);
  }
}
