import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
@freezed
class Todo with _$Todo {
  const Todo._();

  const factory Todo({
    required UniqueId id,
    required Item item,
    required Event event,
  }) = _Todo;
}