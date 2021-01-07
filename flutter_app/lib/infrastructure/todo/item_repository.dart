


import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/todo/i_item_repository.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/item_failure.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/todo/item_dtos.dart';
import 'package:flutter_frontend/infrastructure/todo/item_remote_service.dart';

class ItemRepository extends IItemRepository {
  final ItemRemoteService _itemRemoteService;

  ItemRepository(this._itemRemoteService);

  @override
  Future<Either<ItemFailure, Item>> create(Item item) async {
    try {
      final itemDto = ItemDto.fromDomain(item);
      ItemDto returnedItemDto =
      await _itemRemoteService.create(itemDto);
      return right(returnedItemDto.toDomain());
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<ItemFailure, Item>> delete(Item item) async {
    try {
      final itemDto = ItemDto.fromDomain(item);
      ItemDto returnedItemDto =
      await _itemRemoteService.delete(itemDto);
      return right(returnedItemDto.toDomain());
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<ItemFailure, Item>> getSingleItem(Id id) async {
    try {
      final ItemDto itemDto =
      await _itemRemoteService.getSingleItem(id.getOrCrash());
      final Item item = itemDto.toDomain();
      return right(item);
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<ItemFailure, Item>> update(Item item) async {
    try {
      final itemDto = ItemDto.fromDomain(item);
      ItemDto returnedItemDto;
      returnedItemDto = await _itemRemoteService.update(itemDto);
      return right(returnedItemDto.toDomain());
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<ItemFailure, List<Item>>> getList(
      Operation operation, int amount,Item item, Todo todo) async {
    try {
      List<ItemDto> itemDtos;
      switch (operation) {
        case Operation.attendingItemsTodo:
          itemDtos = await _itemRemoteService.getAttendingItemsTodo(amount, item.id.toString(), todo.id.toString());

      }
      //convert the dto objects to domain Objects
      final List<Item> items =
      itemDtos.map((itemDtos) => itemDtos.toDomain()).toList();
      return right(items);
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }
  ItemFailure _reactOnCommunicationException(CommunicationException e) {
    switch (e.runtimeType) {
      case NotFoundException:
        return const ItemFailure.notFound();
        break;
      case InternalServerException:
        return const ItemFailure.internalServer();
        break;
      case NotAuthenticatedException:
        return const ItemFailure.notAuthenticated();
        break;
      case NotAuthorizedException:
        return const ItemFailure.insufficientPermissions();
        break;
      case UnexpectedFormatException:
        return const ItemFailure.unexpected();
      default:
        return const ItemFailure.unexpected();
        break;
    }
  }
}
