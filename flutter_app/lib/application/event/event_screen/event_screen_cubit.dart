import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/value_objects.dart';

import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'event_screen_state.dart';
part 'event_screen_cubit.freezed.dart';

class EventScreenCubit extends Cubit<EventScreenState> {
  EventScreenCubit(UniqueId id) : super(EventScreenState.loading()) {
    emit(EventScreenState.loading());
    getEvent(id);
  }

  EventRepository repository = GetIt.I<EventRepository>();
  TodoRepository todoRepository = GetIt.I<TodoRepository>();

  Future<void> getEvent(UniqueId id) async {

    repository.getSingle(id).then((eventOrFailure) =>
        eventOrFailure.fold(
            (failure) => emit(EventScreenState.error(failure: failure)),
            (event) => emit(EventScreenState.loaded(event: event)
            )
        )
    );
  }
  Future<void> postItem({required String itemName, required String itemDescription}) async{

    _Loaded myCastedState = state as _Loaded;
    final Item newItem = Item(id: UniqueId(), profiles: [], name: ItemName(itemName), description: ItemDescription(itemDescription));
    todoRepository.addItem(myCastedState.event.todo!, newItem).then((eventOrFailure) =>
        eventOrFailure.fold(
                (failure) => emit(EventScreenState.error(failure: failure)),
                (event) {
                  myCastedState.event.todo?.items.add(newItem);
                  emit(myCastedState);
                }
            )
        );
  }
}
