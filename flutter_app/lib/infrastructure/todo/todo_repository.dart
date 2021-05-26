import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/todo/i_todo_repository.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/todo/todo_failure.dart';

class TodoRepository extends ITodoRepository{
  @override
  Future<Either<TodoFailure, Todo>> create(Todo todo) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Either<TodoFailure, Todo>> delete(Todo todo) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Either<TodoFailure, Todo>> getTodoList(Event event) {
    // TODO: implement getTodoList
    throw UnimplementedError();
  }

  @override
  Future<Either<TodoFailure, Todo>> update(Todo todo) {
    // TODO: implement update
    throw UnimplementedError();
  }
  
}