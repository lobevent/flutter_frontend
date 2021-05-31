import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/todo/i_todo_repository.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:flutter_frontend/domain/todo/todo_failure.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/todo/item_remote_service.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_remote_service.dart';

class TodoRepository extends ITodoRepository{

  final TodoRemoteService _todoRemoteService;
  final ItemRemoteService _itemRemoteService;
  TodoRepository(this._itemRemoteService, this._todoRemoteService);


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
  Future<Either<NetWorkFailure, Todo>>getTodoList(Event event) {
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
  Future<Either<NetWorkFailure, Item>> addProfileToItem(Item item, Profile profile)async {
    try{
      return right((await _itemRemoteService.assignProfile(item.id.getOrCrash(), profile.id.getOrCrash())).toDomain()) ;
    }on CommunicationException catch (e){
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, Item>> deleteItem(Item item) async{
    try{
      return right((await _itemRemoteService.deleteItem(item.id.getOrCrash())).toDomain()) ;
    }on CommunicationException catch (e){
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, List<Item>>> getItems(Todo todo) {
    // TODO: implement getItems
    throw UnimplementedError();
  }

  @override
  Future<Either<NetWorkFailure, Item>> updateItem(Item item) async{
    try{
      return right((await _itemRemoteService.updateItem(item.id.getOrCrash())).toDomain()) ;
    }on CommunicationException catch (e){
    return left(_reactOnCommunicationException(e));
    }
  }


  NetWorkFailure _reactOnCommunicationException(CommunicationException e) {
    switch (e.runtimeType) {
      case NotFoundException:
        return const NetWorkFailure.notFound();
        break;
      case InternalServerException:
        return const NetWorkFailure.internalServer();
        break;
      case NotAuthenticatedException:
        return const NetWorkFailure.notAuthenticated();
        break;
      case NotAuthorizedException:
        return const NetWorkFailure.insufficientPermissions();
        break;
      case UnexpectedFormatException:
        return const NetWorkFailure.unexpected();
      default:
        return const NetWorkFailure.unexpected();
        break;
    }
  }

}