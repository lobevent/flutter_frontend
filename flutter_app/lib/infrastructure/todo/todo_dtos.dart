import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/todo/value_objects.dart';
import 'package:flutter_frontend/infrastructure/core/event_converter.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/todo/item_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';

part 'todo_dtos.freezed.dart';

part 'todo_dtos.g.dart';

@freezed
abstract class TodoDto extends BaseDto implements _$TodoDto {
  const TodoDto._();

  const factory TodoDto({
    @required int id,
    @required String todoListName,
    @required ItemDto item,
    @required @EventConverter() EventDto event,
  }) = _TodoDto;

  factory TodoDto.fromDomain(Todo todo) {
    return TodoDto(
          id: todo.id.getOrCrash(),
          todoListName: todo.todoListName.getOrCrash(),
          item: ItemDto.fromDomain(todo.item),
          event: EventDto.fromDomain(todo.event),
        );
  }

  factory TodoDto.fromJson(Map<String, dynamic> json) =>
      _$TodoDtoFromJson(json);

  @override
  Todo toDomain() {
    return Todo(
      id: Id.fromUnique(id),
      todoListName: TodoListName(todoListName),
      item: item.toDomain(),
      event: event.toDomain(),
    );
  }
}