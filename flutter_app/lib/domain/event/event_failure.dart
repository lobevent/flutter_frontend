import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_failure.freezed.dart';

@freezed
class EventFailure with _$EventFailure {
  const factory EventFailure.unexpected() = Unexpected;
  const factory EventFailure.insufficientPermissions() =
      InsufficientPermissions;
  const factory EventFailure.notAuthenticated() = NotAuthenticated;
  const factory EventFailure.notFound() = NotFound;
  const factory EventFailure.internalServer() = InternalServer;
  const factory EventFailure.unableToUpdate() = UnableToUpdate;
}
