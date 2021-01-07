


import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/todo/i_todo_repository.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/todo/todo_failure.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_dtos.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_remote_service.dart';

class TodoRepository extends ITodoRepository {
  final TodoRemoteService _todoRemoteService;

  TodoRepository(this._todoRemoteService);

  @override
  Future<Either<TodoFailure, Todo>> create(Todo todo) async {
    try {
      final todoDto = TodoDto.fromDomain(todo);
      TodoDto returnedTodoDto =
      await _todoRemoteService.create(todoDto);
      return right(returnedTodoDto.toDomain());
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<TodoFailure, Todo>> delete(Todo todo) async {
    try {
      final todoDto = TodoDto.fromDomain(todo);
      TodoDto returnedTodoDto =
      await _todoRemoteService.delete(todoDto);
      return right(returnedTodoDto.toDomain());
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<TodoFailure, Todo>> getSingleTodo(Id id) async {
    try {
      final TodoDto todoDto =
      await _todoRemoteService.getSingleTodo(id.getOrCrash());
      final Todo todo = todoDto.toDomain();
      return right(todo);
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<TodoFailure, Todo>> update(Todo todo) async {
    try {
      final todoDto = TodoDto.fromDomain(todo);
      TodoDto returnedTodoDto;
      returnedTodoDto = await _todoRemoteService.update(todoDto);
      return right(returnedTodoDto.toDomain());
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  TodoFailure _reactOnCommunicationException(CommunicationException e) {
    switch (e.runtimeType) {
      case NotFoundException:
        return const TodoFailure.notFound();
        break;
      case InternalServerException:
        return const TodoFailure.internalServer();
        break;
      case NotAuthenticatedException:
        return const TodoFailure.notAuthenticated();
        break;
      case NotAuthorizedException:
        return const TodoFailure.insufficientPermissions();
        break;
      case UnexpectedFormatException:
        return const TodoFailure.unexpected();
      default:
        return const TodoFailure.unexpected();
        break;
    }
  }
}
