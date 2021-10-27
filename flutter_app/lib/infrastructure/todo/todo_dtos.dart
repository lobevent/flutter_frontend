import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/todo/value_objects.dart';
import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'item_dtos.dart';

part 'todo_dtos.freezed.dart';
part 'todo_dtos.g.dart';

@freezed
class TodoDto extends BaseDto with _$TodoDto {
  const TodoDto._();

  const factory TodoDto({
    required String id,
    required String name,
    String? description,
    @ItemsConverter() required List<ItemDto> orgalistItems,
  }) = _TodoDto;

  factory TodoDto.fromDomain(Todo todo) {
    return TodoDto(
        id: todo.id.value,
        name: todo.name.getOrCrash(),
        orgalistItems:
            todo.items.map((item) => ItemDto.fromDomain(item)).toList());
  }

  factory TodoDto.fromJson(Map<String, dynamic> json) =>
      _$TodoDtoFromJson(json);

  @override
  Todo toDomain() {
    return Todo(
        id: UniqueId.fromUniqueString(id),
        items: orgalistItems.map((idto) => idto.toDomain()).toList(),
        description: TodoDescription(description!),
        name: TodoName(name));
  }
}

class ItemsConverter extends ListConverter<ItemDto> {
  const ItemsConverter() : super();
}
