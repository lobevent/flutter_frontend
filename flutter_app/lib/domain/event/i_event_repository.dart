import 'package:dartz/dartz.dart';


import '../profile/profile.dart';
import 'event.dart';
import 'event_failure.dart';

enum Operation{
  owned,
  fromUser,
}

abstract class IEventRepository {

  Future <Either<EventFailure, List<Event>>> getList(Operation operation, {Profile profile});
  Future <Either<EventFailure, Event>> getSingle(Operation operation, {Profile profile});
  Future<Either<EventFailure, Unit>> create(Event event);
  Future<Either<EventFailure, Unit>> update(Event event);
  Future<Either<EventFailure, Unit>> delete(Event event);
}
