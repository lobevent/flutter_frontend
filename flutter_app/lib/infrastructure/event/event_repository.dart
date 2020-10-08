import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:flutter_frontend/domain/event/i_event_repository.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';

import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/event/event_local_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_remote_service.dart';

// TODO ignored this it's too late and seems to be in progress

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
       await _eventRemoteService.getSingleEvent(event.id)
      final eventDto = EventDto.fromDomain(event);
      //function implementation
      return right(eventDto);
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