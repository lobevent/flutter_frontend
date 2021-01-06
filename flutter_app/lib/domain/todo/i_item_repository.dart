import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/post/post.dart';

import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/item_failure.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';



// TODO rename this one since it's duplicated in domain/event/i_event_repository.dart -> really confusing
/// For dertermination of the List to load
/// for example for showing created posts or feed
enum Operation{
  attendingItemsTodo,
}

abstract class IItemRepository{
  Future <Either<ItemFailure, List<Item>>> getList(
      Operation operation, int amount,{Todo todo});
  Future <Either<ItemFailure, Item>> getSingleItem(Id id);
  Future <Either<ItemFailure, Item>> create(Item item);
  Future <Either<ItemFailure, Item>> update(Item item);
  Future <Either<ItemFailure, Item>> delete(Item item);
}