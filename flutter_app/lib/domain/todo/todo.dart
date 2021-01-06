import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
@freezed
abstract class Todo implements _$Todo {
  const Todo._();

  const factory Todo({
    @required Id id,
    @required Item item,
    @required Event event,
  }) = _Todo;
}