import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/todo/i_todo_repository.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/todo/todo_failure.dart';

class TodoRepository extends ITodoRepository{
  @override
  Future<Either<NetWorkFailure, Todo>> create(Todo todo) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Either<NetWorkFailure, Todo>> delete(Todo todo) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Either<NetWorkFailure, Todo>> getTodoList(Event event) {
    // TODO: implement getTodoList
    throw UnimplementedError();
  }

  @override
  Future<Either<NetWorkFailure, Todo>> update(Todo todo) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Either<NetWorkFailure, Item>> addItem(Todo todo, Item item) {
    // TODO: implement addItem
    throw UnimplementedError();
  }

  @override
  Future<Either<NetWorkFailure, Item>> addProfileToItem(Item item, Profile profile) {
    // TODO: implement addProfileToItem
    throw UnimplementedError();
  }

  @override
  Future<Either<NetWorkFailure, Item>> deleteItem(Item item) {
    // TODO: implement deleteItem
    throw UnimplementedError();
  }

  @override
  Future<Either<NetWorkFailure, List<Item>>> getItems(Todo todo) {
    // TODO: implement getItems
    throw UnimplementedError();
  }

  @override
  Future<Either<NetWorkFailure, Item>> updateItem(Item item) {
    // TODO: implement updateItem
    throw UnimplementedError();
  }

}