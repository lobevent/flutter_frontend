import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:flutter_frontend/domain/event/i_event_repository.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';

import 'event_dtos.dart';
import 'event_local_service.dart';
import 'event_remote_service.dart';

class EventRepository implements IEventRepository{
  final EventRemoteService _eventRemoteService;
  final EventLocalService _eventLocalService;

  EventRepository(this._eventRemoteService, this._eventLocalService);

  @override
  Future<Either<EventFailure, List<Event>>> getList(Operation operation, {Profile profile}) async{
    try {
      final eventDto = EventDto.fromDomain(event);
      //function implementation
      return right(List<EventDto>);
    }  on PlatformException catch (e) {
      if (e.message.contains('PERMISSION_DENIED')) {
        return left(const EventFailure.insufficientPermissions());
      } else {
        return left(const EventFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<EventFailure, Event>> getSingle(Operation operation, {Profile profile}) async{
    try {
      final eventDto = EventDto.fromDomain(event);
      //function implementation
      return right(EventDto);
    }  on PlatformException catch (e) {
      if (e.message.contains('PERMISSION_DENIED')) {
        return left(const EventFailure.insufficientPermissions());
      } else {
        return left(const EventFailure.unexpected());
      }
    }
  }
  @override
  Future<Either<EventFailure, Unit>> create(Event event) async {
    try {
      final eventDto = EventDto.fromDomain(event);
      //function implementation
      return right(unit);
    }  on PlatformException catch (e) {
      if (e.message.contains('PERMISSION_DENIED')) {
        return left(const EventFailure.insufficientPermissions());
      } else {
        return left(const EventFailure.unexpected());
      }
    }
  }
  @override
  Future<Either<EventFailure, Unit>> update(Event event) async {
    try {
      final eventDto = EventDto.fromDomain(event);
      //function implementation
      return right(unit);
    }  on PlatformException catch (e) {
      if (e.message.contains('PERMISSION_DENIED')) {
        return left(const EventFailure.insufficientPermissions());
      } else if (e.message.contains('NOT_FOUND')) {
        return left(const EventFailure.unableToUpdate());
      } else {
        return left(const EventFailure.unexpected());
      }
    }
  }
  @override
  Future<Either<EventFailure, Unit>> delete(Event event) async{
    try {
      final eventDto = EventDto.fromDomain(event);
      //function implementation
      return right(unit);
    }  on PlatformException catch (e) {
      if (e.message.contains('PERMISSION_DENIED')) {
        return left(const EventFailure.insufficientPermissions());
      } else {
        return left(const EventFailure.unexpected());
      }
    }
  }
}