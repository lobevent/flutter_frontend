import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_failure.freezed.dart';

@freezed //TODO lets make this generic
abstract class ItemFailure with _$ItemFailure {
  const factory ItemFailure.unexpected() = Unexpected;
  const factory ItemFailure.insufficientPermissions() = InsufficientPermissions;
  const factory ItemFailure.unableToUpdate() = UnableToUpdate;
  const factory ItemFailure.notAuthenticated() = _NotAuthenticated;
  const factory ItemFailure.notFound() = _NotFound;
  const factory ItemFailure.internalServer() = _InternalServer;
}