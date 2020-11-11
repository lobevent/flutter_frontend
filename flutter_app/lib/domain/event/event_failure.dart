import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_failure.freezed.dart';

@freezed
abstract class EventFailure with _$EventFailure {
  const factory EventFailure.unexpected() = Unexpected;
  const factory EventFailure.insufficientPermissions() = InsufficientPermissions;
  const factory EventFailure.notAuthenticated() = _NotAuthenticated;
  const factory EventFailure.notFound() = _NotFound;
  const factory EventFailure.internalServer() = _InternalServer;
  const factory EventFailure.unableToUpdate() = UnableToUpdate;
}