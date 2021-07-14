import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';

import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/event/event.dart';

// TODO rename this one since it's duplicated in domain/post/i_post_repository.dart -> really confusing

/// For determination of the lists to load
/// For example an list of owned events, an list of an user or an feed
enum Operation { owned, fromUser, attending, unreacted, search }

abstract class IEventRepository {
  Future<Either<NetWorkFailure, List<Event>>> getList(
      Operation operation, DateTime lastEventTime, int amount,
      {Profile profile});
  Future<Either<NetWorkFailure, Event>> getSingle(UniqueId id);
  Future<Either<NetWorkFailure, Event>> create(Event event);
  Future<Either<NetWorkFailure, Event>> update(Event event);
  Future<Either<NetWorkFailure, Event>> delete(Event event);
}
