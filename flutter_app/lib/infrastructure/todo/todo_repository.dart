import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/todo/i_todo_repository.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions_handler.dart';
import 'package:flutter_frontend/infrastructure/todo/item_dtos.dart';
import 'package:flutter_frontend/infrastructure/todo/item_remote_service.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_dtos.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_remote_service.dart';

class TodoRepository extends ITodoRepository {
  final TodoRemoteService _todoRemoteService;
  final ItemRemoteService _itemRemoteService;

  TodoRepository(this._itemRemoteService, this._todoRemoteService);

  ///  posts an todolist to the server
  @override
  Future<Either<NetWorkFailure, Todo>> create(Todo todo, Event event) async {
    try {
      //try if the request can be made, if not we will get an NetworkFailure
      return right((await _todoRemoteService.createTodo(
              event.id.value, TodoDto.fromDomain(todo)))
          .toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  /// deletes Todolist
  @override
  Future<Either<NetWorkFailure, Todo>> delete(Todo todo) async {
    try {
      //try if the request can be made, if not we will get an NetworkFailure
      return right((await _todoRemoteService.deleteTodo(todo.id.value))
          .toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, Todo>> getTodoList(Event event) async {
    try {
      //try if the request can be made, if not we will get an NetworkFailure
      return right((await _todoRemoteService.getSingle(event.id.value))
          .toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, Todo>> update(Todo todo) async {
    try {
      //try if the request can be made, if not we will get an NetworkFailure
      return right(
          (await _todoRemoteService.updateTodo(TodoDto.fromDomain(todo)))
              .toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, Item>> addItem(Todo todo, Item item) async {
    try {
      //try if the request can be made, if not we will get an NetworkFailure
      return right((await _itemRemoteService.addItem(
              ItemDto.fromDomain(item), todo.id.value))
          .toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, Item>> addProfileToItem(
      Item item, Profile profile) async {
    try {
      //try if the request can be made, if not we will get an NetworkFailure
      return right((await _itemRemoteService.assignProfile(
              item.id.value, profile.id.value))
          .toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, Item>> deleteItem(Item item) async {
    try {
      //try if the request can be made, if not we will get an NetworkFailure
      return right((await _itemRemoteService.deleteItem(item.id.value))
          .toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, List<Item>>> getItems(Todo todo) {
    // TODO: implement getItems
    throw UnimplementedError();
  }

  @override
  Future<Either<NetWorkFailure, Item>> updateItem(Item item) async {
    try {
      //try if the request can be made, if not we will get an NetworkFailure
      return right(
          (await _itemRemoteService.updateItem(ItemDto.fromDomain(item)))
              .toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }
}
