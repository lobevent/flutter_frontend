import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/repository.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions_handler.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/event/event_local_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_remote_service.dart';

// TODO ignored this it's too late and seems to be in progress

class EventRepository extends Repository {
  final EventRemoteService _eventRemoteService;
  final EventLocalService _eventLocalService;

  EventRepository(this._eventRemoteService, this._eventLocalService);

  // --------------- simple crud operations ---------------------

  Future<Either<NetWorkFailure, Event>> create(Event event) async {
    try {
      final eventDto = EventDto.fromDomain(event);
      EventDto returnedEvent = await _eventRemoteService.createEvent(eventDto);
      return right(returnedEvent.toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  Future<Either<NetWorkFailure, Event>> update(Event event) async {
    try {
      final eventDto = EventDto.fromDomain(event);
      EventDto returnedEvent = await _eventRemoteService.updateEvent(eventDto);
      return right(returnedEvent.toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  Future<Either<NetWorkFailure, Event>> delete(Event event) async {
    try {
      final eventDto = EventDto.fromDomain(event);
      EventDto returnedEvent = await _eventRemoteService.deleteEvent(eventDto);
      return right(returnedEvent.toDomain());
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  // ------------------ Complex list operations ----------------------------


  ///
  ///  generic get list method, that makes the try catch
  ///
  Future<Either<NetWorkFailure, List<Event>>> _getList(
      Future<List<EventDto>> Function() repocall) async {
    try {
      final eventDtos = await repocall();
      //convert the dto objects to domain Objects
      final events = eventDtos.map((edto) => edto.toDomain()).toList();
      return right(events);
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }

  Future<Either<NetWorkFailure, List<Event>>> getOwnedEvents(
      DateTime lastEventTime, int amount,
      {bool descending = false}) async {
    return _getList(() =>
        _eventRemoteService.getOwnedEvents(lastEventTime, amount, descending));
  }

  Future<Either<NetWorkFailure, List<Event>>> searchEvent(
      DateTime lastEventTime, int amount, String searchString,
      {bool descending = false}) async {
    return _getList(() => _eventRemoteService.getSearchedEvents(
        searchString, amount, lastEventTime));
  }

  Future<Either<NetWorkFailure, List<Event>>> getEventsFromUser(
      DateTime lastEventTime, int amount, Profile profile,
      {bool descending = false}) async {
    return _getList(() => _eventRemoteService.getEventsFromUser(
        lastEventTime, amount, profile.id, descending));
  }

  Future<Either<NetWorkFailure, List<Event>>> getAttendingEvents(
      DateTime lastEventTime, int amount) async {
    return _getList(
        () => _eventRemoteService.getAttendingEvents(lastEventTime, amount));
  }

  Future<Either<NetWorkFailure, List<Event>>> getUnreactedEvents(
      DateTime lastEventTime, int amount) async {
    return _getList(
        () => _eventRemoteService.getUnreactedEvents(lastEventTime, amount));
  }

  Future<Either<NetWorkFailure, Event>> getSingle(UniqueId id) async {
    try {
      final EventDto eventDto = await _eventRemoteService.getSingle(id);
      final Event event = eventDto.toDomain();
      return right(event);
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }


  // Future<Either<NetWorkFailure, bool>> sendInvitation(Event event, Profile profile)async{
  //   return localErrorHandler(() async {
  //
  //   });
  // }
  //

}
