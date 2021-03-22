import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter_frontend/l10n/constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/domain/auth/user.dart';
import 'package:flutter_frontend/domain/auth/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto extends BaseDto with _$UserDto {
  const UserDto._();

  const factory UserDto({
    required String id,
    required String username,
    @JsonKey(includeIfNull: false) String? emailAddress,
  }) = _UserDto;

  factory UserDto.fromDomain(User user) {
    return UserDto(
      id: user.id.getOrCrash(),
      username: user.username.getOrCrash(),
      emailAddress: user.email.fold(
        () => null, 
        (EmailAddress emailAddress) => emailAddress.getOrCrash()
      ),
    );
  }

  @override
  User toDomain() {
    return User(
      id: UniqueId.fromUniqueString(id.toString()),
      username: Username(username),
      email: emailAddress == null ? none() : some(EmailAddress(emailAddress!)),
    );
  }

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  factory UserDto.fromFirebase(firebase.User firebaseUser) {
    return UserDto(
      id: firebaseUser.uid,
      username: firebaseUser.displayName ?? noUsernameError,
      emailAddress: firebaseUser.email,
    );
  }
}