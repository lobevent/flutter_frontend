import 'package:dartz/dartz.dart';

import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';

// TODO rename this one since it's duplicated in domain/post/i_post_repository.dart -> really confusing
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
