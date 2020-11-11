import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_frontend/domain/auth/user.dart';
import 'package:flutter_frontend/domain/auth/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
abstract class UserDto with _$UserDto {
  const UserDto._();

  const factory UserDto({
    @required String id,
    @required String username,
    @JsonKey(includeIfNull: false) String emailAddress,
  }) = _UserDto;

  factory UserDto.fromDomain(User user) {
    return UserDto(
      id: user.id.getOrCrash(),
      username: user.username.getOrCrash(),
      emailAddress: user.email.getOrCrash(),
    );
  }

  User toDomain() {
    return User(
      id: UniqueId.fromUniqueString(id.toString()),
      username: Username(username),
      email: emailAddress == null ? EmailAddress.notProvided() : EmailAddress(emailAddress)
    );
  }

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);
}