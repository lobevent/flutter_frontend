import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:flutter_frontend/domain/event/i_event_repository.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';

import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/event/event_local_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_remote_service.dart';

// TODO ignored this it's too late and seems to be in progress

class EventRepository implements IEventRepository {
  final EventRemoteService _eventRemoteService;
  final EventLocalService _eventLocalService;

  EventRepository(this._eventRemoteService, this._eventLocalService);

  @override
  Future<Either<EventFailure, List<Event>>> getList(Operation operation,
      {Profile profile}) async {
    try {
      List<EventDto> eventDtos;
      switch (operation) {
        case Operation.owned:
          eventDtos = await _eventRemoteService.getOwnedEvents();
          break;
        case Operation.fromUser:
          throw UnimplementedError();
          break;
        case Operation.attending:
          eventDtos = await _eventRemoteService.getAttendingEvents();
          break;
        case Operation.unreacted:
          eventDtos = await _eventRemoteService.getUnreactedEvents();
          break;
      }
      //convert the dto objects to domain Objects
      List<Event> events = eventDtos.map((edto) => edto.toDomain()).toList();
      return right(events);
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<EventFailure, Event>> getSingle(Id id) async {
    try {
      final EventDto eventDto =
          await _eventRemoteService.getSingle(id.getOrCrash());
      final Event event = eventDto.toDomain();
      return right(event);
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<EventFailure, Event>> create(Event event) async {
    try {
      final eventDto = EventDto.fromDomain(event);
      EventDto returnedEvent = await _eventRemoteService.createEvent(eventDto);
      return right(returnedEvent.toDomain());
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<EventFailure, Event>> update(Event event) async {
    try {
      final eventDto = EventDto.fromDomain(event);
      EventDto returnedEvent = await _eventRemoteService.updateEvent(eventDto);
      return right(returnedEvent.toDomain());
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<EventFailure, Event>> delete(Event event) async {
    try {
      final eventDto = EventDto.fromDomain(event);
      EventDto returnedEvent = await _eventRemoteService.deleteEvent(eventDto);
      return right(returnedEvent.toDomain());
    } on CommunicationException catch (e) {
      return left(_reactOnCommunicationException(e));
    }
  }

  EventFailure _reactOnCommunicationException(CommunicationException e) {
    switch (e.runtimeType) {
      case NotFoundException:
        return const EventFailure.notFound();
        break;
      case InternalServerException:
        return const EventFailure.internalServer();
        break;
      case NotAuthenticatedException:
        return const EventFailure.notAuthenticated();
        break;
      case NotAuthorizedException:
        return const EventFailure.insufficientPermissions();
        break;
      case UnexpectedFormatException:
        return const EventFailure.unexpected();
      default:
        return const EventFailure.unexpected();
        break;
    }
  }
}
