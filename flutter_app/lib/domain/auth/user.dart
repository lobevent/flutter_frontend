import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/auth/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required UniqueId id,
    required Username username,
    required Option<EmailAddress> email,
    // TODO add more parameters as needed and create ValueObjects or Entities accordingly
    // String phoneNumber,
    // String profilePictureUrl,
  }) = _User;
}
