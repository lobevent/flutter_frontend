import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/todo/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/post/comment_dtos.dart';
import 'package:flutter_frontend/infrastructure/post/post_dtos.dart';

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
    required List<ItemDto> items,

  }) = _TodoDto;

  factory TodoDto.fromDomain(Todo todo) {
    return TodoDto(id: todo.id.getOrCrash(), name: todo.name.getOrCrash(),
        items: todo.items.map((item) => ItemDto.fromDomain(item)).toList());
  }

  factory TodoDto.fromJson(Map<String, dynamic> json) =>
      _$TodoDtoFromJson(json);


  @override
  Todo toDomain() {
    return Todo(id: UniqueId.fromUniqueString(id),
        items: items.map((idto) => idto.toDomain()).toList(),
         description: TodoDescription(description!), name: TodoName(name));

  }
}
