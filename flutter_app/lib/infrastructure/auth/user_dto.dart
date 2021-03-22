import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/domain/auth/user.dart';
import 'package:flutter_frontend/domain/auth/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto extends BaseDto implements _$UserDto {
  const UserDto._();

  const factory UserDto({
    required String id,
    required String username,
    @Default("") @JsonKey(includeIfNull: true) String emailAddress, //TODO: Make this either
  }) = _UserDto;

  factory UserDto.fromDomain(User user) {
    return UserDto(
      id: user.id.getOrCrash(),
      username: user.username.getOrCrash(),
      emailAddress: user.email.getOrCrash(),
    );
  }

  @override
  User toDomain() {
    return User(
      id: UniqueId.fromUniqueString(id.toString()),
      username: Username(username),
      email: emailAddress == null ? EmailAddress.notProvided() : EmailAddress(emailAddress)
    );
  }

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  factory UserDto.fromFirebase(firebase.User firebaseUser) {
    return UserDto(
      id: firebaseUser.uid,
      username: firebaseUser.displayName,
      emailAddress: firebaseUser.email,
    );
  }
}