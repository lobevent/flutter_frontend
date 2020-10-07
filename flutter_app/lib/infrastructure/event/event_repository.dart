import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:flutter_frontend/domain/event/i_event_repository.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';

import 'event_local_service.dart';
import 'event_remote_service.dart';

class EventRepository implements IEventRepository{
  final EventRemoteService _eventRemoteService;
  final EventLocalService _eventLocalService;

  EventRepository(this._eventRemoteService, this._eventLocalService);
  @override
  Future<Either<EventFailure, Unit>> create(Event event) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Either<EventFailure, Unit>> delete(Event event) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Either<EventFailure, List<Event>>> getList(Operation operation, {Profile profile}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future<Either<EventFailure, Event>> getSingle(Operation operation, {Profile profile}) {
    // TODO: implement getSingle
    throw UnimplementedError();
  }

  @override
  Future<Either<EventFailure, Unit>> update(Event event) {
    // TODO: implement update
    throw UnimplementedError();
  }
  
}