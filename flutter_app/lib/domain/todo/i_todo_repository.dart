import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';

abstract class ITodoRepository {
  Future<Either<NetWorkFailure, Todo>> getTodoList(Event event);
  Future<Either<NetWorkFailure, Todo>> create(Todo todo, Event event);
  Future<Either<NetWorkFailure, Todo>> update(Todo todo);
  Future<Either<NetWorkFailure, Todo>> delete(Todo todo);
  Future<Either<NetWorkFailure, Item>> addItem(Todo todo, Item item);
  Future<Either<NetWorkFailure, Item>> addProfileToItem(
      Item item, Profile profile);
  Future<Either<NetWorkFailure, Item>> deleteItem(Item item);
  Future<Either<NetWorkFailure, Item>> updateItem(Item item);
  Future<Either<NetWorkFailure, List<Item>>> getItems(Todo todo);
}
