import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/errors.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/i_event_repository.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions_handler.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/event/event_local_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_remote_service.dart';

// TODO ignored this it's too late and seems to be in progress

class EventRepository {
  final EventRemoteService _eventRemoteService;
  final EventLocalService _eventLocalService;

  EventRepository(this._eventRemoteService, this._eventLocalService);

  @override
  Future<Either<NetWorkFailure, List<Event>>> getList(
      Operation operation, DateTime lastEventTime, int amount,
      {Profile? profile, bool descending = false, String? searchString}) async {
    try {
      List<EventDto> eventDtos;
      switch (operation) {
        case Operation.search:
          if (searchString == null) {
            throw UnexpectedTypeError();
          }
          eventDtos = await _eventRemoteService.getSearchedEvents(
              searchString, amount, lastEventTime);
          break;
        case Operation.owned:
          eventDtos = await _eventRemoteService.getOwnedEvents(
              lastEventTime, amount, descending);
          break;
        case Operation.fromUser:
          if (profile == null) {
            throw UnexpectedTypeError();
          }
          eventDtos = await _eventRemoteService.getEventsFromUser(lastEventTime,
              amount, profile.id.getOrCrash().toString(), descending);
          break;
        case Operation.attending:
          eventDtos = await _eventRemoteService.getAttendingEvents(
              lastEventTime, amount);
          break;
        case Operation.unreacted:
          eventDtos = await _eventRemoteService.getUnreactedEvents(
              lastEventTime, amount);
          break;
      }
      //convert the dto objects to domain Objects
      List<Event> events = eventDtos.map((edto) => edto.toDomain()).toList();
      return right(events);
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, Event>> getSingle(UniqueId id) async {
    try {
      final EventDto eventDto =
          await _eventRemoteService.getSingle(id.getOrCrash());
      final Event event = eventDto.toDomain();
      return right(event);
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, Event>> create(Event event) async {
    try {
      final eventDto = EventDto.fromDomain(event);
      EventDto returnedEvent = await _eventRemoteService.createEvent(eventDto);
      return right(returnedEvent.toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, Event>> update(Event event) async {
    try {
      final eventDto = EventDto.fromDomain(event);
      EventDto returnedEvent = await _eventRemoteService.updateEvent(eventDto);
      return right(returnedEvent.toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  @override
  Future<Either<NetWorkFailure, Event>> delete(Event event) async {
    try {
      final eventDto = EventDto.fromDomain(event);
      EventDto returnedEvent = await _eventRemoteService.deleteEvent(eventDto);
      return right(returnedEvent.toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }
}
