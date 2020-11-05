import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
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
      List<EventDto> eventDtos;
      switch(operation) {
        case Operation.owned:
          eventDtos = await _eventRemoteService.getOwnedEvents();
          break;
        case Operation.fromUser:
          // TODO: Handle this case.
          break;
        case Operation.attending:
          eventDtos = await _eventRemoteService.getAttendingEvents();
          break;
        case Operation.unreacted:
          eventDtos = await _eventRemoteService.getUnreactedEvents();
          break;
      }
      //convert the dto objects to domain Objects
      List<Event> events =  eventDtos.map((edto) => edto.toDomain()).toList();
      return right(events);
    }  on PlatformException catch (e) {
      if (e.message.contains('PERMISSION_DENIED')) {
        return left(const EventFailure.insufficientPermissions());
      } else {
        return left(const EventFailure.unexpected());
      }
    }
  }

  @override
  Future<Either<EventFailure, Event>> getSingle(Id id) async{
    try {
       final EventDto eventDto = await _eventRemoteService.getSingle(id.getOrCrash());
       final Event event = eventDto.toDomain();
      return right(event);
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