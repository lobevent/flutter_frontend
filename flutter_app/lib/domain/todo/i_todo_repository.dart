import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/todo/todo_failure.dart';

abstract class ITodoRepository{
  Future <Either<TodoFailure, Todo>> getTodoList(Event event);
  Future <Either<TodoFailure, Todo>> create(Todo todo);
  Future <Either<TodoFailure, Todo>> update(Todo todo);
  Future <Either<TodoFailure, Todo>> delete(Todo todo);
}