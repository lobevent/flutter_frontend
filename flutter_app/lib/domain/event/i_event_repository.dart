import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';

import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';

// TODO rename this one since it's duplicated in domain/post/i_post_repository.dart -> really confusing

/// For determination of the lists to load
/// For example an list of owned events, an list of an user or an feed
enum Operation{
  owned,
  fromUser,
  attending,
  unreacted,
}

abstract class IEventRepository {
  Future <Either<EventFailure, List<Event>>> getList(Operation operation, {Profile profile});
  Future <Either<EventFailure, Event>> getSingle(Id id);
  Future<Either<EventFailure, Unit>> create(Event event);
  Future<Either<EventFailure, Unit>> update(Event event);
  Future<Either<EventFailure, Unit>> delete(Event event);
}
