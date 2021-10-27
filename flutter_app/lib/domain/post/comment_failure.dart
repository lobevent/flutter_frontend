import 'package:freezed_annotation/freezed_annotation.dart';

part 'comment_failure.freezed.dart';

@freezed
class CommentFailure with _$CommentFailure {
  const factory CommentFailure.unexpected() = Unexpected;
  const factory CommentFailure.insufficientPermissions() =
      InsufficientPermissions;
  const factory CommentFailure.unableToUpdate() = UnableToUpdate;
  const factory CommentFailure.notAuthenticated() = _NotAuthenticated;
  const factory CommentFailure.notFound() = _NotFound;
  const factory CommentFailure.internalServer() = _InternalServer;
}
