import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_failure.freezed.dart';

@freezed //TODO real erros
abstract class ProfileFailure with _$ProfileFailure {
  const factory ProfileFailure.unexpected() = Unexpected;
  const factory ProfileFailure.insufficientPermissions() = InsufficientPermissions;
  const factory ProfileFailure.unableToUpdate() = UnableToUpdate;
}