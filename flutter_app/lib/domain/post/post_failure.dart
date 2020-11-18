import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_failure.freezed.dart';

@freezed
abstract class PostFailure with _$PostFailure {
  const factory PostFailure.unexpected() = Unexpected;
  const factory PostFailure.insufficientPermissions() = InsufficientPermissions;
  const factory PostFailure.unableToUpdate() = UnableToUpdate;
  const factory PostFailure.notAuthenticated() = _NotAuthenticated;
  const factory PostFailure.notFound() = _NotFound;
  const factory PostFailure.internalServer() = _InternalServer;
}